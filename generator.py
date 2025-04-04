import random
import json
import uuid
from faker import Faker

from requete import insert_users

fake = Faker()

def generate_users(n):
    users = []
    for _ in range(n):
        user_id = str(uuid.uuid4())
        annees_experience = random.randint(0, 30)
        projets_realises = random.randint(0, 20)
        salaire_horaire = round(random.uniform(10, 50), 2)
        historique_notes = [random.randint(1, 5) for _ in range(random.randint(1, 10))]
        historique_notes_normalisees = [note / 5 for note in historique_notes]  # Normalisation
        moyenne_notes = sum(historique_notes_normalisees) / len(historique_notes_normalisees)
        mobilite = random.choice(['presentiel', 'distanciel', 'les deux'])
        score_projet = -1

        user = {
            "id": user_id,
            "annees_experience": annees_experience,
            "projets_realises": projets_realises,
            "salaire_horaire": salaire_horaire,
            "moyenne_notes": moyenne_notes,
            "historique_notes": json.dumps(historique_notes),
            "mobilite": mobilite,
            "score_projet": score_projet
        }
        users.append(user)
    return users


def generate_competences():
    competence_names = ["Python", "Django", "React", "Machine Learning", "Cloud", "DevOps"]
    return {i + 1: name for i, name in enumerate(competence_names)}


def assign_competences(users, competences):
    user_competences = []
    for user in users:
        num_competences = random.randint(1, len(competences))
        selected_competences = random.sample(list(competences.keys()), num_competences)
        for comp_id in selected_competences:
            niveau = random.choice(["Débutant", "Intermédiaire", "Avancé", "Expert"])
            user_competences.append((user["id"], comp_id, niveau))
    return user_competences


def generate_disponibilites(users):
    jours = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"]
    disponibilites = []
    for user in users:
        for jour in random.sample(jours, random.randint(4, 6)):
            heure_debut = f"{random.randint(7, 12)}:00:00"
            heure_fin = f"{random.randint(15, 20)}:00:00"
            disponibilites.append((user["id"], jour, heure_debut, heure_fin))
    return disponibilites

if __name__ == "__main__":
    num_users = 2
    users = generate_users(num_users)
    competences = generate_competences()
    user_competences = assign_competences(users, competences)
    disponibilites = generate_disponibilites(users)
    
    print("Utilisateurs:", users, "\n")
    print("Compétences:", competences, "\n")
    print("Utilisateur_Compétences:", user_competences, "\n")
    print("Disponibilités:", disponibilites, "\n")

users = generate_users(10)  # Générer 10 utilisateurs
insert_users(users)
print("Utilisateurs insérés avec succès !")