# Advanced Matchmaking App - TeamBuilding

## Description
TeamBuilding est une application web conçue pour aider les entreprises à former facilement des équipes de projet correspondant à des exigences spécifiées. Elle inclut un système de "matchmaking" conçu pour faciliter l'appariement optimal entre les utilisateurs et les projets en maximisant la compatibilité et la satisfaction. Notre idée est de développer un algorithme qui prend en compte les compétences, les préférences et la disponibilité des utilisateurs, ainsi que les besoins spécifiques de chaque projet. Ce système aidera non seulement à former des équipes équilibrées et performantes, mais assurera également une expérience enrichissante pour les participants et une plus grande efficacité pour les projets.

## Fonctionnalités

### Fonctionnalités Manager
* Voir tous les projets (en cours, passés, à venir).
* Attribuer des équipes aux projets qui n'en ont pas encore.
* Remplir une enquête de satisfaction pour les projets passés (à des fins de démonstration).
* Créer de nouveaux projets.
* Voir la liste des employés.
* Modifier le profil personnel :
    * Changer le mot de passe.
    * Mettre à jour les compétences.
    * Définir la mobilité (sur site ou à distance).
    * Définir la disponibilité.

### Fonctionnalités Employé
* Voir uniquement les projets dans lesquels ils sont impliqués (en cours, passés, à venir).
* Modifier le profil personnel (mêmes champs que les managers).
* Remplir des enquêtes de satisfaction pour les projets terminés.

---

## Architecture et Déploiement Azure (Production)

### Vue d'ensemble de l'Architecture
L'application est déployée sur **Azure App Service pour Conteneurs (Linux)**, garantissant une connexion sécurisée à la base de données via un Réseau Virtuel (VNet) privé.

* **IaC (Infrastructure as Code) :** L'infrastructure est gérée via **Terraform**.
* **Conteneurisation :** L'application web Python/Django est conteneurisée (image `django-web:v1`) et stockée dans un **Azure Container Registry (ACR)**.
* **Base de Données :** **Azure Database for MySQL Flexible Server** est déployé avec une connexion privée, garantissant que le trafic de la base de données ne quitte jamais le Réseau Virtuel.
* **Réseau :** L'App Service est intégré au VNet pour accéder en privé à la base de données MySQL.
* **Sécurité des Secrets :** Le mot de passe de l'administrateur de la base de données est stocké dans un **Azure Key Vault (KV)**. L'App Service utilise son identité gérée (System Assigned Identity) pour accéder au secret et à l'ACR (rôle `AcrPull`).


### Prérequis

Avant de commencer le déploiement, assurez-vous que les outils suivants sont installés et configurés :

* **Docker**
* **Azure CLI** (authentifié avec `az login`)
* **Terraform**

---

## Procédure de Déploiement sur Azure

### 1. Déploiement de l'Infrastructure avec Terraform

a. **Initialisation :** Naviguez vers le répertoire "terraform" et initialisez Terraform.
```bash
terraform init
```
b. **Planification et Application :** Exécutez le plan pour visualiser les ressources, puis appliquez la configuration.
```bash
terraform plan
terraform apply
```
*(Vous devrez fournir les valeurs des variables, notamment `db_admin_password`).*

### 2. Préparation du Code et de l'Image
    
**Construction et Push de l'Image Docker :**
Nous construisons l'image de l'application et la publions dans l'ACR.

a. **Construisez l'image :** (Assurez-vous d'être dans le répertoire racine du projet)
Le login_serveur peut être obtenu avec la commande suivante :
```bash
$ACR_LOGIN_SERVER = (terraform output -raw acr_login_server).Trim()
```
Effectuez ensuite cette commande afin de build l'image docker :
```bash
docker build -t "$ACR_LOGIN_SERVER/django-web:v1" .
```

b. **Authentifiez-vous auprès de l'ACR :**
L'acr_name peut être obtenu avec la commande suivante :
```bash
$ACR_NAME = (terraform output -raw acr_name).Trim()
```
Puis effectuez cette commande :
```bash
az acr login --name $ACR_NAME
```

c. **Taguez et poussez l'image vers l'ACR :**
```bash
docker push $ACR_NAME.azurecr.io/django-web:v1
```

### 3. Accès à l'Application

Une fois le déploiement réussi, l'application est accessible via l'URL de votre App Service. Vous trouverez cette URL dans l'App Service du portail Azure.
Normalement il devrait s'agir de ce lien :
https://advancedmatchmaking-app.azurewebsites.net/matchmakingApp/

### Utilisateurs de Test (Post-Déploiement)

Après le déploiement et l'initialisation de la base de données par l'application, vous pouvez utiliser les comptes suivants pour tester les différentes vues et fonctionnalités de notre application:

| Rôle | Adresse Email | Mot de Passe |
| :--- | :--- | :--- |
| **Manager** | `doe.john@example.com` | `johnXD42!` |
| **Employé** | `bon.jean@example.com` | `jeanXD42!` |
| **Admin** | `messi.cristiano@example.com` | `admin` |

**Les fonctionnalités les plus intéressantes à tester sont celles du rôle Manager**, car elles impliquent la création de projets, la gestion des équipes et l'utilisation potentielle de l'algorithme de "matchmaking" central de l'application.