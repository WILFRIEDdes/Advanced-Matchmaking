from matchmakingApp.models import (
    Utilisateur,
    UtilisateurCompetence, 
    Disponibilite,
    PreferenceUtilisateur, 
    PreferenceCompetence, 
    ProjetCompetenceRequise,
    EquipeMembre
)
from matchmakingApp.Algo.classes import Utilisateur as AlgoUtilisateur, Competence

# def generer_requete_sql(projet: Projet):
#     # Construction de la requête SQL adaptée à matchmakingDB.sql
#     requete = f"""
#     SELECT DISTINCT u.id
#     FROM Utilisateur u
#     JOIN Utilisateur_Competence uc ON u.id = uc.utilisateur_id
#     JOIN Competence c ON uc.competence_id = c.id
#     WHERE u.salaire_horaire <= {projet.budget_max}
#     AND u.mobilite IN ('{projet.mobilite}', 'les deux')
#     AND (
#         {" OR ".join([
#             f"(uc.competence_id = {comp_id} AND uc.niveau = '{details['niveau']}')"
#             for comp_id, details in projet.competences_obligatoires.items()
#         ])}
#     )
#     GROUP BY u.id
#     """
#     return requete

# def obtenir_utilisateurs_depuis_requete(db_path: str, requete_sql: str):
#     utilisateurs = []
#     try:
#         # Connexion à la base de données
#         connexion = sqlite3.connect(db_path)
#         curseur = connexion.cursor()

#         # Exécution de la requête SQL
#         curseur.execute(requete_sql)
#         resultats = curseur.fetchall()

#         # Création des objets Utilisateur à partir des résultats
#         for row in resultats:
#             utilisateur = Utilisateur(
#                 id=row[0],
#                 competences=[
#                     {'id': comp_id, 'niveau': niveau}
#                     for comp_id, niveau in zip(row[1].split(','), row[2].split(','))
#                 ] if row[1] and row[2] else [],
#                 disponibilites={
#                     jour: {'debut': debut, 'fin': fin}
#                     for jour, debut, fin in zip(row[3].split(','), row[4].split(','), row[5].split(','))
#                 } if row[3] and row[4] and row[5] else {},
#                 preferences={
#                     'mobilite': row[6],
#                     'horaires': row[7]
#                 } if row[6] and row[7] else {},
#                 experience={
#                     "annees": row[8],
#                     "projets_realises": row[9]
#                 },
#                 salaire_horaire=row[10],
#                 historique_notes=[float(note) for note in row[11].split(',')] if row[11] else [],
#                 mobilite=row[12]
#             )
#             utilisateurs.append(utilisateur)

#     except sqlite3.Error as e:
#         print(f"Erreur lors de l'accès à la base de données : {e}")
#     finally:
#         if connexion:
#             connexion.close()

#     return utilisateurs


def obtenir_utilisateurs_depuis_projet(projet):

# Étape 1 : Filtrage des utilisateurs par compétences requises du projet
    competences_requises = ProjetCompetenceRequise.objects.filter(projet=projet.id).values_list('competence_id', flat=True)
    utilisateurs_competents = Utilisateur.objects.filter(
        utilisateurcompetence__competence_id__in=competences_requises
    ).distinct()

    # Étape 2 : Filtrage par mobilité
    utilisateurs_mobilite = utilisateurs_competents.filter(mobilite=projet.mobilite)

    # Étape 3 : Exclusion des utilisateurs déjà dans une équipe
    utilisateurs_avec_equipes = EquipeMembre.objects.values_list('utilisateur_id', flat=True)
    utilisateurs_final = utilisateurs_mobilite.exclude(id__in=utilisateurs_avec_equipes)

    # Étape 4 : Transformation en objets Utilisateur personnalisés
    utilisateurs_transformes = []

    # Dictionnaire de conversion des niveaux
    mapping_niveaux = {
        "Débutant": 1,
        "Novice": 2,
        "Intermédiaire": 3,
        "Avancé": 4,
        "Expert": 5
    }

    for u in utilisateurs_final:
        # Compétences
        competences_raw = UtilisateurCompetence.objects.filter(utilisateur=u)
        competences = [Competence(c.competence.id, c.competence.nom, mapping_niveaux.get(c.niveau, -1)) for c in competences_raw]


        # Disponibilités
        disponibilites = {}
        for d in Disponibilite.objects.filter(utilisateur=u):
            disponibilites.setdefault(d.jour, []).append((d.heure_debut, d.heure_fin))

        # Préférences
        pref_users = PreferenceUtilisateur.objects.filter(utilisateur=u).values_list('cible_id', 'preference')
        pref_comps = PreferenceCompetence.objects.filter(utilisateur=u).values_list('competence_id', 'preference')
        preferences = {
            "utilisateurs": {uid: pref for uid, pref in pref_users},
            "competences": {cid: pref for cid, pref in pref_comps},
        }

        # Expérience
        experience = {
            "annees": u.annees_experience,
            "projets_realises": u.projets_realises
        }

        # Notes et mobilité
        historique_notes = u.historique_notes or []
        
        # Conversion de la mobilité "mixte" → "hybride"
        mobilite = "hybride" if u.mobilite == "mixte" else u.mobilite

        utilisateur = AlgoUtilisateur(
            id=u.id,
            competences=competences,
            disponibilites=disponibilites,
            preferences=preferences,
            experience=experience,
            salaire_horaire=u.salaire_horaire,
            historique_notes=historique_notes,
            mobilite=mobilite
        )
        utilisateurs_transformes.append(utilisateur)

    return utilisateurs_transformes