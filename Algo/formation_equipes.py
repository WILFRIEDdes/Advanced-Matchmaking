from classes import Projet, Utilisateur, Equipe
from score_equipe import calculer_scores_equipes
from coefficients import obtenir_coefficients

def former_equipes(projet: Projet, utilisateurs: list[Utilisateur], max_utilisateurs: int):
    """
    Forme des équipes pour un projet donné en utilisant des heuristiques gloutonnes.

    :param projet: Objet Projet
    :param utilisateurs: Liste d'objets Utilisateur triés par score décroissant
    :param max_utilisateurs: Nombre maximum d'utilisateurs à prendre en compte
    :return: Liste d'objets Equipe
    """
    equipes = []
    utilisateurs_restants = sorted(utilisateurs[:max_utilisateurs], key=lambda u: u.score_projet, reverse=True)

    while utilisateurs_restants:
        equipe_membres = []
        competences_couvertes = {}
        competences_bonus_couvertes = {}
        budget_total = 0
        mobilite_equipe = {"presentiel": 0, "distanciel": 0, "hybride": 0}

        for utilisateur in utilisateurs_restants[:]:
            if budget_total + utilisateur.salaire_horaire > projet.budget_max:
                continue

            # Vérifie si l'utilisateur peut contribuer aux compétences obligatoires
            for comp_id, details in projet.competences_obligatoires.items():
                if comp_id in [comp.id for comp in utilisateur.competences]:
                    competence = next(comp for comp in utilisateur.competences if comp.id == comp_id)
                    if competence.niveau >= details["niveau"]:
                        competences_couvertes[comp_id] = competences_couvertes.get(comp_id, 0) + 1

            # Vérifie si l'utilisateur peut contribuer aux compétences bonus
            for comp_id, details in projet.competences_bonus.items():
                if comp_id in [comp.id for comp in utilisateur.competences]:
                    competence = next(comp for comp in utilisateur.competences if comp.id == comp_id)
                    if competence.niveau >= details["niveau"]:
                        competences_bonus_couvertes[comp_id] = competences_bonus_couvertes.get(comp_id, 0) + 1

            equipe_membres.append(utilisateur)
            budget_total += utilisateur.salaire_horaire
            mobilite_equipe[utilisateur.mobilite] += 1
            if utilisateur.mobilite == "hybride":
                mobilite_equipe["presentiel"] += 1
                mobilite_equipe["distanciel"] += 1
            utilisateurs_restants.remove(utilisateur)

            if len(equipe_membres) >= projet.taille_equipe["max"]:
                break

        # Vérifie si toutes les compétences obligatoires sont couvertes avec le nombre requis de personnes
        if all(competences_couvertes.get(comp_id, 0) < details["nombre_personnes"]
                   for comp_id, details in projet.competences_obligatoires.items()):
            continue

        # Crée une équipe si elle respecte les contraintes
        if len(equipe_membres) >= projet.taille_equipe["min"]:
            equipe = Equipe(
                projet=projet,
                membres=equipe_membres,
                heures_totales=sum(projet.horaires[jour]["fin"] - projet.horaires[jour]["debut"]
                                   for jour in projet.horaires),
                competences_necessaires=competences_couvertes,
                competences_bonus=competences_bonus_couvertes,
                mobilite=mobilite_equipe
            )
            equipes.append(equipe)
    
    equipes_scores = calculer_scores_equipes(projet, equipes, obtenir_coefficients())

    return equipes_scores