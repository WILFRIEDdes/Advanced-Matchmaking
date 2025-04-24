import os
import joblib

def obtenir_coefficients():
    """
    Renvoie un dictionnaire contenant les coefficients de pondération utilisés
    pour le calcul des scores.

    :return: Dictionnaire des coefficients
    """
    coefficients = {
        "competences_obligatoires": 1,
        "competences_bonus": 0.5,
        "experience": 1,
        "notes": 1
    }
    return coefficients

def obtenir_coefficients():
    if os.path.exists("modele_coefficients.pkl"):
        model = joblib.load("modele_coefficients.pkl")
        importances = model.feature_importances_
        coefficients = {
            "competences_obligatoires": min(max(importances[0]*5, 0), 2),
            "competences_bonus": min(max(importances[1]*5, 0), 2),
            "experience": min(max(importances[2]*5, 0), 2),
            "notes": min(max(importances[3]*5, 0), 2),
        }
    else:
        coefficients = {
            "competences_obligatoires": 1,
            "competences_bonus": 0.5,
            "experience": 1,
            "notes": 1
        }
    return coefficients