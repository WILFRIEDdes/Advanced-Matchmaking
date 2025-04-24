import random
import json
from faker import Faker

from matchmakingApp.models import Utilisateur, Competence
from .query import insert_users, delete_users

fake = Faker()

def get_next_user_id():
    last_user = Utilisateur.objects.order_by('-id').first()
    return last_user.id + 1 if last_user else 1

def get_competences_from_db():
    return list(Competence.objects.all())

def generate_users(n, starting_id):
    users = []
    for i in range(starting_id, starting_id + n):
        password = fake.password()
        last_login = None
        is_superuser = 0
        nom = fake.last_name()
        prenom = fake.first_name()
        mail = fake.email()
        role = random.choices(["employe", "manager"], weights=[90, 10])[0]
        annees_experience = random.randint(0, 30)
        projets_realises = random.randint(0, 20)
        salaire_horaire = round(random.uniform(10, 50), 2)
        historique_notes = [random.randint(1, 5) for _ in range(random.randint(1, 10))]
        historique_notes_normalisees = [note / 5 for note in historique_notes]  # Normalisation
        moyenne_notes = sum(historique_notes_normalisees) / len(historique_notes_normalisees)
        mobilite = random.choice(['presentiel', 'distanciel', 'mixte'])
        score_projet = None
        is_active = 1
        is_staff = 0

        user = {
            "id": i,
            "password": password,
            "last_login": last_login,
            "is_superuser": is_superuser,
            "nom": nom,
            "prenom": prenom,
            "mail": mail,
            "role": role,
            "annees_experience": annees_experience,
            "projets_realises": projets_realises,
            "salaire_horaire": salaire_horaire,
            "moyenne_notes": moyenne_notes,
            "historique_notes": json.dumps(historique_notes),
            "mobilite": mobilite,
            "score_projet": score_projet,
            "is_active": is_active,
            "is_staff": is_staff,
        }
        users.append(user)
    return users


def assign_competences(users, competences):
    user_competences = []
    for user in users:
        max_comp = min(15, len(competences))
        nb = random.randint(3, max_comp)
        selected = random.sample(competences, nb)
        for comp in selected:
            niveau = random.choice(["Débutant", "Novice", "Intermédiaire", "Avancé", "Expert"])
            user_competences.append((user["id"], comp.id, niveau))
    return user_competences


def generate_disponibilites(users):
    jours = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi"]
    disponibilites = []
    for user in users:
        for jour in random.sample(jours, random.randint(4, 5)):
            heure_debut = f"{random.randint(7, 10)}:00:00"
            heure_fin = f"{random.randint(16, 20)}:00:00"
            disponibilites.append({
                "utilisateur_id": user["id"],
                "jour": jour,
                "heure_debut": heure_debut,
                "heure_fin": heure_fin
            })
    return disponibilites

def generate_and_insert_users(n):
    num_users = n
    start_id = get_next_user_id()
    competences = get_competences_from_db()
    
    users = generate_users(num_users, start_id)
    user_competences = assign_competences(users, competences)
    disponibilites = generate_disponibilites(users)
    
    print(f"{len(users)} utilisateurs générés.")
    print(f"{len(user_competences)} compétences assignées.")
    print(f"{len(disponibilites)} disponibilités générées.")
    # delete_users(users) 
    insert_users(users, disponibilites, user_competences)
    print("Utilisateurs insérés avec succès !")