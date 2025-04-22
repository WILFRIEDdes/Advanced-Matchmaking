from .classes import Projet
import sqlite3
from .classes import Utilisateur as AlgoUtilisateur
from matchmakingApp.models import Utilisateur as DjangoUtilisateur, UtilisateurCompetence, Disponibilite
from django.db.models import Q

def generer_requete_sql(projet: Projet):
    # Construction de la requête SQL adaptée à matchmakingDB.sql
    requete = f"""
    SELECT DISTINCT u.id
    FROM Utilisateur u
    JOIN Utilisateur_Competence uc ON u.id = uc.utilisateur_id
    JOIN Competence c ON uc.competence_id = c.id
    WHERE u.salaire_horaire <= {projet.budget_max}
    AND u.mobilite IN ('{projet.mobilite}', 'les deux')
    AND (
        {" OR ".join([
            f"(uc.competence_id = {comp_id} AND uc.niveau = '{details['niveau']}')"
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

def obtenir_utilisateurs_depuis_projet(projet):
    utilisateurs = []

    # Construction des filtres de compétences requises
    competence_q = Q()
    for comp_id, details in projet.competences_obligatoires.items():
        competence_q |= Q(competence__id=comp_id, niveau=details['niveau'])

    # Filtrer les utilisateurs via les compétences obligatoires
    matching_competences = UtilisateurCompetence.objects.filter(competence_q)
    matching_user_ids = matching_competences.values_list('utilisateur_id', flat=True)

    # Mobilité: compatibilité stricte ou 'mixte'
    mobilites_acceptables = [projet.mobilite]
    if projet.mobilite != 'mixte':
        mobilites_acceptables.append('mixte')

    # Récupérer tous les utilisateurs compatibles
    candidats = DjangoUtilisateur.objects.filter(
        id__in=matching_user_ids,
        salaire_horaire__lte=projet.budget_max,
        mobilite__in=mobilites_acceptables
    ).prefetch_related('disponibilite_set', 'utilisateurcompetence_set')

    for user in candidats:
        # Compétences de l'utilisateur
        competences = [
            {'id': comp.competence.id, 'niveau': comp.niveau}
            for comp in user.utilisateurcompetence_set.all()
        ]

        # Disponibilités formatées
        disponibilites = {
            dispo.jour: {
                'debut': dispo.heure_debut.strftime('%H:%M') if dispo.heure_debut else '',
                'fin': dispo.heure_fin.strftime('%H:%M') if dispo.heure_fin else ''
            }
            for dispo in user.disponibilite_set.all()
        }

        algo_user = AlgoUtilisateur(
            id=user.id,
            competences=competences,
            disponibilites=disponibilites,
            preferences={
                'mobilite': user.mobilite,
                'horaires': 'matin'  # placeholder, à ajuster selon ce que tu veux
            },
            experience={
                'annees': user.annees_experience,
                'projets_realises': user.projets_realises
            },
            salaire_horaire=float(user.salaire_horaire) if user.salaire_horaire else 0.0,
            historique_notes=user.historique_notes if user.historique_notes else [],
            mobilite=user.mobilite
        )

        utilisateurs.append(algo_user)

    return utilisateurs
