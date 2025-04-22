from collecte_feedbacks import traiter_feedbacks_utilisateurs
from coefficients import obtenir_coefficients
from datetime import date
from classes import Projet
import random

# 1. Créer un faux projet (minimal)
projet_test = Projet(
    id=999,
    nom="Projet Test Influence Technique",
    date_debut=date(2025, 5, 1),
    date_fin=date(2025, 6, 1),
    horaires={}, competences_obligatoires={}, competences_bonus={},
    taille_equipe={"min": 3, "max": 5},
    criteres_experience=[],
    budget_max=10000,
    mobilite="distanciel"
)

# 2. Obtenir les coefficients avant feedbacks
coeffs_avant = obtenir_coefficients()
print("✅ Coefficients avant feedback :", coeffs_avant)

# 3. Générer des feedbacks avec q2 bas (technique)
feedbacks_q2_basse = []
for i in range(30):
    reponses = {
        "q1": 5,
        "q2": 1,  # 👈 compétences techniques faibles
        "q3": 5,
        "q4": 5,
        "q5": 5
    }
    poids = round(random.uniform(1.0, 2.0), 2)
    feedbacks_q2_basse.append({
        "utilisateur_id": i + 1,
        "reponses": reponses,
        "poids": poids
    })

# 4. Appliquer le pipeline d'ajustement
traiter_feedbacks_utilisateurs(projet_test.id, feedbacks_q2_basse)

# 5. Recharger les coefficients après apprentissage
coeffs_apres = obtenir_coefficients()
print("✅ Coefficients après feedback :", coeffs_apres)

# 6. Comparer l'évolution du coefficient "competences_obligatoires"
diff = coeffs_apres["competences_obligatoires"] - coeffs_avant["competences_obligatoires"]
print(f"\n📊 Évolution du coefficient 'competences_obligatoires' : {coeffs_avant['competences_obligatoires']} → {coeffs_apres['competences_obligatoires']} (diff: {diff:.3f})")

if diff < 0:
    print("✅ Le coefficient a diminué comme attendu (les feedbacks sur la technique étaient négatifs).")
elif diff == 0:
    print("⚠️ Le coefficient n'a pas changé. Peut-être que le modèle n'a pas assez appris.")
else:
    print("❌ Le coefficient a augmenté, ce qui est incohérent avec des retours techniques négatifs.")
