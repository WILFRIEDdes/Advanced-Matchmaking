# ia_ajustement.py
from sklearn.ensemble import RandomForestRegressor
import numpy as np
from .feedback_manager import charger_feedbacks
import joblib
import os
import json
from datetime import datetime

DATA_DIR = "data"
MODEL_FILE_TEMPLATE = os.path.join(DATA_DIR, "modele_{cible}.pkl")


COEFFS_CIBLES = ["notes", "competences_obligatoires", "experience", "competences_bonus"]

def ajuster_coefficients_par_question():
    feedbacks = charger_feedbacks()
    if len(feedbacks) < 10:
        return None

    nouveaux_coeffs = {}

    for cible in COEFFS_CIBLES:
        X = []
        y = []
        weights = []

        for fb in feedbacks:
            if fb.get("cible") != cible:
                continue
            coeffs = fb["coefficients"]
            X.append([
                coeffs.get("competences_obligatoires", 0),
                coeffs.get("competences_bonus", 0),
                coeffs.get("experience", 0),
                coeffs.get("notes", 0),
            ])
            y.append(fb["resultat"])
            weights.append(fb["poids"])

        if len(X) < 5:
            continue  # Pas assez de données pour cette cible

        X = np.array(X)
        y = np.array(y)

        model = RandomForestRegressor(n_estimators=100, random_state=42)
        model.fit(X, y, sample_weight=weights)

        importances = model.feature_importances_

        index_map = {
            "competences_obligatoires": 0,
            "competences_bonus": 1,
            "experience": 2,
            "notes": 3,
        }

        idx = index_map[cible]
        nouvelle_valeur = min(max(importances[idx] * 5, 0), 2)
        nouveaux_coeffs[cible] = nouvelle_valeur

        joblib.dump(model, MODEL_FILE_TEMPLATE.format(cible=cible))

    sauver_coefficients(nouveaux_coeffs)
    return nouveaux_coeffs

def sauver_coefficients(coeffs):
    historique_path = os.path.join(DATA_DIR, "historique_coefficients.json")
    os.makedirs(DATA_DIR, exist_ok=True)
    if os.path.exists(historique_path):
        with open(historique_path, "r") as f:
            historique = json.load(f)
    else:
        historique = []

    historique.append({
        "timestamp": datetime.now().isoformat(),
        "coefficients": coeffs
    })

    with open(historique_path, "w") as f:
        json.dump(historique, f, indent=4)

