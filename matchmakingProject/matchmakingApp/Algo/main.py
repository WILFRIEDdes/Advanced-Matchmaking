from datetime import date
from .classes import Competence, Utilisateur, Projet
from .tri_initial import *
from .score_utilisateur import *
from .formation_equipes import *
from .optimisation_meilleure_equipe import *
from .coefficients import obtenir_coefficients
from .feedback_manager import enregistrer_feedback
from .ia_ajustement import ajuster_coefficients, sauver_coefficients
from .collecte_feedbacks import traiter_feedbacks_utilisateurs
import random

def pipeline_creation_equipe(projet):
    print(f"\n==== 📋 Pipeline : Création d'équipe optimale pour le projet '{projet.nom}' ====\n")

    # competences_possibles = [Competence(i, f"Comp{i}") for i in range(1, 6)]
    # mobilites = ["presentiel", "distanciel", "hybride"]
    # jours_semaine = ["lundi", "mardi", "mercredi", "jeudi", "vendredi"]

    # for uid in range(1, 16):
    #     competences = random.sample(competences_possibles, random.randint(1, 3))
    #     for competence in competences:
    #         competence.niveau = random.randint(1, 5)
    #     disponibilites = {jour: {"debut": 7, "fin": 17} for jour in jours_semaine}
    #     preferences = {}
    #     experience = {"annees": random.randint(1, 10), "projets_realises": random.randint(1, 20)}
    #     salaire_horaire = random.randint(15, 50)
    #     historique_notes = [round(random.uniform(2.5, 5.0), 1) for _ in range(random.randint(3, 10))]
    #     mobilite = random.choice(mobilites)
        
    #     utilisateur = Utilisateur(uid, competences, disponibilites, preferences, experience, salaire_horaire, historique_notes, mobilite)
    #     utilisateurs.append(utilisateur) 

    # print(" -------------- Utilisateurs générés --------------")
    # for utilisateur in utilisateurs:
    #     print(f"Utilisateur {utilisateur.id}: {[competence.nom for competence in utilisateur.competences]}, Mobilité: {utilisateur.mobilite}, Salaire horaire: {utilisateur.salaire_horaire}")
    
    
    utilisateurs = obtenir_utilisateurs_depuis_projet(projet)
    print("-------------- Utilisateurs pour le projet --------------")
    for utilisateur in utilisateurs:
       print(f"Utilisateur {utilisateur.id}: {[(competence.nom,competence.niveau) for competence in utilisateur.competences]}, Mobilité: {utilisateur.mobilite}, Salaire horaire: {utilisateur.salaire_horaire}")
    

    # Étape 1 : Calcul des scores des utilisateurs
    coeffs = obtenir_coefficients()
    utilisateurs_scores = calculer_score_utilisateur(projet, utilisateurs, coeffs)
    print("✅ Scores calculés pour chaque utilisateur.")
    print("-------------- Scores des utilisateurs pour le projet --------------")
    for utilisateur in utilisateurs:
        print(f"Utilisateur {utilisateur.id}: {[competence.nom for competence in utilisateur.competences]}, Mobilité: {utilisateur.mobilite}, Salaire horaire: {utilisateur.salaire_horaire}, Score: {utilisateur.score_projet}")

    # Étape 2 : Formation d'équipes initiales
    equipes_initiales = former_equipes(projet, utilisateurs_scores, max_utilisateurs=10)

    # 🔍 Vérification : au moins une équipe valide ?
    equipe_valide = any(len(equipe.membres) >= projet.taille_equipe["min"] for equipe in equipes_initiales)
    if not equipe_valide:
        print("❌ Pas assez de membres disponibles pour créer une équipe respectant les critères du projet.")
        return None
    
    print(f"✅ {len(equipes_initiales)} équipes initiales générées.")
    print("-------------- Équipes initiales formées --------------")
    for equipe_initiale in equipes_initiales:
        print(f"Équipe : {[membre.id for membre in equipe_initiale.membres]}, Budget total: {equipe_initiale.budget_total} €, Score: {equipe_initiale.score_global}")

    # Étape 3 : Optimisation génétique
    meilleure_equipe = algorithme_genetique(equipes_initiales[0], utilisateurs, projet)
    print("✅ Meilleure équipe optimisée sélectionnée :")
    print(f"👥 Membres : {[m.id for m in meilleure_equipe.membres]}")
    print(f"💰 Budget total : {meilleure_equipe.budget_total} €")
    print(f"🌟 Score global : {meilleure_equipe.score_global}")
    print("-------------- Meilleure équipe optimisée --------------")
    print(f"Équipe : {[membre.id for membre in meilleure_equipe.membres]}, Budget total: {meilleure_equipe.budget_total} €, Score: {meilleure_equipe.score_global}")

    return meilleure_equipe

