-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Hôte : db:3306
-- Généré le : mer. 09 avr. 2025 à 12:39
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
(21, 'Can add utilisateur', 6, 'add_utilisateur'),
(22, 'Can change utilisateur', 6, 'change_utilisateur'),
(23, 'Can delete utilisateur', 6, 'delete_utilisateur'),
(24, 'Can view utilisateur', 6, 'view_utilisateur'),
(25, 'Can add competence', 7, 'add_competence'),
(26, 'Can change competence', 7, 'change_competence'),
(27, 'Can delete competence', 7, 'delete_competence'),
(28, 'Can view competence', 7, 'view_competence'),
(29, 'Can add equipe', 8, 'add_equipe'),
(30, 'Can change equipe', 8, 'change_equipe'),
(31, 'Can delete equipe', 8, 'delete_equipe'),
(32, 'Can view equipe', 8, 'view_equipe'),
(33, 'Can add disponibilite', 9, 'add_disponibilite'),
(34, 'Can change disponibilite', 9, 'change_disponibilite'),
(35, 'Can delete disponibilite', 9, 'delete_disponibilite'),
(36, 'Can view disponibilite', 9, 'view_disponibilite'),
(37, 'Can add preference utilisateur', 10, 'add_preferenceutilisateur'),
(38, 'Can change preference utilisateur', 10, 'change_preferenceutilisateur'),
(39, 'Can delete preference utilisateur', 10, 'delete_preferenceutilisateur'),
(40, 'Can view preference utilisateur', 10, 'view_preferenceutilisateur'),
(41, 'Can add preference competence', 11, 'add_preferencecompetence'),
(42, 'Can change preference competence', 11, 'change_preferencecompetence'),
(43, 'Can delete preference competence', 11, 'delete_preferencecompetence'),
(44, 'Can view preference competence', 11, 'view_preferencecompetence'),
(45, 'Can add utilisateur competence', 12, 'add_utilisateurcompetence'),
(46, 'Can change utilisateur competence', 12, 'change_utilisateurcompetence'),
(47, 'Can delete utilisateur competence', 12, 'delete_utilisateurcompetence'),
(48, 'Can view utilisateur competence', 12, 'view_utilisateurcompetence'),
(49, 'Can add equipe membre', 13, 'add_equipemembre'),
(50, 'Can change equipe membre', 13, 'change_equipemembre'),
(51, 'Can delete equipe membre', 13, 'delete_equipemembre'),
(52, 'Can view equipe membre', 13, 'view_equipemembre'),
(53, 'Can add equipe competencebonus', 14, 'add_equipecompetencebonus'),
(54, 'Can change equipe competencebonus', 14, 'change_equipecompetencebonus'),
(55, 'Can delete equipe competencebonus', 14, 'delete_equipecompetencebonus'),
(56, 'Can view equipe competencebonus', 14, 'view_equipecompetencebonus'),
(57, 'Can add equipe competencecouvrante', 15, 'add_equipecompetencecouvrante'),
(58, 'Can change equipe competencecouvrante', 15, 'change_equipecompetencecouvrante'),
(59, 'Can delete equipe competencecouvrante', 15, 'delete_equipecompetencecouvrante'),
(60, 'Can view equipe competencecouvrante', 15, 'view_equipecompetencecouvrante'),
(61, 'Can add mobilite equipe', 16, 'add_mobiliteequipe'),
(62, 'Can change mobilite equipe', 16, 'change_mobiliteequipe'),
(63, 'Can delete mobilite equipe', 16, 'delete_mobiliteequipe'),
(64, 'Can view mobilite equipe', 16, 'view_mobiliteequipe');

-- --------------------------------------------------------

--
-- Structure de la table `Competence`
--

