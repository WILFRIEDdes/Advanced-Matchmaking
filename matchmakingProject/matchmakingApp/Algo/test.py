import random
from collecte_feedbacks import traiter_feedbacks_utilisateurs
from coefficients import obtenir_coefficients

def generer_feedbacks_test(n=100):
    feedbacks = []
    for _ in range(n):
        utilisateur_id = random.randint(1, 100)
        reponses = {
            "q1": 5.0,   
            "q2": 1.0,  
            "q3": 2.5,   
            "q4": 5.0, 
            "q5": 1.0,   
        }
        poids = round(random.uniform(1.0, 2.0), 1)

        feedbacks.append({
            "utilisateur_id": utilisateur_id,
            "reponses": reponses,
            "poids": poids
        })
    return feedbacks

def afficher_stats_feedbacks(feedbacks):
    print("\n📊 Moyennes des notes données (feedbacks simulés) :")
    q_tot = {"q1": 0, "q2": 0, "q4": 0, "q5": 0}
    for fb in feedbacks:
        for q in q_tot:
            q_tot[q] += fb["reponses"][q]
    for q in q_tot:
        moyenne = q_tot[q] / len(feedbacks)
        print(f" - {q:<3} ({q_to_cible(q):<25}) : {moyenne:.2f}")

def q_to_cible(q):
    return {
        "q1": "notes",
        "q2": "competences_obligatoires",
        "q4": "experience",
        "q5": "competences_bonus"
    }[q]

def afficher_comparaison(anciens, nouveaux, attentes):
    print("\n📈 Comparaison des coefficients :")
    for cle in anciens:
        avant = round(anciens[cle], 3)
        apres = round(nouveaux.get(cle, 0), 3)
        variation = round(apres - avant, 3)
        direction = "➡️" if variation == 0 else ("⬆️" if variation > 0 else "⬇️")
        attendu = attentes.get(cle, "—")
        statut = "✅ cohérent" if direction in attendu else "⚠️ incohérent" if attendu != "—" else ""
        print(f"{cle:<25} : {avant} → {apres} {direction}  (Δ = {variation:+.3f})   {attendu} {statut}")

def main():
    print("🧪 Test de comportement IA après feedbacks extrêmes")
    anciens = obtenir_coefficients()

    feedbacks = generer_feedbacks_test(n=100)
    afficher_stats_feedbacks(feedbacks)

    attentes = {
        "notes": "⬆️ attendu",
        "competences_obligatoires": "⬇️ attendu",
        "experience": "⬆️ attendu",
        "competences_bonus": "⬇️ attendu"
    }

    nouveaux = traiter_feedbacks_utilisateurs(projet_id=999, feedbacks_utilisateurs=feedbacks)

    if nouveaux:
        afficher_comparaison(anciens, nouveaux, attentes)
    else:
        print("⚠️ Aucun ajustement effectué (feedbacks insuffisants ?)")

if __name__ == "__main__":
    main()
