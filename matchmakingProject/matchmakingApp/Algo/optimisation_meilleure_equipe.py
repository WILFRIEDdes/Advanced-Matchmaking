import random
from .classes import Equipe, Projet, Utilisateur
from .score_equipe import calculer_scores_equipes
from .coefficients import obtenir_coefficients

def mutation(equipe: Equipe, utilisateurs: list[Utilisateur], projet: Projet):
    """
    Effectue une mutation sur une équipe en remplaçant un membre aléatoire.
    """
    if not utilisateurs:
        return equipe

    membre_a_remplacer = random.choice(equipe.membres)
    nouveau_membre = random.choice([u for u in utilisateurs if u not in equipe.membres])
    nouvelle_equipe_membres = [m if m != membre_a_remplacer else nouveau_membre for m in equipe.membres]

    equipe_mutante = Equipe(
        projet=projet,
        membres=nouvelle_equipe_membres,
        heures_totales=equipe.heures_totales,
        competences_necessaires={},
        competences_bonus={},
        mobilite={}
    )

    # Calcul du score de l'équipe mutante
    equipe_mutante = calculer_scores_equipes(projet, [equipe_mutante], obtenir_coefficients())[0]

    return equipe_mutante

def algorithme_genetique(equipe: Equipe, utilisateurs: list[Utilisateur], projet: Projet, generations=100):
    """
    Algorithme génétique pour optimiser une seule équipe.
    """
    meilleure_equipe = equipe
    for _ in range(generations):
        # Mutation
        enfant = mutation(meilleure_equipe, utilisateurs, projet)

        if enfant.score_global > meilleure_equipe.score_global:
            meilleure_equipe = enfant

    # Retourne la meilleure équipe
    return meilleure_equipe