CREATE TABLE `Competence` (
  `id` bigint NOT NULL,
  `nom` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Disponibilite`
--

CREATE TABLE `Disponibilite` (
  `id` int NOT NULL,
  `jour` varchar(8) NOT NULL,
  `heure_debut` time(6) DEFAULT NULL,
  `heure_fin` time(6) DEFAULT NULL,
  `utilisateur_id` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  `user_id` varchar(255) NOT NULL
) ;

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
(7, 'matchmakingApp', 'competence'),
(9, 'matchmakingApp', 'disponibilite'),
(8, 'matchmakingApp', 'equipe'),
(14, 'matchmakingApp', 'equipecompetencebonus'),
(15, 'matchmakingApp', 'equipecompetencecouvrante'),
(13, 'matchmakingApp', 'equipemembre'),
(16, 'matchmakingApp', 'mobiliteequipe'),
(11, 'matchmakingApp', 'preferencecompetence'),
(10, 'matchmakingApp', 'preferenceutilisateur'),
(6, 'matchmakingApp', 'utilisateur'),
(12, 'matchmakingApp', 'utilisateurcompetence'),
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
(1, 'contenttypes', '0001_initial', '2025-04-09 10:55:31.248982'),
(2, 'contenttypes', '0002_remove_content_type_name', '2025-04-09 10:55:31.342346'),
(3, 'auth', '0001_initial', '2025-04-09 10:55:31.691996'),
(4, 'auth', '0002_alter_permission_name_max_length', '2025-04-09 10:55:31.772170'),
(5, 'auth', '0003_alter_user_email_max_length', '2025-04-09 10:55:31.789635'),
(6, 'auth', '0004_alter_user_username_opts', '2025-04-09 10:55:31.798220'),
(7, 'auth', '0005_alter_user_last_login_null', '2025-04-09 10:55:31.809830'),
(8, 'auth', '0006_require_contenttypes_0002', '2025-04-09 10:55:31.814920'),
(9, 'auth', '0007_alter_validators_add_error_messages', '2025-04-09 10:55:31.824028'),
(10, 'auth', '0008_alter_user_username_max_length', '2025-04-09 10:55:31.831868'),
(11, 'auth', '0009_alter_user_last_name_max_length', '2025-04-09 10:55:31.841513'),
(12, 'auth', '0010_alter_group_name_max_length', '2025-04-09 10:55:31.863458'),
(13, 'auth', '0011_update_proxy_permissions', '2025-04-09 10:55:31.878028'),
(14, 'auth', '0012_alter_user_first_name_max_length', '2025-04-09 10:55:31.887668'),
(15, 'matchmakingApp', '0001_initial', '2025-04-09 10:55:32.259656'),
(16, 'admin', '0001_initial', '2025-04-09 10:55:32.468143'),
(17, 'admin', '0002_logentry_remove_auto_add', '2025-04-09 10:55:32.477433'),
(18, 'admin', '0003_logentry_add_action_flag_choices', '2025-04-09 10:55:32.487754'),
(19, 'sessions', '0001_initial', '2025-04-09 10:55:32.533390'),
(20, 'matchmakingApp', '0002_competence', '2025-04-09 10:57:46.799762'),
(21, 'matchmakingApp', '0003_equipe', '2025-04-09 10:58:03.699595'),
(22, 'matchmakingApp', '0004_disponibilite', '2025-04-09 10:58:37.015478'),
(23, 'matchmakingApp', '0005_preferenceutilisateur', '2025-04-09 10:58:56.990538'),
(24, 'matchmakingApp', '0006_preferencecompetence', '2025-04-09 10:59:12.088448'),
(25, 'matchmakingApp', '0007_utilisateurcompetence', '2025-04-09 10:59:29.252176'),
(26, 'matchmakingApp', '0008_equipemembre', '2025-04-09 11:00:07.461262'),
(27, 'matchmakingApp', '0009_equipecompetencebonus', '2025-04-09 11:00:23.801880'),
(28, 'matchmakingApp', '0010_equipecompetencecouvrante', '2025-04-09 11:00:35.067430'),
(29, 'matchmakingApp', '0011_mobiliteequipe', '2025-04-09 11:00:49.120930');

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
('p61rvk0ap6zczzqfuav6hirkjhnax5dx', '.eJxVjE0OwiAYBe_C2pBioYBL9z0D-f4qVQNJaVfGu2uTLnQ7b-a9VIJtzWlrsqSZ1UWp0y9CoIeUnfMdyq1qqmVdZtS7oo-16bGyPK-H-3eQoeVvHTAiWOwpODtwxN4AEzuUyRB6J-5MjnsjHVFkK2A7NsYEmKInET-o9wftcTjq:1u2TUP:L2lMJihMraK-pHPgCjVGMNlc2XXAxWMVzUhhNc7UGes', '2025-04-23 11:21:05.022115');

-- --------------------------------------------------------

--
-- Structure de la table `Equipe`
--

CREATE TABLE `Equipe` (
  `id` varchar(255) NOT NULL,
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
  `equipe_id` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Equipe_CompetenceCouvrante`
--

CREATE TABLE `Equipe_CompetenceCouvrante` (
  `id` int NOT NULL,
  `niveau_requis` varchar(13) DEFAULT NULL,
  `competence_id` bigint NOT NULL,
  `equipe_id` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Equipe_Membre`
--

CREATE TABLE `Equipe_Membre` (
  `id` int NOT NULL,
  `equipe_id` varchar(255) NOT NULL,
  `utilisateur_id` varchar(255) NOT NULL
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
  `equipe_id` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Preference_Competence`
--

CREATE TABLE `Preference_Competence` (
  `id` int NOT NULL,
  `preference` varchar(8) DEFAULT NULL,
  `competence_id` bigint NOT NULL,
  `utilisateur_id` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Preference_Utilisateur`
--

CREATE TABLE `Preference_Utilisateur` (
  `id` int NOT NULL,
  `preference` varchar(8) DEFAULT NULL,
  `cible_id` varchar(255) NOT NULL,
  `utilisateur_id` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Utilisateur`
--

CREATE TABLE `Utilisateur` (
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `id` varchar(255) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `mail` varchar(255) NOT NULL,
  `role` varchar(7) NOT NULL,
  `annees_experience` int DEFAULT NULL,
  `projets_realises` int DEFAULT NULL,
  `salaire_horaire` decimal(10,2) DEFAULT NULL,
  `moyenne_notes` decimal(3,2) DEFAULT NULL,
  `historique_notes` json DEFAULT NULL,
  `mobilite` varchar(10) DEFAULT NULL,
  `score_projet` int DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `is_staff` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `Utilisateur`
--

INSERT INTO `Utilisateur` (`password`, `last_login`, `is_superuser`, `id`, `nom`, `prenom`, `mail`, `role`, `annees_experience`, `projets_realises`, `salaire_horaire`, `moyenne_notes`, `historique_notes`, `mobilite`, `score_projet`, `is_active`, `is_staff`) VALUES
('pbkdf2_sha256$870000$XjASvFEZ85NZp9IRG9IKGE$VmFFNz3K97PKWmChApWWHiky3NBaLAAgOVmlZ9qPYH4=', '2025-04-09 11:21:05.009372', 0, '', 'Doe', 'John', 'test@example.com', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0);

-- --------------------------------------------------------

--
-- Structure de la table `Utilisateur_Competence`
--

CREATE TABLE `Utilisateur_Competence` (
  `id` int NOT NULL,
  `niveau` varchar(13) DEFAULT NULL,
  `competence_id` bigint NOT NULL,
  `utilisateur_id` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Utilisateur_groups`
--

CREATE TABLE `Utilisateur_groups` (
  `id` bigint NOT NULL,
  `utilisateur_id` varchar(255) NOT NULL,
  `group_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Utilisateur_user_permissions`
--

CREATE TABLE `Utilisateur_user_permissions` (
  `id` bigint NOT NULL,
  `utilisateur_id` varchar(255) NOT NULL,
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
  ADD UNIQUE KEY `utilisateur_id` (`utilisateur_id`),
  ADD UNIQUE KEY `Disponibilite_utilisateur_id_jour_996eb4fd_uniq` (`utilisateur_id`,`jour`);

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
  ADD UNIQUE KEY `utilisateur_id` (`utilisateur_id`),
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
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `Disponibilite`
--
ALTER TABLE `Disponibilite`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

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
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

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
-- AUTO_INCREMENT pour la table `Utilisateur_Competence`
--
ALTER TABLE `Utilisateur_Competence`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

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
