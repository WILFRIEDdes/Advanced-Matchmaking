variable "resource_group_name" {
  description = "Nom du groupe de ressources principal"
  default = "rg-matchmaking-app"
}

variable "location" {
  description = "Région Azure pour le déploiement"
  default = "France Central"
}

variable "acr_name" {
  description = "Nom de l'Azure Container Registry"
  default = "matchmakingregistry"
}

# Variables de la Base de Données (MySQL)
variable "db_admin_user" {
  description = "Nom d'utilisateur administrateur de la DB MySQL"
  default = "user"
}

variable "db_admin_password" {
  description = "Mot de passe administrateur de la DB MySQL"
  type = string
  sensitive = true # Masque l'entrée et la sortie
}