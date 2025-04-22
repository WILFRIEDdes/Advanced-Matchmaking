import os
import joblib

import os
import joblib

def obtenir_coefficients():
    coefficients = {}
    cibles = ["competences_obligatoires", "competences_bonus", "experience", "notes", "communication"]
    index_map = {
        "competences_obligatoires": 0,
        "competences_bonus": 1,
        "experience": 2,
        "notes": 3,
        "communication": 4
    }

    for cible in cibles:
        model_path = f"modele_{cible}.pkl"
        if os.path.exists(model_path):
            model = joblib.load(model_path)
            importances = model.feature_importances_
            # On prend l'importance de la feature qui correspond à la cible
            idx = index_map[cible]
            importance = importances[idx]
            valeur = min(max(importance * 5, 0), 2)
            coefficients[cible] = round(valeur, 3)
        else:
            # Valeur par défaut
            coefficients[cible] = {
                "competences_obligatoires": 1,
                "competences_bonus": 0.5,
                "experience": 1,
                "notes": 1,
                "communication": 1
            }[cible]
    
    return coefficients
