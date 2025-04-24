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
        print (f"feedback : {feedback}")
        print (f"reponses : {reponses}")
        print(f"reponses.values() : {reponses.values()}")
        print (f"len(reponses) : {len(reponses)}")
        valeurs = list(map(int, reponses.values()))
        print (f"valeurs : {valeurs}")
        print (f"sum(valeurs) : {sum(valeurs)}")
        note_globale = sum(valeurs) / len(reponses)
        resultat = 1 if note_globale >= 3.5 else 0
        poids = feedback["poids"]
        coeffs_utilises = obtenir_coefficients()

        enregistrer_feedback(projet_id, coeffs_utilises, resultat, poids)

    # Mise à jour IA
    nouveaux_coeffs = ajuster_coefficients()
    return nouveaux_coeffs
