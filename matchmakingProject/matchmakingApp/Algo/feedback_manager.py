import json
import os

FEEDBACK_FILE = "historique_feedbacks.json"

def enregistrer_feedback(projet_id, coefficients, resultat, poids):
    feedback = {"projet_id": projet_id, "coefficients": coefficients, "resultat": resultat, "poids": poids}
    feedbacks = charger_feedbacks()
    feedbacks.append(feedback)
    with open(FEEDBACK_FILE, "w") as f:
        json.dump(feedbacks, f, indent=4)

def charger_feedbacks():
    if not os.path.exists(FEEDBACK_FILE):
        return []
    with open(FEEDBACK_FILE, "r") as f:
        return json.load(f)
