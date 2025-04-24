from .feedback_manager import enregistrer_feedback
from .ia_ajustement import ajuster_coefficients
from .coefficients import obtenir_coefficients

def traiter_feedbacks_utilisateurs(projet_id, feedbacks_utilisateurs):
    """
    feedbacks_utilisateurs : liste de dictionnaires contenant :
        - utilisateur_id : int
        - reponses : dict avec q1 à q5 (scores de 1 à 5)
        - poids : float (basé sur expérience par exemple)
    """
    for feedback in feedbacks_utilisateurs:
        reponses = feedback["reponses"]
        note_globale = sum(reponses.values()) / len(reponses)
        resultat = 1 if note_globale >= 3.5 else 0
        poids = feedback["poids"]
        coeffs_utilises = obtenir_coefficients()

        enregistrer_feedback(projet_id, coeffs_utilises, resultat, poids)

    # Mise à jour IA
    nouveaux_coeffs = ajuster_coefficients()
    return nouveaux_coeffs
