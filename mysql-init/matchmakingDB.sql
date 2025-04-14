-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Hôte : db:3306
-- Généré le : lun. 14 avr. 2025 à 13:25
-- Version du serveur : 9.2.0
-- Version de PHP : 8.2.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `matchmakingDB`
--

-- --------------------------------------------------------

--
-- Structure de la table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add content type', 4, 'add_contenttype'),
(14, 'Can change content type', 4, 'change_contenttype'),
(15, 'Can delete content type', 4, 'delete_contenttype'),
(16, 'Can view content type', 4, 'view_contenttype'),
(17, 'Can add session', 5, 'add_session'),
(18, 'Can change session', 5, 'change_session'),
(19, 'Can delete session', 5, 'delete_session'),
(20, 'Can view session', 5, 'view_session'),
(21, 'Can add competence', 6, 'add_competence'),
(22, 'Can change competence', 6, 'change_competence'),
(23, 'Can delete competence', 6, 'delete_competence'),
(24, 'Can view competence', 6, 'view_competence'),
(25, 'Can add equipe', 7, 'add_equipe'),
(26, 'Can change equipe', 7, 'change_equipe'),
(27, 'Can delete equipe', 7, 'delete_equipe'),
(28, 'Can view equipe', 7, 'view_equipe'),
(29, 'Can add utilisateur', 8, 'add_utilisateur'),
(30, 'Can change utilisateur', 8, 'change_utilisateur'),
(31, 'Can delete utilisateur', 8, 'delete_utilisateur'),
(32, 'Can view utilisateur', 8, 'view_utilisateur'),
(33, 'Can add mobilite equipe', 9, 'add_mobiliteequipe'),
(34, 'Can change mobilite equipe', 9, 'change_mobiliteequipe'),
(35, 'Can delete mobilite equipe', 9, 'delete_mobiliteequipe'),
(36, 'Can view mobilite equipe', 9, 'view_mobiliteequipe'),
(37, 'Can add disponibilite', 10, 'add_disponibilite'),
(38, 'Can change disponibilite', 10, 'change_disponibilite'),
(39, 'Can delete disponibilite', 10, 'delete_disponibilite'),
(40, 'Can view disponibilite', 10, 'view_disponibilite'),
(41, 'Can add equipe competencebonus', 11, 'add_equipecompetencebonus'),
(42, 'Can change equipe competencebonus', 11, 'change_equipecompetencebonus'),
(43, 'Can delete equipe competencebonus', 11, 'delete_equipecompetencebonus'),
(44, 'Can view equipe competencebonus', 11, 'view_equipecompetencebonus'),
(45, 'Can add equipe competencecouvrante', 12, 'add_equipecompetencecouvrante'),
(46, 'Can change equipe competencecouvrante', 12, 'change_equipecompetencecouvrante'),
(47, 'Can delete equipe competencecouvrante', 12, 'delete_equipecompetencecouvrante'),
(48, 'Can view equipe competencecouvrante', 12, 'view_equipecompetencecouvrante'),
(49, 'Can add equipe membre', 13, 'add_equipemembre'),
(50, 'Can change equipe membre', 13, 'change_equipemembre'),
(51, 'Can delete equipe membre', 13, 'delete_equipemembre'),
(52, 'Can view equipe membre', 13, 'view_equipemembre'),
(53, 'Can add preference competence', 14, 'add_preferencecompetence'),
(54, 'Can change preference competence', 14, 'change_preferencecompetence'),
(55, 'Can delete preference competence', 14, 'delete_preferencecompetence'),
(56, 'Can view preference competence', 14, 'view_preferencecompetence'),
(57, 'Can add preference utilisateur', 15, 'add_preferenceutilisateur'),
(58, 'Can change preference utilisateur', 15, 'change_preferenceutilisateur'),
(59, 'Can delete preference utilisateur', 15, 'delete_preferenceutilisateur'),
(60, 'Can view preference utilisateur', 15, 'view_preferenceutilisateur'),
(61, 'Can add utilisateur competence', 16, 'add_utilisateurcompetence'),
(62, 'Can change utilisateur competence', 16, 'change_utilisateurcompetence'),
(63, 'Can delete utilisateur competence', 16, 'delete_utilisateurcompetence'),
(64, 'Can view utilisateur competence', 16, 'view_utilisateurcompetence');

