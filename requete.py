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

def insert_users(users):
    query = """
    INSERT INTO Utilisateur (id, annees_experience, projets_realises, salaire_horaire, moyenne_notes, historique_notes, mobilite, score_projet)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    """  

    for user in users:
        historique_notes = user["historique_notes"]

        cursor.execute(query, (
            user["id"], user["annees_experience"], user["projets_realises"],
            user["salaire_horaire"], user["moyenne_notes"], json.dumps(historique_notes),  # Correction ici
            user["mobilite"], user["score_projet"]
        ))

    conn.commit()
