# ia_ajustement.py
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import cross_val_score
import numpy as np
from .feedback_manager import charger_feedbacks
import joblib
import os
import json
from datetime import datetime

MODEL_FILE = "modele_coefficients.pkl"

def ajuster_coefficients():
    feedbacks = charger_feedbacks()
    if len(feedbacks) < 10:
        return None  # Pas assez de données

    X = []
    y = []
    sample_weights = []

    for fb in feedbacks:
        X.append([fb["coefficients"].get(k, 0) for k in ["competences_obligatoires", "competences_bonus", "experience", "notes"]])
        y.append(fb["resultat"])
        sample_weights.append(fb["poids"])

    X = np.array(X)
    y = np.array(y)

    model = RandomForestRegressor(n_estimators=100, random_state=42)
    scores = cross_val_score(model, X, y, cv=5, scoring="neg_mean_squared_error")
    mean_score = -np.mean(scores)

    if True:# mean_score < 0.1:  # Assez bon         ---------- A MODIFIER ------------------
        model.fit(X, y, sample_weight=sample_weights)
        joblib.dump(model, MODEL_FILE)

        # Ajustement des coefficients
        importances = model.feature_importances_
        nouveaux_coeffs = {
            "competences_obligatoires": min(max(importances[0]*5, 0), 2),
            "competences_bonus": min(max(importances[1]*5, 0), 2),
            "experience": min(max(importances[2]*5, 0), 2),
            "notes": min(max(importances[3]*5, 0), 2),
        }
        return nouveaux_coeffs
    return None

def sauver_coefficients(coeffs):
    historique_path = "historique_coefficients.json"
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
