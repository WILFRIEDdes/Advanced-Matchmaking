# output "web_app_url" {
#   description = "URL d'accès à l'application Django"
#   value = azurerm_container_app.web_app.ingress[0].fqdn
# }

output "acr_name" {
  description = "Nom de l'Azure Container Registry"
  value = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  description = "Serveur de connexion de l'ACR pour le 'docker push'"
  value = azurerm_container_registry.acr.login_server
}