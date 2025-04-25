import random
from collecte_feedbacks import traiter_feedbacks_utilisateurs
from coefficients import obtenir_coefficients

def generer_feedbacks_entrainement(n=1000):
    """
    Génère des feedbacks avec une logique contrôlée :
    - notes et expérience → hautes
    - competences_obligatoires et bonus → faibles
    """
    feedbacks = []
    for i in range(n):
        utilisateur_id = random.randint(1, 100)

        if i < n * 0.5:
            # notes et expérience élevées, co_obl et bonus faibles
            reponses = {
                "q1": random.uniform(4.0, 5.0),  # notes
                "q2": random.uniform(1.0, 2.5),  # co_obl
                "q3": random.uniform(2.0, 3.5),  # ignorée
                "q4": random.uniform(4.0, 5.0),  # expérience
                "q5": random.uniform(1.0, 2.5),  # bonus
            }
        else:
            # Tout inversé : co_obl/bonus bons, notes/exp moins bons
            reponses = {
                "q1": random.uniform(2.0, 3.0),  # notes
                "q2": random.uniform(4.0, 5.0),  # co_obl
                "q3": random.uniform(2.0, 3.5),
                "q4": random.uniform(2.0, 3.0),  # expérience
                "q5": random.uniform(4.0, 5.0),  # bonus
            }

        poids = round(random.uniform(1.0, 2.0), 1)
        feedbacks.append({
            "utilisateur_id": utilisateur_id,
            "reponses": reponses,
            "poids": poids
        })

    return feedbacks

def afficher_variations(anciens, nouveaux):
    print("\n🎯 Comparaison des coefficients :")
    for cle in anciens:
        avant = round(anciens[cle], 3)
        apres = round(nouveaux[cle], 3)
        variation = round(apres - avant, 3)
        symbole = "➡️" if variation == 0 else ("⬆️" if variation > 0 else "⬇️")
        print(f"{cle:<25} : {avant} → {apres} {symbole}  (Δ = {variation:+.3f})")

def main():
    print("🚀 Lancement de l'entraînement IA sur 200 feedbacks simulés...")
    
    anciens = obtenir_coefficients()
    feedbacks = generer_feedbacks_entrainement(n=200)
    nouveaux = traiter_feedbacks_utilisateurs(projet_id=101, feedbacks_utilisateurs=feedbacks)

    if nouveaux:
        afficher_variations(anciens, nouveaux)
    else:
        print("❌ Aucun ajustement effectué — peut-être un problème dans les données.")

if __name__ == "__main__":
    main()
