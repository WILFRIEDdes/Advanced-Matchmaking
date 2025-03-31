-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Hôte : mysql
-- Généré le : mar. 25 mars 2025 à 09:19
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
-- Structure de la table `Preference_Utilisateur`
--

CREATE TABLE `Preference_Utilisateur` (
  `utilisateur_id` varchar(255) NOT NULL,
  `cible_id` varchar(255) NOT NULL,
  `preference` enum('positive','negative') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Utilisateur`
--

CREATE TABLE `Utilisateur` (
  `id` varchar(255) NOT NULL,
  `annees_experience` int DEFAULT NULL,
  `projets_realises` int DEFAULT NULL,
  `salaire_horaire` decimal(10,2) DEFAULT NULL,
  `moyenne_notes` decimal(3,2) DEFAULT NULL,
  `historique_notes` json DEFAULT NULL,
  `mobilite` enum('presentiel','distanciel','les deux') DEFAULT NULL,
  `score_projet` int DEFAULT '-1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `Utilisateur_Competence`
--

CREATE TABLE `Utilisateur_Competence` (
  `utilisateur_id` varchar(255) NOT NULL,
  `competence_id` int NOT NULL,
  `niveau` enum('Débutant','Intermédiaire','Avancé','Expert') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Index pour les tables déchargées
--

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
-- Index pour la table `Preference_Utilisateur`
--
ALTER TABLE `Preference_Utilisateur`
  ADD PRIMARY KEY (`utilisateur_id`,`cible_id`),
  ADD KEY `cible_id` (`cible_id`);

--
-- Index pour la table `Utilisateur`
--
ALTER TABLE `Utilisateur`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `Utilisateur_Competence`
--
ALTER TABLE `Utilisateur_Competence`
  ADD PRIMARY KEY (`utilisateur_id`,`competence_id`),
  ADD KEY `competence_id` (`competence_id`);

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
  ADD CONSTRAINT `Disponibilite_ibfk_1` FOREIGN KEY (`utilisateur_id`) REFERENCES `Utilisateur` (`id`) ON DELETE CASCADE;

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
  ADD CONSTRAINT `Equipe_Membre_ibfk_2` FOREIGN KEY (`utilisateur_id`) REFERENCES `Utilisateur` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `Mobilite_Equipe`
--
ALTER TABLE `Mobilite_Equipe`
  ADD CONSTRAINT `Mobilite_Equipe_ibfk_1` FOREIGN KEY (`equipe_id`) REFERENCES `Equipe` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `Preference_Competence`
--
ALTER TABLE `Preference_Competence`
  ADD CONSTRAINT `Preference_Competence_ibfk_1` FOREIGN KEY (`utilisateur_id`) REFERENCES `Utilisateur` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `Preference_Competence_ibfk_2` FOREIGN KEY (`competence_id`) REFERENCES `Competence` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `Preference_Utilisateur`
--
ALTER TABLE `Preference_Utilisateur`
  ADD CONSTRAINT `Preference_Utilisateur_ibfk_1` FOREIGN KEY (`utilisateur_id`) REFERENCES `Utilisateur` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `Preference_Utilisateur_ibfk_2` FOREIGN KEY (`cible_id`) REFERENCES `Utilisateur` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `Utilisateur_Competence`
--
ALTER TABLE `Utilisateur_Competence`
  ADD CONSTRAINT `Utilisateur_Competence_ibfk_1` FOREIGN KEY (`utilisateur_id`) REFERENCES `Utilisateur` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `Utilisateur_Competence_ibfk_2` FOREIGN KEY (`competence_id`) REFERENCES `Competence` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
