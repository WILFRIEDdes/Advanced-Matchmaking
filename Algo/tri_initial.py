from classes import Projet
import sqlite3
from classes import Utilisateur

def generer_requete_sql(projet: Projet):
    # Construction de la requête SQL
    requete = f"""
    SELECT DISTINCT u.id
    FROM utilisateurs u
    JOIN competences_utilisateur cu ON u.id = cu.utilisateur_id
    JOIN competences c ON cu.competence_id = c.id
    WHERE u.salaire_horaire <= {projet.budget_max}
    AND u.mobilite IN ('{projet.mobilite}', 'hybride')
    AND (
        {" OR ".join([
            f"(cu.competence_id = {comp_id} AND cu.niveau >= {details['niveau']})"
            for comp_id, details in projet.competences_obligatoires.items()
        ])}
    )
    GROUP BY u.id
    """
    return requete

def obtenir_utilisateurs_depuis_requete(db_path: str, requete_sql: str):
    utilisateurs = []
    try:
        # Connexion à la base de données
        connexion = sqlite3.connect(db_path)
        curseur = connexion.cursor()

        # Exécution de la requête SQL
        curseur.execute(requete_sql)
        resultats = curseur.fetchall()

        # Création des objets Utilisateur à partir des résultats
        for row in resultats:
            utilisateur = Utilisateur(
                id=row[0],
                competences=[
                    {'id': comp_id, 'niveau': niveau}
                    for comp_id, niveau in zip(row[1].split(','), row[2].split(','))
                ] if row[1] and row[2] else [],
                disponibilites={
                    jour: {'debut': debut, 'fin': fin}
                    for jour, debut, fin in zip(row[3].split(','), row[4].split(','), row[5].split(','))
                } if row[3] and row[4] and row[5] else {},
                preferences={
                    'mobilite': row[6],
                    'horaires': row[7]
                } if row[6] and row[7] else {},
                experience={
                    "annees": row[8],
                    "projets_realises": row[9]
                },
                salaire_horaire=row[10],
                historique_notes=[float(note) for note in row[11].split(',')] if row[11] else [],
                mobilite=row[12]
            )
            utilisateurs.append(utilisateur)

    except sqlite3.Error as e:
        print(f"Erreur lors de l'accès à la base de données : {e}")
    finally:
        if connexion:
            connexion.close()

    return utilisateurs