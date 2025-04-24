import os
import joblib

DATA_DIR = "data"

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
        model_path = os.path.join(DATA_DIR, f"modele_{cible}.pkl")
        if os.path.exists(model_path):
            model = joblib.load(model_path)
            importances = model.feature_importances_
            idx = index_map[cible]
            importance = importances[idx] if idx < len(importances) else 0
            valeur = min(max(importance * 5, 0), 2)
            coefficients[cible] = round(valeur, 3)
        else:
            coefficients[cible] = {
                "competences_obligatoires": 1,
                "competences_bonus": 0.5,
                "experience": 1,
                "notes": 1
            }[cible]

    return coefficients