def pipeline_ajustement_coefficients(feedbacks, projet_id):
    print("\n==== 🤖 Pipeline : Ajustement des coefficients ====\n")

    print("📊 Coefficients actuels :", obtenir_coefficients())
    anciens_coeffs = obtenir_coefficients()
    nouveaux_coeffs = traiter_feedbacks_utilisateurs(projet_id, feedbacks)

    if nouveaux_coeffs:
        print("✅ Nouveaux coefficients générés par l'IA :", nouveaux_coeffs)
        sauver_coefficients(nouveaux_coeffs)
    else:
        print("⚠️ Pas d’ajustement effectué (feedbacks insuffisants ou incohérents).")
        sauver_coefficients(obtenir_coefficients())

    return (nouveaux_coeffs,anciens_coeffs)


if __name__ == "__main__":

    # -------------- Génération d'utilisateurs --------------

    competences_possibles = [Competence(i, f"Comp{i}") for i in range(1, 6)]
    mobilites = ["presentiel", "distanciel", "hybride"]
    jours_semaine = ["lundi", "mardi", "mercredi", "jeudi", "vendredi"]

    utilisateurs = []

    for uid in range(1, 16):
        competences = random.sample(competences_possibles, random.randint(1, 3))
        for competence in competences:
            competence.niveau = random.randint(1, 5)
        disponibilites = {jour: {"debut": 7, "fin": 17} for jour in jours_semaine}
        preferences = {}
        experience = {"annees": random.randint(1, 10), "projets_realises": random.randint(1, 20)}
        salaire_horaire = random.randint(15, 50)
        historique_notes = [round(random.uniform(2.5, 5.0), 1) for _ in range(random.randint(3, 10))]
        mobilite = random.choice(mobilites)
        
        utilisateur = Utilisateur(uid, competences, disponibilites, preferences, experience, salaire_horaire, historique_notes, mobilite)
        utilisateurs.append(utilisateur) 

    print(" -------------- Utilisateurs générés --------------")
    for utilisateur in utilisateurs:
        print(f"Utilisateur {utilisateur.id}: {[competence.nom for competence in utilisateur.competences]}, Mobilité: {utilisateur.mobilite}, Salaire horaire: {utilisateur.salaire_horaire}")



    # -------------- Création d'un projet --------------

    horaires = {
        "lundi": {"debut": 9, "fin": 17},
        "mardi": {"debut": 9, "fin": 17},
        "mercredi": {"debut": 9, "fin": 17},
        "jeudi": {"debut": 9, "fin": 17},
        "vendredi": {"debut": 9, "fin": 17}
    }

    competences_obligatoires = {
        1: {"niveau": 3, "nombre_personnes": 2},
        2: {"niveau": 2, "nombre_personnes": 1}
    }

    competences_bonus = {
        3: {"niveau": 1, "nombre_personnes": 1},
        4: {"niveau": 2, "nombre_personnes": 1}
    }

    taille_equipe = {"min": 3, "max": 5}

    criteres_experience = [
        {"annees_min": 2, "projets_min": 3, "nombre_personnes": 2},
        {"annees_min": 5, "projets_min": 5, "nombre_personnes": 1}
    ]

    # Création de l'objet Projet
    projet_demo = Projet(
        id=101,
        nom="Développement Plateforme Matchmaking",
        date_debut=date(2025, 4, 15),
        date_fin=date(2025, 7, 15),
        horaires=horaires,
        competences_obligatoires=competences_obligatoires,
        competences_bonus=competences_bonus,
        taille_equipe=taille_equipe,
        criteres_experience=criteres_experience,
        budget_max=18000,
        mobilite="distanciel"
    )

    # Affichage résumé du projet
    print("-------------- Projet créé --------------")
    print(f"Nom : {projet_demo.nom}")
    print(f"Dates : du {projet_demo.date_debut} au {projet_demo.date_fin}")
    print(f"Mobilité : {projet_demo.mobilite}")
    print(f"Budget max : {projet_demo.budget_max} €")
    print(f"Taille équipe : {projet_demo.taille_equipe}")
    print(f"Compétences obligatoires : {projet_demo.competences_obligatoires}")
    print(f"Compétences bonus : {projet_demo.competences_bonus}")
    print(f"Critères expérience : {projet_demo.criteres_experience}")

    # -------------- Calcul des scores des utilisateurs pour le projet --------------
    utilisateurs_scores = calculer_score_utilisateur(projet_demo, utilisateurs, obtenir_coefficients())
    print("-------------- Scores des utilisateurs pour le projet --------------")
    for utilisateur in utilisateurs:
        print(f"Utilisateur {utilisateur.id}: {[competence.nom for competence in utilisateur.competences]}, Mobilité: {utilisateur.mobilite}, Salaire horaire: {utilisateur.salaire_horaire}, Score: {utilisateur.score_projet}")

    # -------------- Formation des équipes --------------
    equipes_initiales = former_equipes(projet_demo, utilisateurs, max_utilisateurs=10)
    print("-------------- Équipes initiales formées --------------")
    for equipe_initiale in equipes_initiales:
        print(f"Équipe : {[membre.id for membre in equipe_initiale.membres]}, Budget total: {equipe_initiale.budget_total} €, Score: {equipe_initiale.score_global}")

    # -------------- Optimisation pour trouver la meilleure équipe --------------
    meilleure_equipe = algorithme_genetique(equipes_initiales[0], utilisateurs, projet_demo)
    print("-------------- Meilleure équipe optimisée --------------")
    print(f"Équipe : {[membre.id for membre in meilleure_equipe.membres]}, Budget total: {meilleure_equipe.budget_total} €, Score: {meilleure_equipe.score_global}")




    # -------------- Simulation de feedbacks utilisateurs --------------

    # q1 : Le projet s’est-il bien déroulé selon vous ? (1 à 5)

    # q2 : Avez-vous trouvé l’équipe compétente techniquement ? (1 à 5)

    # q3 : La communication au sein de l’équipe était-elle fluide ? (1 à 5)

    # q4 : Le projet a-t-il respecté les délais ? (1 à 5)

    # q5 : Vous êtes-vous senti à l’aise dans votre rôle ? (1 à 5)


    # Simuler des feedbacks utilisateurs de manière aléatoire
    feedbacks_simules = []
    for _ in range(20):
        utilisateur_id = random.randint(1, 15)
        reponses = {f"q{i}": random.randint(1, 5) for i in range(1, 6)}
        poids = round(random.uniform(1.0, 2.0), 1)
        feedbacks_simules.append({"utilisateur_id": utilisateur_id, "reponses": reponses, "poids": poids})


    # Traitement + mise à jour des coefficients

    print("\n>> ✅ Coefficients initiaux :", obtenir_coefficients())
    nouveaux_coeffs = traiter_feedbacks_utilisateurs(projet_demo.id, feedbacks_simules)


    if nouveaux_coeffs:
        print("\n>> ✅ Coefficients ajustés par l'IA :", nouveaux_coeffs)
        sauver_coefficients(nouveaux_coeffs)
    else:
        print("\n>> ⚠️ Pas d’ajustement (données insuffisantes ou modèle non concluant)")
        sauver_coefficients(obtenir_coefficients())