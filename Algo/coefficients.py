import os
import joblib

def obtenir_coefficients():
    coefficients = {}
    cibles = ["competences_obligatoires", "competences_bonus", "experience", "notes"]
    index_map = {
        "competences_obligatoires": 0,
        "competences_bonus": 1,
        "experience": 2,
        "notes": 3
    }

    for cible in cibles:
        model_path = f"modele_{cible}.pkl"
        if os.path.exists(model_path):
            model = joblib.load(model_path)
            importances = model.feature_importances_
            idx = index_map[cible]
            importance = importances[idx]
            valeur = min(max(importance * 5, 0), 2)
            coefficients[cible] = round(valeur, 3)
        else:
            # Valeurs par défaut
            coefficients[cible] = {
                "competences_obligatoires": 1,
                "competences_bonus": 0.5,
                "experience": 1,
                "notes": 1
            }[cible]

    return coefficients