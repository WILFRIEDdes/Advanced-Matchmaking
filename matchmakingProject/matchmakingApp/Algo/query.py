import mysql.connector
import json

# Connexion à la base de données
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="monpassword",
    database="matchmakingDB"
)
cursor = conn.cursor()

def insert_users(users, disponibilites, user_competences):
    query_utilisateur = """
        INSERT INTO Utilisateur (
            id, password, last_login, is_superuser, nom, prenom, mail, role,
            annees_experience, projets_realises, salaire_horaire, moyenne_notes,
            historique_notes, mobilite, score_projet, is_active, is_staff
        ) VALUES (
            %(id)s, %(password)s, %(last_login)s, %(is_superuser)s, %(nom)s, %(prenom)s,
            %(mail)s, %(role)s, %(annees_experience)s, %(projets_realises)s, %(salaire_horaire)s,
            %(moyenne_notes)s, %(historique_notes)s, %(mobilite)s, %(score_projet)s,
            %(is_active)s, %(is_staff)s
        );
    """

    query_dispo = """
        INSERT INTO Disponibilite (utilisateur_id, jour, heure_debut, heure_fin)
        VALUES (%s, %s, %s, %s)
    """

    query_competences = """
        INSERT IGNORE INTO Utilisateur_Competence (utilisateur_id, competence_id, niveau)
        VALUES (%s, %s, %s)
    """

    # Insertion des utilisateurs
    for user in users:
        cursor.execute(query_utilisateur, user)

    # Insertion des disponibilités
    for dispo in disponibilites: 
        cursor.execute(query_dispo, (
            dispo["utilisateur_id"], dispo["jour"], dispo["heure_debut"], dispo["heure_fin"]
        ))

    # Insertion des compétences utilisateur, ligne par ligne
    for comp in user_competences:
        utilisateur_id, competence_id, niveau = comp
        cursor.execute(query_competences, (utilisateur_id, competence_id, niveau))

    conn.commit()

    cursor.close()
    conn.close()

def delete_users(users):
    query = """
    DELETE FROM Utilisateur;
    """ 
    cursor.execute(query)

    conn.commit()