import json
import os

DATA_DIR = "data"
FEEDBACK_FILE = os.path.join(DATA_DIR, "historique_feedbacks.json")

def enregistrer_feedback(projet_id, coefficients, resultat, poids, cible):
    feedback = {
        "projet_id": projet_id,
        "coefficients": coefficients,
        "resultat": resultat,
        "poids": poids,
        "cible": cible
    }
    feedbacks = charger_feedbacks()
    feedbacks.append(feedback)
    os.makedirs(DATA_DIR, exist_ok=True)
    with open(FEEDBACK_FILE, "w") as f:
        json.dump(feedbacks, f, indent=4)

def charger_feedbacks():
    if not os.path.exists(FEEDBACK_FILE):
        return []
    with open(FEEDBACK_FILE, "r") as f:
        return json.load(f)
