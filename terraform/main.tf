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
    name = "kv-matchmaking-secret"
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
    address_space       = ["10.0.0.0/8"]
}

# Subnet pour Azure Database for MySQL Flexible Server
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

# Subnet pour l'Azure Container Instance (ACI)
resource "azurerm_subnet" "aci" {
  name                 = "aci-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.4.0/24"]
  service_endpoints    = ["Microsoft.ContainerRegistry", "Microsoft.Storage"]

  delegation {
    name = "aci-delegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

}


# Subnet pour l'Azure Container App Environment
resource "azurerm_subnet" "aca_subnet" {
    name                 = "snet-aca"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.0.2.0/24"]

    service_endpoints = ["Microsoft.KeyVault", "Microsoft.Web", "Microsoft.Storage"]

    delegation {
        name = "webapp-delegation"
        service_delegation {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
    }
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

# Crée une Private DNS Zone pour Azure Database for MySQL
resource "azurerm_private_dns_zone" "mysql_dns" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

# Lien entre le Private DNS Zone et le VNet
resource "azurerm_private_dns_zone_virtual_network_link" "mysql_link" {
  name                  = "mysql-link"
  private_dns_zone_name = azurerm_private_dns_zone.mysql_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = azurerm_resource_group.rg.name
}

# Crée un Azure Database for MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "db" {
    name = "db-matchmakingtest"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    version = "8.0.21"
    administrator_login = var.db_admin_user
    administrator_password = var.db_admin_password
    zone = "3"

    sku_name = "B_Standard_B1ms"
    storage {
        size_gb = 20
    }
    backup_retention_days  = 7
    delegated_subnet_id = azurerm_subnet.db_subnet.id
    private_dns_zone_id = azurerm_private_dns_zone.mysql_dns.id 
    depends_on = [azurerm_private_dns_zone_virtual_network_link.mysql_link]
}

# Désactive l'exigence SSL pour les connexions (pour simplifier le développement)
resource "azurerm_mysql_flexible_server_configuration" "no_ssl" {
  name                = "require_secure_transport"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.db.name
  value               = "OFF"
}

# Crée une base de données MySQL Flexible Server
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

# Crée un Azure Service Plan pour la webapp
resource "azurerm_service_plan" "main" {
  name                = "advancedmatchmaking-asp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

# Attribution des rôles nécessaires à la webapp
resource "azurerm_role_assignment" "webapp_contributor" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_linux_web_app.main.identity[0].principal_id
}

# Attribution du rôle AcrPull à la webapp pour accéder à l'ACR
resource "azurerm_role_assignment" "webapp_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.main.identity[0].principal_id
  depends_on           = [azurerm_linux_web_app.main]
}


# Crée une Azure Linux Web App pour héberger l'application Django
resource "azurerm_linux_web_app" "main" {
  name                = "advancedmatchmaking-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id

  # Managed Identity pour l'accès à l'ACR et Key Vault
  identity {
    type = "SystemAssigned"
  }


  # Intégration au VNet
  virtual_network_subnet_id = azurerm_subnet.aca_subnet.id


  depends_on = [
        azurerm_container_registry.acr,
        azurerm_mysql_flexible_server_configuration.no_ssl
    ]

  site_config {
    minimum_tls_version = "1.2"
    ftps_state          = "Disabled"

    container_registry_use_managed_identity = true
    vnet_route_all_enabled = true
    application_stack {

      docker_image_name   = "django-web:v1"
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
    }
  }

  app_settings = {
    "DATABASE_NAME" = azurerm_mysql_flexible_database.db_data.name
    "DATABASE_USER" = azurerm_mysql_flexible_server.db.administrator_login
    "DATABASE_HOST" = azurerm_mysql_flexible_server.db.fqdn
    "DATABASE_PASSWORD" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.db_password_secret.id})"
  }

}

# Politique d'accès pour permettre à la webapp d'accéder aux secrets du Key Vault
resource "azurerm_key_vault_access_policy" "webapp" {
  depends_on = [
    azurerm_linux_web_app.main
  ]
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.main.identity[0].principal_id

  secret_permissions = [
    "Get", "List"
  ]
}

# A commenter pour le premier terraform apply puis décommenter pour la suite

# trigger quand init.db change (ou son dockerfile) (pour pas destroy la db a chaque terraform apply)

resource "azurerm_user_assigned_identity" "aci_db_init_identity" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "aci-db-init-identity"
}

# Attribution du rôle AcrPull à l'ACI pour accéder à l'ACR
resource "azurerm_role_assignment" "aci_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.aci_db_init_identity.principal_id

  depends_on = [
    azurerm_container_registry.acr,
    azurerm_user_assigned_identity.aci_db_init_identity
  ]
}

# Build et push de l'image Docker pour l'initialisation de la DB
resource "null_resource" "build_and_push_db_init" {
  triggers = {
    file_hash = filemd5("db-init/Dockerfile")
    sql_hash  = filemd5("db-init/init.sql")
  }

  provisioner "local-exec" {
    command = "az acr build --registry ${azurerm_container_registry.acr.name} --image db-init:latest db-init/"
  }
}

# Crée un Azure Container Instance pour initialiser la base de données
resource "azurerm_container_group" "db_initializer" {
  name                = "db-init-job"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_address_type = "Private"
  os_type         = "Linux"

  subnet_ids = [azurerm_subnet.aci.id]

  restart_policy = "Never"

  # Managed Identity pour accéder à l'ACR
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aci_db_init_identity.id]
  }

  # Accès à l'ACR via l'identité managée
  image_registry_credential {
    server                    = azurerm_container_registry.acr.login_server
    user_assigned_identity_id = azurerm_user_assigned_identity.aci_db_init_identity.id
  }

  container {
    name   = "db-init-container"
    image  = "${azurerm_container_registry.acr.login_server}/db-init:latest"
    cpu    = 0.5
    memory = 1.0

    ports {
      port     = 80
      protocol = "TCP"
    }

    commands = [
      "sh",
      "-c",
      "mariadb -h ${azurerm_mysql_flexible_server.db.name}.mysql.database.azure.com -u ${var.db_admin_user} -p${var.db_admin_password} --ssl ${azurerm_mysql_flexible_database.db_data.name} < /init-db.sql"
    ]


  }

  depends_on = [
    null_resource.build_and_push_db_init,
    azurerm_role_assignment.aci_acr_pull,
    azurerm_mysql_flexible_server.db,
    azurerm_private_dns_zone_virtual_network_link.mysql_link
  ]
}