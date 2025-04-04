-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Hôte : db:3306
-- Généré le : ven. 04 avr. 2025 à 13:29
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
-- Structure de la table `Admin`
--

CREATE TABLE `Admin` (
  `id` int NOT NULL,
  `nom` varchar(100) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mot_de_passe` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Competence`
--

CREATE TABLE `Competence` (
  `id` int NOT NULL,
  `nom` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Disponibilite`
--

CREATE TABLE `Disponibilite` (
  `utilisateur_id` varchar(255) NOT NULL,
  `jour` enum('Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi','Dimanche') NOT NULL,
  `heure_debut` time DEFAULT NULL,
  `heure_fin` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Employe`
--

CREATE TABLE `Employe` (
  `id` varchar(255) NOT NULL,
  `nom` varchar(30) DEFAULT NULL,
  `prenom` varchar(30) DEFAULT NULL,
  `annees_experience` int DEFAULT NULL,
  `projets_realises` int DEFAULT NULL,
  `salaire_horaire` decimal(10,2) DEFAULT NULL,
  `moyenne_notes` decimal(3,2) DEFAULT NULL,
  `historique_notes` json DEFAULT NULL,
  `mobilite` enum('presentiel','distanciel','les deux') DEFAULT NULL,
  `score_projet` int DEFAULT '-1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `Employe`
--

INSERT INTO `Employe` (`id`, `nom`, `prenom`, `annees_experience`, `projets_realises`, `salaire_horaire`, `moyenne_notes`, `historique_notes`, `mobilite`, `score_projet`) VALUES
('020b7f96-f783-4508-83f0-928365d0e444', NULL, NULL, 25, 15, 37.21, 0.67, '\"[3, 5, 3, 3, 5, 1]\"', 'presentiel', -1),
('06bcf2ff-6608-4e0d-a46a-3783f8ffe98b', NULL, NULL, 4, 4, 24.43, 0.51, '\"[1, 3, 3, 3, 2, 5, 1]\"', 'distanciel', -1),
('0d00b2eb-aca3-48b3-9428-0ba5858c3a16', NULL, NULL, 9, 6, 47.07, 0.75, '\"[5, 5, 5, 3, 5, 1, 4, 2]\"', 'presentiel', -1),
('0e57addf-646b-469c-8768-8b4c74baa76e', NULL, NULL, 6, 0, 19.54, 0.87, '\"[4, 4, 5]\"', 'presentiel', -1),
('34538639-a969-48a5-90c3-00dc88e25f86', NULL, NULL, 11, 6, 33.27, 0.74, '\"[5, 3, 3, 4, 4, 3, 4]\"', 'les deux', -1),
('53e607ec-6a4c-4800-b511-919f857c945a', NULL, NULL, 24, 16, 34.31, 0.40, '\"[1, 2, 3]\"', 'les deux', -1),
('65b409a1-6958-4b2f-841b-d8d010e76289', NULL, NULL, 1, 7, 40.01, 0.58, '\"[3, 1, 5, 5, 1, 1, 5, 4, 1, 3]\"', 'presentiel', -1),
('70c4d9b3-3f66-4486-8a56-944acdd12e11', NULL, NULL, 2, 19, 48.53, 0.40, '\"[2]\"', 'les deux', -1),
('75230dab-ff4f-487d-8710-c4f1b45ef604', NULL, NULL, 13, 17, 41.13, 0.65, '\"[5, 4, 1, 3]\"', 'distanciel', -1),
('7b5258b8-0bd8-4064-9d1d-3c956aa9ab2d', NULL, NULL, 15, 13, 23.05, 0.55, '\"[3, 2, 2, 1, 3, 2, 5, 4]\"', 'les deux', -1);

-- --------------------------------------------------------

--
-- Structure de la table `Employe_Competence`
--

CREATE TABLE `Employe_Competence` (
  `utilisateur_id` varchar(255) NOT NULL,
  `competence_id` int NOT NULL,
  `niveau` enum('Débutant','Intermédiaire','Avancé','Expert') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  `equipe_id` varchar(255) NOT NULL,
  `competence_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Equipe_CompetenceCouvrante`
--

CREATE TABLE `Equipe_CompetenceCouvrante` (
  `equipe_id` varchar(255) NOT NULL,
  `competence_id` int NOT NULL,
  `niveau_requis` enum('Débutant','Intermédiaire','Avancé','Expert') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Equipe_Membre`
--

CREATE TABLE `Equipe_Membre` (
  `equipe_id` varchar(255) NOT NULL,
  `utilisateur_id` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Mobilite_Equipe`
--

CREATE TABLE `Mobilite_Equipe` (
  `equipe_id` varchar(255) NOT NULL,
  `presentiel` int DEFAULT '0',
  `distanciel` int DEFAULT '0',
  `hybride` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Preference_Competence`
--

CREATE TABLE `Preference_Competence` (
  `utilisateur_id` varchar(255) NOT NULL,
  `competence_id` int NOT NULL,
  `preference` enum('positive','negative') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Preference_Employe`
--

CREATE TABLE `Preference_Employe` (
  `utilisateur_id` varchar(255) NOT NULL,
  `cible_id` varchar(255) NOT NULL,
  `preference` enum('positive','negative') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `Admin`
--
ALTER TABLE `Admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

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
  ADD PRIMARY KEY (`utilisateur_id`,`jour`);

--
-- Index pour la table `Employe`
--
ALTER TABLE `Employe`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `Employe_Competence`
--
ALTER TABLE `Employe_Competence`
  ADD PRIMARY KEY (`utilisateur_id`,`competence_id`),
  ADD KEY `competence_id` (`competence_id`);

--
-- Index pour la table `Equipe`
--
ALTER TABLE `Equipe`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `Equipe_CompetenceBonus`
--
ALTER TABLE `Equipe_CompetenceBonus`
  ADD PRIMARY KEY (`equipe_id`,`competence_id`),
  ADD KEY `competence_id` (`competence_id`);

--
-- Index pour la table `Equipe_CompetenceCouvrante`
--
ALTER TABLE `Equipe_CompetenceCouvrante`
  ADD PRIMARY KEY (`equipe_id`,`competence_id`),
  ADD KEY `competence_id` (`competence_id`);

--
-- Index pour la table `Equipe_Membre`
--
ALTER TABLE `Equipe_Membre`
  ADD PRIMARY KEY (`equipe_id`,`utilisateur_id`),
  ADD KEY `utilisateur_id` (`utilisateur_id`);

--
-- Index pour la table `Mobilite_Equipe`
--
ALTER TABLE `Mobilite_Equipe`
  ADD PRIMARY KEY (`equipe_id`);

--
-- Index pour la table `Preference_Competence`
--
ALTER TABLE `Preference_Competence`
  ADD PRIMARY KEY (`utilisateur_id`,`competence_id`),
  ADD KEY `competence_id` (`competence_id`);

--
-- Index pour la table `Preference_Employe`
--
ALTER TABLE `Preference_Employe`
  ADD PRIMARY KEY (`utilisateur_id`,`cible_id`),
  ADD KEY `cible_id` (`cible_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `Competence`
--
ALTER TABLE `Competence`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `Disponibilite`
--
ALTER TABLE `Disponibilite`
  ADD CONSTRAINT `Disponibilite_ibfk_1` FOREIGN KEY (`utilisateur_id`) REFERENCES `Employe` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `Employe_Competence`
--
ALTER TABLE `Employe_Competence`
  ADD CONSTRAINT `Employe_Competence_ibfk_1` FOREIGN KEY (`utilisateur_id`) REFERENCES `Employe` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `Employe_Competence_ibfk_2` FOREIGN KEY (`competence_id`) REFERENCES `Competence` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `Equipe_CompetenceBonus`
--
ALTER TABLE `Equipe_CompetenceBonus`
  ADD CONSTRAINT `Equipe_CompetenceBonus_ibfk_1` FOREIGN KEY (`equipe_id`) REFERENCES `Equipe` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `Equipe_CompetenceBonus_ibfk_2` FOREIGN KEY (`competence_id`) REFERENCES `Competence` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `Equipe_CompetenceCouvrante`
--
ALTER TABLE `Equipe_CompetenceCouvrante`
  ADD CONSTRAINT `Equipe_CompetenceCouvrante_ibfk_1` FOREIGN KEY (`equipe_id`) REFERENCES `Equipe` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `Equipe_CompetenceCouvrante_ibfk_2` FOREIGN KEY (`competence_id`) REFERENCES `Competence` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `Equipe_Membre`
--
ALTER TABLE `Equipe_Membre`
  ADD CONSTRAINT `Equipe_Membre_ibfk_1` FOREIGN KEY (`equipe_id`) REFERENCES `Equipe` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `Equipe_Membre_ibfk_2` FOREIGN KEY (`utilisateur_id`) REFERENCES `Employe` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `Mobilite_Equipe`
--
ALTER TABLE `Mobilite_Equipe`
  ADD CONSTRAINT `Mobilite_Equipe_ibfk_1` FOREIGN KEY (`equipe_id`) REFERENCES `Equipe` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `Preference_Competence`
--
ALTER TABLE `Preference_Competence`
  ADD CONSTRAINT `Preference_Competence_ibfk_1` FOREIGN KEY (`utilisateur_id`) REFERENCES `Employe` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `Preference_Competence_ibfk_2` FOREIGN KEY (`competence_id`) REFERENCES `Competence` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `Preference_Employe`
--
ALTER TABLE `Preference_Employe`
  ADD CONSTRAINT `Preference_Employe_ibfk_1` FOREIGN KEY (`utilisateur_id`) REFERENCES `Employe` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `Preference_Employe_ibfk_2` FOREIGN KEY (`cible_id`) REFERENCES `Employe` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
