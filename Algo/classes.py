class Competence:
    def __init__(self, id, nom, niveau):
        self.id = id # Id dans la base de données
        self.nom = nom
        self.niveau = niveau # Niveau de compétence de 1 à 5

class Utilisateur:
    def __init__(self, id, competences, disponibilites, preferences, experience, salaire_horaire, historique_notes, mobilite, score_projet=-1):
        self.id = id # Id dans la base de données
        self.competences = competences  # Liste d'objets Competence
        self.disponibilites = disponibilites  # Dictionnaire {jour: horaires}
        self.preferences = preferences  # Dictionnaire {utilisateur_id: positive/negative, competence_id: positive/negative}
        self.experience = experience  # Dictionnaire {annees: int, projets_realises: int}
        self.salaire_horaire = salaire_horaire
        moyenne_notes = sum(historique_notes) / len(historique_notes) if historique_notes else 0
        self.repmaster = {"moyenne_notes": moyenne_notes, "historique_notes": historique_notes}  # Dictionnaire {moyenne_notes: float, historique_notes: liste de float}
        self.mobilite = mobilite # Peut être présentiel, distanciel ou les deux
        self.score_projet = score_projet # Score de l'utilisateur par défaut à -1

class Projet:
    def __init__(self, id, nom, date_debut, date_fin, horaires, competences_obligatoires, competences_bonus, taille_equipe, criteres_experience, budget_max, mobilite):
        self.id = id  # Id dans la base de données
        self.nom = nom  # Nom du projet
        self.date_debut = date_debut  # Date de début du projet
        self.date_fin = date_fin  # Date de fin du projet
        self.horaires = horaires  # Dictionnaire {jour: {debut: int, fin: int}}
        self.competences_obligatoires = competences_obligatoires  # Dictionnaire {competence_id: {"niveau": int, "nombre_personnes": int}}
        self.competences_bonus = competences_bonus  # Dictionnaire {competence_id: {"niveau": int, "nombre_personnes": int}}
        self.taille_equipe = taille_equipe  # Dictionnaire {"min": int, "max": int}
        self.criteres_experience = criteres_experience  # Liste de dictionnaires {"annees_min": int, "projets_min": int, "nombre_personnes": int}
        self.budget_max = budget_max  # Budget maximum alloué pour les salaires
        self.mobilite = mobilite  # Peut être présentiel, distanciel ou hybride

class Equipe:
    def __init__(self, projet, membres, heures_totales, competences_necessaires, competences_bonus, mobilite, score_global):
        self.projet = projet # Objet Projet
        self.membres = membres  # Liste d'objets Utilisateur
        self.taille = len(membres)  # Nombre de membres
        self.heures_totales = heures_totales
        self.budget_total = sum(membre.salaire_horaire * self.heures_totales for membre in membres)  # Somme des salaires horaires * heures totales du projet
        self.heures_hommes = heures_totales*self.taille  # Total des heures travaillées par tous les membres
        self.competences_necessaires = competences_necessaires  # Dictionnaire {competence_id: liste d'utilisateurs}
        self.competences_bonus = competences_bonus  # Dictionnaire {competence_id: liste d'utilisateurs}
        self.mobilite = mobilite  # Dictionnaire {presentiel: int, distanciel: int, hybride: int}
        self.score_global = score_global  # Score global de l'équipe