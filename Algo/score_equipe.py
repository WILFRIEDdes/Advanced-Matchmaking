from classes import Projet

def calculer_scores_equipes(projet: Projet, equipes: list, coefficients: dict):
    """
    Calcule les scores globaux pour une liste d'équipes pour un projet donné.

    :param projet: Objet Projet
    :param equipes: Liste d'objets Equipe
    :param coefficients: Dictionnaire des coefficients de pondération
    :return: Liste des équipes avec leurs scores mis à jour
    """
    for equipe in equipes:
        score_global = 0

        # Compétences obligatoires
        for comp_id, details in projet.competences_obligatoires.items():
            for membre in equipe.membres:
                if comp_id in [comp.id for comp in membre.competences]:
                    competence = next(comp for comp in membre.competences if comp.id == comp_id)
                    if competence.niveau >= details["niveau"]:
                        score_global += coefficients.get("competences_obligatoires", 1) * competence.niveau

        # Compétences bonus
        for comp_id, details in projet.competences_bonus.items():
            for membre in equipe.membres:
                if comp_id in [comp.id for comp in membre.competences]:
                    competence = next(comp for comp in membre.competences if comp.id == comp_id)
                    if competence.niveau >= details["niveau"]:
                        score_global += coefficients.get("competences_bonus", 1) * competence.niveau

        # Expérience
        for critere in projet.criteres_experience:
            membres_experimentes = [
                membre for membre in equipe.membres
                if membre.experience["annees"] >= critere["annees_min"] and
                membre.experience["projets_realises"] >= critere["projets_min"]
            ]
            if len(membres_experimentes) >= critere["nombre_personnes"]:
                score_global += coefficients.get("experience", 1)

        # Notes historiques
        score_global += coefficients.get("notes", 1) * sum(membre.repmaster["moyenne_notes"] for membre in equipe.membres)

        equipe.score_global = score_global
    
    equipes.sort(key=lambda e: e.score_global, reverse=True)

    return equipes