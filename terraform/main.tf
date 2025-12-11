# Crée un groupe de ressources pour l'application
resource "azurerm_resource_group" "rg" {
    name = var.resource_group_name
    location = var.location
}

# Crée un espace de travail Log Analytics pour Azure Container Apps
resource "azurerm_log_analytics_workspace" "logs" {
    name = "log-matchmaking"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    sku = "PerGB2018"
}

# Crée de l'instance Key Vault
resource "azurerm_key_vault" "kv" {
    name = "kv-matchmaking-secrets"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    sku_name = "standard"
    tenant_id = data.azurerm_client_config.current.tenant_id
    soft_delete_retention_days  = 7 
}

# Nécessite de récupérer le tenant_id de l'utilisateur/principal de service Terraform
data "azurerm_client_config" "current" {}

# Politique d'accès pour permettre à Terraform de gérer les secrets
resource "azurerm_key_vault_access_policy" "terraform_writer_policy" {
    key_vault_id = azurerm_key_vault.kv.id
    
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
        "Delete", 
        "Get", 
        "List", 
        "Set",
        "Purge"
    ]
}

# Ajout du Secret (Mot de passe de la DB) au Key Vault
resource "azurerm_key_vault_secret" "db_password_secret" {
    name = "db-password"
    value = var.db_admin_password
    key_vault_id = azurerm_key_vault.kv.id
    
    depends_on = [
        azurerm_key_vault_access_policy.terraform_writer_policy
    ]
}

# Crée le Réseau Virtuel
resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-matchmaking"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space       = ["10.0.0.0/16"]
}

# Subnet 1 : Délégué pour Azure Database for MySQL Flexible Server
resource "azurerm_subnet" "db_subnet" {
    name                 = "snet-db-delegated"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.0.1.0/24"]
    
    delegation {
        name = "delegation"
        service_delegation {
            name    = "Microsoft.DBforMySQL/flexibleServers"
            actions = [
                "Microsoft.Network/virtualNetworks/subnets/join/action",
                "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
            ]
        }
    }
}

# Subnet 2 : Pour l'Azure Container App Environment
resource "azurerm_subnet" "aca_subnet" {
    name                 = "snet-aca"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.0.2.0/23"]
}

# Crée un Network Security Group
resource "azurerm_network_security_group" "aca_nsg" {
    name = "nsg-aca-environment"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    security_rule {
        name = "Allow_ACA_Ingress"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_ranges = ["80", "443"]
        source_address_prefix = "Internet"
        destination_address_prefix = "*"
    }

    security_rule {
        name = "Allow_Outbound_to_MySQL"
        priority = 110
        direction = "Outbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "3306"
        source_address_prefix = azurerm_subnet.aca_subnet.address_prefixes[0]
        destination_address_prefix = azurerm_subnet.db_subnet.address_prefixes[0]
    }

    security_rule {
        name = "Allow_Outbound_Internet"
        priority = 200
        direction = "Outbound"
        access = "Allow"
        protocol = "*"
        source_port_range = "*"
        destination_port_range = "*"
        source_address_prefix = "*"
        destination_address_prefix = "Internet"
    }
}

resource "azurerm_subnet_network_security_group_association" "aca_nsg_association" {
    subnet_id = azurerm_subnet.aca_subnet.id
    network_security_group_id = azurerm_network_security_group.aca_nsg.id
}

# Crée une Azure Database for MySQL
resource "azurerm_mysql_flexible_server" "db" {
    name = "db-matchmaking"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    version = "5.7"
    administrator_login = var.db_admin_user
    administrator_password = var.db_admin_password

    sku_name = "B_Standard_B1ms"
    storage {
        size_gb = 20
    }
    backup_retention_days  = 7
    delegated_subnet_id = azurerm_subnet.db_subnet.id
}

resource "azurerm_mysql_flexible_database" "db_data" {
    name = "matchmakingDB"
    server_name = azurerm_mysql_flexible_server.db.name
    resource_group_name = azurerm_resource_group.rg.name
    charset = "utf8"
    collation = "utf8_general_ci"
}

# Crée un Azure Container Registry
resource "azurerm_container_registry" "acr" {
    name = var.acr_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    sku = "Basic"
    admin_enabled = true
}

# Crée un environnement pour Azure Container Apps
resource "azurerm_container_app_environment" "env" {
    name = "cae-matchmaking-env"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id
    infrastructure_subnet_id = azurerm_subnet.aca_subnet.id 
    internal_load_balancer_enabled = true
    depends_on = [
        azurerm_virtual_network.vnet,
        azurerm_subnet.aca_subnet,
    ]
}

# Attribution du rôle "AcrPull" à l'ACA pour accéder au ACR
resource "azurerm_role_assignment" "acr_pull_role" {
    scope = azurerm_container_registry.acr.id
    role_definition_name = "AcrPull"
    principal_id = azurerm_container_app.web_app.identity[0].principal_id
}

# Crée l'Azure Container App pour l'application web Django
resource "azurerm_container_app" "web_app" {
    name = "web-matchmaking"
    container_app_environment_id = azurerm_container_app_environment.env.id
    resource_group_name = azurerm_resource_group.rg.name
    revision_mode = "Single"

    identity {
        type = "SystemAssigned"
    }

    secret {
        name = "db-password-app" 
        value = azurerm_key_vault_secret.db_password_secret.value
    }

    registry {
        server = azurerm_container_registry.acr.login_server
        identity = "System"
    }

    # Configuration de la réplique
    template {
        container {
            name = "django-web"
            image = "${var.acr_name}.azurecr.io/django-web:v1"
            cpu = 1.0
            memory = "2.0Gi"

            # Variables d'environnement pour l'application Django
            env {
                name = "DATABASE_NAME"
                value = azurerm_mysql_flexible_database.db_data.name
            }
            env {
                name = "DATABASE_USER"
                value = azurerm_mysql_flexible_server.db.administrator_login
            }
            env {
                name = "DATABASE_HOST"
                value = azurerm_mysql_flexible_server.db.fqdn
            }
            env {
                name = "DATABASE_PASSWORD"
                secret_name = "db-password-app"
            }
        }
    }

    # Configuration d'entrée (Port 8000 exposé)
    ingress {
        external_enabled = true
        target_port = 8000
        transport = "auto"
        traffic_weight {
            latest_revision = true
            percentage = 100
        }
    }
}