-- --------------------------------------------------------

--
-- Structure de la table `Competence`
--

CREATE TABLE `Competence` (
  `id` bigint NOT NULL,
  `nom` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `Competence`
--

INSERT INTO `Competence` (`id`, `nom`) VALUES
(53, 'Administration Linux'),
(62, 'Agile / Scrum / Kanban'),
(34, 'Algorithmique'),
(12, 'Analyse de données'),
(68, 'Analyse de performances'),
(25, 'Analyse de vulnérabilités'),
(42, 'Angular'),
(60, 'Ansible'),
(23, 'Apache Airflow'),
(38, 'API REST / GraphQL'),
(52, 'Architecture logicielle'),
(56, 'AWS'),
(46, 'C'),
(48, 'C#'),
(47, 'C++'),
(3, 'Computer Vision'),
(26, 'Cryptographie'),
(22, 'Data Mining'),
(20, 'Data Warehousing'),
(2, 'Deep Learning'),
(66, 'Design patterns'),
(37, 'Développement web (Frontend + Backend)'),
(50, 'DevOps / CI-CD'),
(39, 'Django'),
(54, 'Docker'),
(19, 'ETL'),
(40, 'Flask'),
(65, 'Gestion de projet technique'),
(32, 'Gestion des identités (IAM)'),
(49, 'Git / GitHub / GitLab'),
(58, 'Google Cloud Platform (GCP)'),
(18, 'Hadoop'),
(44, 'Java'),
(9, 'Keras'),
(55, 'Kubernetes'),
(1, 'Machine Learning'),
(57, 'Microsoft Azure'),
(11, 'ML Ops'),
(61, 'Monitoring (Prometheus, Grafana)'),
(43, 'Node.js'),
(31, 'Normes ISO 27001 / RGPD'),
(15, 'NumPy'),
(10, 'OpenCV'),
(69, 'Optimisation de code'),
(14, 'Pandas'),
(29, 'Pare-feu / IDS / IPS'),
(28, 'Pentesting (Tests d’intrusion)'),
(21, 'Power BI'),
(36, 'Programmation orientée objet (POO)'),
(45, 'Python'),
(8, 'PyTorch'),
(41, 'React'),
(64, 'Rédaction de documentation technique'),
(5, 'Reinforcement Learning'),
(6, 'Scikit-learn'),
(33, 'Sécurité cloud (AWS, Azure, GCP)'),
(27, 'Sécurité des applications web'),
(67, 'Sécurité informatique'),
(24, 'Sécurité réseau'),
(30, 'SIEM (ex : Splunk, ELK)'),
(17, 'Spark'),
(16, 'SQL'),
(35, 'Structures de données'),
(7, 'TensorFlow'),
(59, 'Terraform'),
(51, 'Tests unitaires / TDD'),
(4, 'Traitement du langage naturel (NLP)\r\n\r\n'),
(63, 'UML'),
(13, 'Visualisation de données');

-- --------------------------------------------------------

--
-- Structure de la table `Disponibilite`
--

CREATE TABLE `Disponibilite` (
  `id` int NOT NULL,
  `jour` varchar(8) NOT NULL,
  `heure_debut` time(6) DEFAULT NULL,
  `heure_fin` time(6) DEFAULT NULL,
  `utilisateur_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `Disponibilite`
--

INSERT INTO `Disponibilite` (`id`, `jour`, `heure_debut`, `heure_fin`, `utilisateur_id`) VALUES
(1, 'lundi', '09:00:00.000000', '18:00:00.000000', 2),
(2, 'mardi', '09:00:00.000000', '18:00:00.000000', 2),
(3, 'mercredi', '08:30:00.000000', '13:30:00.000000', 2),
(4, 'vendredi', '09:00:00.000000', '18:00:00.000000', 2),
(5, 'lundi', '07:00:00.000000', '15:00:00.000000', 5),
(6, 'mercredi', '08:00:00.000000', '13:00:00.000000', 5),
(7, 'vendredi', '09:00:00.000000', '18:00:00.000000', 5);

-- --------------------------------------------------------

--
-- Structure de la table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint UNSIGNED NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL
) ;

--
-- Déchargement des données de la table `django_admin_log`
--

INSERT INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
(2, '2025-04-14 12:46:09.874975', '5', 'mand.steve@example.com', 1, '[{\"added\": {}}]', 8, 4);

-- --------------------------------------------------------

--
-- Structure de la table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'contenttypes', 'contenttype'),
(6, 'matchmakingApp', 'competence'),
(10, 'matchmakingApp', 'disponibilite'),
(7, 'matchmakingApp', 'equipe'),
(11, 'matchmakingApp', 'equipecompetencebonus'),
(12, 'matchmakingApp', 'equipecompetencecouvrante'),
(13, 'matchmakingApp', 'equipemembre'),
(9, 'matchmakingApp', 'mobiliteequipe'),
(14, 'matchmakingApp', 'preferencecompetence'),
(15, 'matchmakingApp', 'preferenceutilisateur'),
(8, 'matchmakingApp', 'utilisateur'),
(16, 'matchmakingApp', 'utilisateurcompetence'),
(5, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Structure de la table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2025-04-13 15:15:19.506954'),
(2, 'contenttypes', '0002_remove_content_type_name', '2025-04-13 15:15:19.571947'),
(3, 'auth', '0001_initial', '2025-04-13 15:15:19.774629'),
(4, 'auth', '0002_alter_permission_name_max_length', '2025-04-13 15:15:19.819359'),
(5, 'auth', '0003_alter_user_email_max_length', '2025-04-13 15:15:19.825103'),
(6, 'auth', '0004_alter_user_username_opts', '2025-04-13 15:15:19.831745'),
(7, 'auth', '0005_alter_user_last_login_null', '2025-04-13 15:15:19.837559'),
(8, 'auth', '0006_require_contenttypes_0002', '2025-04-13 15:15:19.840864'),
(9, 'auth', '0007_alter_validators_add_error_messages', '2025-04-13 15:15:19.845466'),
(10, 'auth', '0008_alter_user_username_max_length', '2025-04-13 15:15:19.850984'),
(11, 'auth', '0009_alter_user_last_name_max_length', '2025-04-13 15:15:19.856415'),
(12, 'auth', '0010_alter_group_name_max_length', '2025-04-13 15:15:19.870458'),
(13, 'auth', '0011_update_proxy_permissions', '2025-04-13 15:15:19.881139'),
(14, 'auth', '0012_alter_user_first_name_max_length', '2025-04-13 15:15:19.887832'),
(15, 'matchmakingApp', '0001_initial', '2025-04-13 15:15:21.298690'),
(16, 'admin', '0001_initial', '2025-04-13 15:15:21.438432'),
(17, 'admin', '0002_logentry_remove_auto_add', '2025-04-13 15:15:21.452189'),
(18, 'admin', '0003_logentry_add_action_flag_choices', '2025-04-13 15:15:21.465325'),
(19, 'sessions', '0001_initial', '2025-04-13 15:15:21.512039');

-- --------------------------------------------------------

--
-- Structure de la table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('7ayfmm4l9qpusrf16gfyhsqh7qxxnlru', '.eJxVjEEOwiAQRe_C2hAKHSgu3XsGMjOAVA0kpV0Z765NutDtf-_9lwi4rSVsPS1hjuIstDj9boT8SHUH8Y711iS3ui4zyV2RB-3y2mJ6Xg7376BgL9_as1MTGoyQB5-RPKA2dqBEbJ0iyMkZa2GyZAyDZojIFHHkkU1WmMX7A_nXOOY:1u4JM1:PyA9hyiMqme3VNf1Ku6egDidC-hUGXzgFEk3cMujTcE', '2025-04-28 12:56:01.258917');

-- --------------------------------------------------------

--
-- Structure de la table `Equipe`
--

CREATE TABLE `Equipe` (
  `id` int NOT NULL,
  `taille` int DEFAULT NULL,
  `budget_total` decimal(15,2) DEFAULT NULL,
  `heures_homme` int DEFAULT NULL,
  `score_global` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Equipe_CompetenceBonus`
--

CREATE TABLE `Equipe_CompetenceBonus` (
  `id` int NOT NULL,
  `competence_id` bigint NOT NULL,
  `equipe_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Equipe_CompetenceCouvrante`
--

CREATE TABLE `Equipe_CompetenceCouvrante` (
  `id` int NOT NULL,
  `niveau_requis` varchar(13) DEFAULT NULL,
  `competence_id` bigint NOT NULL,
  `equipe_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Equipe_Membre`
--

CREATE TABLE `Equipe_Membre` (
  `id` int NOT NULL,
  `equipe_id` int NOT NULL,
  `utilisateur_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Mobilite_Equipe`
--

CREATE TABLE `Mobilite_Equipe` (
  `id` int NOT NULL,
  `presentiel` int DEFAULT NULL,
  `distanciel` int DEFAULT NULL,
  `hybride` int DEFAULT NULL,
  `equipe_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Preference_Competence`
--

CREATE TABLE `Preference_Competence` (
  `id` int NOT NULL,
  `preference` varchar(8) DEFAULT NULL,
  `competence_id` bigint NOT NULL,
  `utilisateur_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Preference_Utilisateur`
--

CREATE TABLE `Preference_Utilisateur` (
  `id` int NOT NULL,
  `preference` varchar(8) DEFAULT NULL,
  `cible_id` int NOT NULL,
  `utilisateur_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Utilisateur`
--

CREATE TABLE `Utilisateur` (
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `id` int NOT NULL,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `mail` varchar(254) NOT NULL,
  `role` varchar(10) NOT NULL,
  `annees_experience` int NOT NULL,
  `projets_realises` int NOT NULL,
  `salaire_horaire` decimal(10,2) DEFAULT NULL,
  `moyenne_notes` decimal(3,2) DEFAULT NULL,
  `historique_notes` json DEFAULT NULL,
  `mobilite` varchar(20) DEFAULT NULL,
  `score_projet` int DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `is_staff` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `Utilisateur`
--

INSERT INTO `Utilisateur` (`password`, `last_login`, `is_superuser`, `id`, `nom`, `prenom`, `mail`, `role`, `annees_experience`, `projets_realises`, `salaire_horaire`, `moyenne_notes`, `historique_notes`, `mobilite`, `score_projet`, `is_active`, `is_staff`) VALUES
('pbkdf2_sha256$870000$pPkb9UE4zRuJTbgq2ObN0y$oNIl7b0GEjJWdj+QGeT96uyjSZJl++zgfUBQpLR/XoI=', '2025-04-14 12:56:01.254533', 0, 2, 'Doe', 'John', 'doe.john@example.com', 'manager', 0, 0, 45.30, NULL, NULL, 'mixte', NULL, 1, 0),
('pbkdf2_sha256$870000$MW4wl1QoOnTnbHt3E9XpWL$mo4RLAz0EXbUJb2gVpdtRCbl55u9GzgQEyeg0q29tYQ=', '2025-04-14 09:35:46.917322', 0, 3, 'Bon', 'Jean', 'bon.jean@example.com', 'employe', 0, 0, 32.10, NULL, NULL, 'distanciel', NULL, 1, 0),
('pbkdf2_sha256$870000$SVvmFJc5NsnKkTQKZLYw2a$eZNTipzSgJbhEGpNEUEgBSf7wAgrbrQcbVNWZLL43DA=', '2025-04-14 12:44:33.346970', 1, 4, 'Messi', 'Cristiano', 'messi.cristiano@example.com', 'admin', 0, 0, NULL, NULL, NULL, NULL, NULL, 1, 1),
('pbkdf2_sha256$870000$37PDkRAPtnHHv2r3taTHyU$FIn7jYB8IaMkprSbdYDhonfpny4cxn1FSjRqhWG/6hI=', '2025-04-14 12:46:44.186431', 0, 5, 'Mand', 'Steve', 'mand.steve@example.com', 'employe', 0, 0, 50.30, NULL, NULL, 'distanciel', NULL, 1, 0);

-- --------------------------------------------------------

--
-- Structure de la table `Utilisateur_Competence`
--

CREATE TABLE `Utilisateur_Competence` (
  `id` int NOT NULL,
  `niveau` varchar(13) DEFAULT NULL,
  `competence_id` bigint NOT NULL,
  `utilisateur_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `Utilisateur_Competence`
--

INSERT INTO `Utilisateur_Competence` (`id`, `niveau`, `competence_id`, `utilisateur_id`) VALUES
(1, 'Débutant', 53, 2),
(2, 'Débutant', 62, 2),
(3, 'Débutant', 68, 2),
(4, 'Débutant', 52, 2),
(5, 'Débutant', 56, 2),
(6, 'Débutant', 47, 2),
(7, 'Débutant', 2, 2),
(8, 'Débutant', 66, 2),
(9, 'Débutant', 37, 2),
(10, 'Débutant', 50, 2),
(11, 'Débutant', 65, 2),
(12, 'Débutant', 32, 2),
(13, 'Débutant', 58, 2),
(14, 'Débutant', 18, 2),
(15, 'Débutant', 57, 2),
(16, 'Débutant', 43, 2),
(17, 'Débutant', 15, 2),
(18, 'Débutant', 69, 2),
(19, 'Débutant', 41, 2),
(20, 'Débutant', 64, 2),
(21, 'Débutant', 33, 2),
(22, 'Débutant', 67, 2),
(23, 'Débutant', 35, 2),
(24, 'Débutant', 7, 2),
(25, 'Débutant', 63, 2),
(26, 'Débutant', 13, 2),
(27, 'Débutant', 46, 5),
(28, 'Débutant', 50, 5),
(29, 'Débutant', 65, 5),
(30, 'Débutant', 32, 5),
(31, 'Débutant', 9, 5),
(32, 'Débutant', 55, 5),
(33, 'Débutant', 43, 5),
(34, 'Débutant', 31, 5);

-- --------------------------------------------------------

--
-- Structure de la table `Utilisateur_groups`
--

CREATE TABLE `Utilisateur_groups` (
  `id` bigint NOT NULL,
  `utilisateur_id` int NOT NULL,
  `group_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Utilisateur_user_permissions`
--

CREATE TABLE `Utilisateur_user_permissions` (
  `id` bigint NOT NULL,
  `utilisateur_id` int NOT NULL,
  `permission_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Index pour la table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Index pour la table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Index pour la table `Competence`
--
ALTER TABLE `Competence`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nom` (`nom`);

--
-- Index pour la table `Disponibilite`
--
ALTER TABLE `Disponibilite`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Disponibilite_utilisateur_id_jour_heur_a2ba32c6_uniq` (`utilisateur_id`,`jour`,`heure_debut`,`heure_fin`);

--
-- Index pour la table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_Utilisateur_id` (`user_id`);

--
-- Index pour la table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Index pour la table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- Index pour la table `Equipe`
--
ALTER TABLE `Equipe`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `Equipe_CompetenceBonus`
--
ALTER TABLE `Equipe_CompetenceBonus`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `equipe_id` (`equipe_id`),
  ADD UNIQUE KEY `Equipe_CompetenceBonus_equipe_id_competence_id_bd638c1a_uniq` (`equipe_id`,`competence_id`),
  ADD KEY `Equipe_CompetenceBonus_competence_id_f85b0b29_fk_Competence_id` (`competence_id`);

--
-- Index pour la table `Equipe_CompetenceCouvrante`
--
ALTER TABLE `Equipe_CompetenceCouvrante`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `equipe_id` (`equipe_id`),
  ADD UNIQUE KEY `Equipe_CompetenceCouvrante_equipe_id_competence_id_633fa3fe_uniq` (`equipe_id`,`competence_id`),
  ADD KEY `Equipe_CompetenceCou_competence_id_1f24dc38_fk_Competenc` (`competence_id`);

--
-- Index pour la table `Equipe_Membre`
--
ALTER TABLE `Equipe_Membre`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `equipe_id` (`equipe_id`),
  ADD UNIQUE KEY `Equipe_Membre_equipe_id_utilisateur_id_d515bbd2_uniq` (`equipe_id`,`utilisateur_id`),
  ADD KEY `Equipe_Membre_utilisateur_id_3f64ab22_fk_Utilisateur_id` (`utilisateur_id`);

--
-- Index pour la table `Mobilite_Equipe`
--
ALTER TABLE `Mobilite_Equipe`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `equipe_id` (`equipe_id`);

--
-- Index pour la table `Preference_Competence`
--
ALTER TABLE `Preference_Competence`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `utilisateur_id` (`utilisateur_id`),
  ADD UNIQUE KEY `Preference_Competence_utilisateur_id_competence_id_06211494_uniq` (`utilisateur_id`,`competence_id`),
  ADD KEY `Preference_Competence_competence_id_efaa2ee9_fk_Competence_id` (`competence_id`);

--
-- Index pour la table `Preference_Utilisateur`
--
ALTER TABLE `Preference_Utilisateur`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `utilisateur_id` (`utilisateur_id`),
  ADD UNIQUE KEY `Preference_Utilisateur_utilisateur_id_cible_id_9c2d326f_uniq` (`utilisateur_id`,`cible_id`),
  ADD KEY `Preference_Utilisateur_cible_id_c4be3379_fk_Utilisateur_id` (`cible_id`);

--
-- Index pour la table `Utilisateur`
--
ALTER TABLE `Utilisateur`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `mail` (`mail`);

--
-- Index pour la table `Utilisateur_Competence`
--
ALTER TABLE `Utilisateur_Competence`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Utilisateur_Competence_utilisateur_id_competenc_c97d682a_uniq` (`utilisateur_id`,`competence_id`),
  ADD KEY `Utilisateur_Competence_competence_id_99046cd0_fk_Competence_id` (`competence_id`);

--
-- Index pour la table `Utilisateur_groups`
--
ALTER TABLE `Utilisateur_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Utilisateur_groups_utilisateur_id_group_id_36816330_uniq` (`utilisateur_id`,`group_id`),
  ADD KEY `Utilisateur_groups_group_id_77c88d41_fk_auth_group_id` (`group_id`);

--
-- Index pour la table `Utilisateur_user_permissions`
--
ALTER TABLE `Utilisateur_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Utilisateur_user_permiss_utilisateur_id_permissio_edb950aa_uniq` (`utilisateur_id`,`permission_id`),
  ADD KEY `Utilisateur_user_per_permission_id_3a08faeb_fk_auth_perm` (`permission_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT pour la table `Competence`
--
ALTER TABLE `Competence`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT pour la table `Disponibilite`
--
ALTER TABLE `Disponibilite`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT pour la table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT pour la table `Equipe`
--
ALTER TABLE `Equipe`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `Equipe_CompetenceBonus`
--
ALTER TABLE `Equipe_CompetenceBonus`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `Equipe_CompetenceCouvrante`
--
ALTER TABLE `Equipe_CompetenceCouvrante`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `Equipe_Membre`
--
ALTER TABLE `Equipe_Membre`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `Mobilite_Equipe`
--
ALTER TABLE `Mobilite_Equipe`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `Preference_Competence`
--
ALTER TABLE `Preference_Competence`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `Preference_Utilisateur`
--
ALTER TABLE `Preference_Utilisateur`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `Utilisateur`
--
ALTER TABLE `Utilisateur`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `Utilisateur_Competence`
--
ALTER TABLE `Utilisateur_Competence`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT pour la table `Utilisateur_groups`
--
ALTER TABLE `Utilisateur_groups`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `Utilisateur_user_permissions`
--
ALTER TABLE `Utilisateur_user_permissions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Contraintes pour la table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Contraintes pour la table `Disponibilite`
--
ALTER TABLE `Disponibilite`
  ADD CONSTRAINT `Disponibilite_utilisateur_id_f2ca4db5_fk_Utilisateur_id` FOREIGN KEY (`utilisateur_id`) REFERENCES `Utilisateur` (`id`);

--
-- Contraintes pour la table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_Utilisateur_id` FOREIGN KEY (`user_id`) REFERENCES `Utilisateur` (`id`);

--
-- Contraintes pour la table `Equipe_CompetenceBonus`
--
ALTER TABLE `Equipe_CompetenceBonus`
  ADD CONSTRAINT `Equipe_CompetenceBonus_competence_id_f85b0b29_fk_Competence_id` FOREIGN KEY (`competence_id`) REFERENCES `Competence` (`id`),
  ADD CONSTRAINT `Equipe_CompetenceBonus_equipe_id_d2c83f59_fk_Equipe_id` FOREIGN KEY (`equipe_id`) REFERENCES `Equipe` (`id`);

--
-- Contraintes pour la table `Equipe_CompetenceCouvrante`
--
ALTER TABLE `Equipe_CompetenceCouvrante`
  ADD CONSTRAINT `Equipe_CompetenceCou_competence_id_1f24dc38_fk_Competenc` FOREIGN KEY (`competence_id`) REFERENCES `Competence` (`id`),
  ADD CONSTRAINT `Equipe_CompetenceCouvrante_equipe_id_65c0885d_fk_Equipe_id` FOREIGN KEY (`equipe_id`) REFERENCES `Equipe` (`id`);

--
-- Contraintes pour la table `Equipe_Membre`
--
ALTER TABLE `Equipe_Membre`
  ADD CONSTRAINT `Equipe_Membre_equipe_id_1a5d783d_fk_Equipe_id` FOREIGN KEY (`equipe_id`) REFERENCES `Equipe` (`id`),
  ADD CONSTRAINT `Equipe_Membre_utilisateur_id_3f64ab22_fk_Utilisateur_id` FOREIGN KEY (`utilisateur_id`) REFERENCES `Utilisateur` (`id`);

--
-- Contraintes pour la table `Mobilite_Equipe`
--
ALTER TABLE `Mobilite_Equipe`
  ADD CONSTRAINT `Mobilite_Equipe_equipe_id_8c472286_fk_Equipe_id` FOREIGN KEY (`equipe_id`) REFERENCES `Equipe` (`id`);

--
-- Contraintes pour la table `Preference_Competence`
--
ALTER TABLE `Preference_Competence`
  ADD CONSTRAINT `Preference_Competence_competence_id_efaa2ee9_fk_Competence_id` FOREIGN KEY (`competence_id`) REFERENCES `Competence` (`id`),
  ADD CONSTRAINT `Preference_Competence_utilisateur_id_5a3461e7_fk_Utilisateur_id` FOREIGN KEY (`utilisateur_id`) REFERENCES `Utilisateur` (`id`);

--
-- Contraintes pour la table `Preference_Utilisateur`
--
ALTER TABLE `Preference_Utilisateur`
  ADD CONSTRAINT `Preference_Utilisateur_cible_id_c4be3379_fk_Utilisateur_id` FOREIGN KEY (`cible_id`) REFERENCES `Utilisateur` (`id`),
  ADD CONSTRAINT `Preference_Utilisateur_utilisateur_id_5173f91e_fk_Utilisateur_id` FOREIGN KEY (`utilisateur_id`) REFERENCES `Utilisateur` (`id`);

--
-- Contraintes pour la table `Utilisateur_Competence`
--
ALTER TABLE `Utilisateur_Competence`
  ADD CONSTRAINT `Utilisateur_Competence_competence_id_99046cd0_fk_Competence_id` FOREIGN KEY (`competence_id`) REFERENCES `Competence` (`id`),
  ADD CONSTRAINT `Utilisateur_Competence_utilisateur_id_92f5070b_fk_Utilisateur_id` FOREIGN KEY (`utilisateur_id`) REFERENCES `Utilisateur` (`id`);

--
-- Contraintes pour la table `Utilisateur_groups`
--
ALTER TABLE `Utilisateur_groups`
  ADD CONSTRAINT `Utilisateur_groups_group_id_77c88d41_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `Utilisateur_groups_utilisateur_id_5dc42724_fk_Utilisateur_id` FOREIGN KEY (`utilisateur_id`) REFERENCES `Utilisateur` (`id`);

--
-- Contraintes pour la table `Utilisateur_user_permissions`
--
ALTER TABLE `Utilisateur_user_permissions`
  ADD CONSTRAINT `Utilisateur_user_per_permission_id_3a08faeb_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `Utilisateur_user_per_utilisateur_id_be518510_fk_Utilisate` FOREIGN KEY (`utilisateur_id`) REFERENCES `Utilisateur` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
