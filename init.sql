CREATE TABLE Utilisateur (
    id VARCHAR(255) PRIMARY KEY,
    annees_experience INT,
    projets_realises INT,
    salaire_horaire DECIMAL(10,2),
    moyenne_notes DECIMAL(3,2),
    historique_notes JSON,
    mobilite ENUM('presentiel', 'distanciel', 'les deux'),
    score_projet INT DEFAULT -1
);

CREATE TABLE Competence (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Utilisateur_Competence (
    utilisateur_id VARCHAR(255),
    competence_id INT,
    niveau ENUM('Débutant', 'Intermédiaire', 'Avancé', 'Expert'),
    PRIMARY KEY (utilisateur_id, competence_id),
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id) ON DELETE CASCADE,
    FOREIGN KEY (competence_id) REFERENCES Competence(id) ON DELETE CASCADE
);

CREATE TABLE Disponibilite (
    utilisateur_id VARCHAR(255),
    jour ENUM('Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'),
    heure_debut TIME,
    heure_fin TIME,
    PRIMARY KEY (utilisateur_id, jour),
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id) ON DELETE CASCADE
);

CREATE TABLE Preference_Utilisateur (
    utilisateur_id VARCHAR(255),
    cible_id VARCHAR(255),
    preference ENUM('positive', 'negative'),
    PRIMARY KEY (utilisateur_id, cible_id),
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id) ON DELETE CASCADE,
    FOREIGN KEY (cible_id) REFERENCES Utilisateur(id) ON DELETE CASCADE
);

CREATE TABLE Preference_Competence (
    utilisateur_id VARCHAR(255),
    competence_id INT,
    preference ENUM('positive', 'negative'),
    PRIMARY KEY (utilisateur_id, competence_id),
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id) ON DELETE CASCADE,
    FOREIGN KEY (competence_id) REFERENCES Competence(id) ON DELETE CASCADE
);

CREATE TABLE Equipe (
    id VARCHAR(255) PRIMARY KEY,
    taille INT,
    budget_total DECIMAL(15,2),
    heures_homme INT,
    score_global DECIMAL(5,2)
);

CREATE TABLE Equipe_Membre (
    equipe_id VARCHAR(255),
    utilisateur_id VARCHAR(255),
    PRIMARY KEY (equipe_id, utilisateur_id),
    FOREIGN KEY (equipe_id) REFERENCES Equipe(id) ON DELETE CASCADE,
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id) ON DELETE CASCADE
);

CREATE TABLE Equipe_CompetenceCouvrante (
    equipe_id VARCHAR(255),
    competence_id INT,
    niveau_requis ENUM('Débutant', 'Intermédiaire', 'Avancé', 'Expert'),
    PRIMARY KEY (equipe_id, competence_id),
    FOREIGN KEY (equipe_id) REFERENCES Equipe(id) ON DELETE CASCADE,
    FOREIGN KEY (competence_id) REFERENCES Competence(id) ON DELETE CASCADE
);

CREATE TABLE Equipe_CompetenceBonus (
    equipe_id VARCHAR(255),
    competence_id INT,
    PRIMARY KEY (equipe_id, competence_id),
    FOREIGN KEY (equipe_id) REFERENCES Equipe(id) ON DELETE CASCADE,
    FOREIGN KEY (competence_id) REFERENCES Competence(id) ON DELETE CASCADE
);

CREATE TABLE Mobilite_Equipe (
    equipe_id VARCHAR(255),
    presentiel INT DEFAULT 0,
    distanciel INT DEFAULT 0,
    hybride INT DEFAULT 0,
    PRIMARY KEY (equipe_id),
    FOREIGN KEY (equipe_id) REFERENCES Equipe(id) ON DELETE CASCADE
);