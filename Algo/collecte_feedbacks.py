from feedback_manager import enregistrer_feedback
from ia_ajustement import ajuster_coefficients_par_question
from coefficients import obtenir_coefficients

def traiter_feedbacks_utilisateurs(projet_id, feedbacks_utilisateurs):
    """
    feedbacks_utilisateurs : liste de dictionnaires contenant :
        - utilisateur_id : int
        - reponses : dict avec q1 à q5 (scores de 1 à 5)
        - poids : float
    """
    for feedback in feedbacks_utilisateurs:
        reponses = feedback["reponses"]
        poids = feedback["poids"]
        coeffs_utilises = obtenir_coefficients()

        # Associer chaque question à un résultat spécifique
        resultats = {
            "notes": 1 if reponses["q1"] >= 3.5 else 0,
            "competences_obligatoires": 1 if reponses["q2"] >= 3.5 else 0,
            "communication": 1 if reponses["q3"] >= 3.5 else 0,
            "experience": 1 if reponses["q4"] >= 3.5 else 0,
            "competences_bonus": 1 if reponses["q5"] >= 3.5 else 0,
        }

        for clef, resultat in resultats.items():
            # Enregistrer le feedback associé à UNE cible
            enregistrer_feedback(projet_id, coeffs_utilises, resultat, poids, cible=clef)

    # Mise à jour IA spécifique par question
    nouveaux_coeffs = ajuster_coefficients_par_question()
    return nouveaux_coeffs
