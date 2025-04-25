from .feedback_manager import enregistrer_feedback
from .ia_ajustement import ajuster_coefficients_par_question
from .coefficients import obtenir_coefficients
import random


def traiter_feedbacks_utilisateurs(projet_id, feedbacks_utilisateurs, seed=None):
    """
    feedbacks_utilisateurs : liste de dictionnaires contenant :
        - utilisateur_id : int
        - reponses : dict avec q1 à q5 (scores de 1 à 5)
        - poids : float
    """
    if seed is not None:
        random.seed(seed)

    i = 0
    for feedback in feedbacks_utilisateurs:
        print(f"Traitement du feedback {i+1}/{len(feedbacks_utilisateurs)}...")
        i += 1
        reponses = feedback["reponses"]
        poids = feedback["poids"]

        coeffs_utilises = {
            "competences_obligatoires": round(random.uniform(0.2, 2.0), 3),
            "competences_bonus": round(random.uniform(0.2, 2.0), 3),
            "experience": round(random.uniform(0.2, 2.0), 3),
            "notes": round(random.uniform(0.2, 2.0), 3),
            "communication": 1.0  # fixe, ignorée
        }

        # Mapping questions → score de satisfaction (entre 0 et 1)
        resultats = {
            "notes": reponses.get("q1", 0) / 5.0,
            "competences_obligatoires": reponses.get("q2", 0) / 5.0,
            "experience": reponses.get("q4", 0) / 5.0,
            "competences_bonus": reponses.get("q5", 0) / 5.0,
        }

        for clef, resultat in resultats.items():
            enregistrer_feedback(projet_id, coeffs_utilises, resultat, poids, cible=clef)

    # Mise à jour IA spécifique par question
    nouveaux_coeffs = ajuster_coefficients_par_question()
    return nouveaux_coeffs
