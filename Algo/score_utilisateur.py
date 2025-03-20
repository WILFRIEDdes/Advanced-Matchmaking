from classes import Projet, Utilisateur

def calculer_score_utilisateur(projet: Projet, utilisateurs: list[Utilisateur], coefficients: dict):
    """
    Calcule le score de chaque utilisateur pour un projet donné.

    :param projet: Objet Projet
    :param utilisateurs: Liste d'objets Utilisateur
    :param coefficients: Dictionnaire des coefficients de pondération
    :return: utilisateurs: Liste d'objets Utilisateur
    """

    for utilisateur in utilisateurs:
        score = 0

        # Compétences obligatoires
        for comp_id, details in projet.competences_obligatoires.items():
            if comp_id in [comp.id for comp in utilisateur.competences]:
                competence = next(comp for comp in utilisateur.competences if comp.id == comp_id)
                if competence.niveau >= details["niveau"]:
                    score += coefficients.get("competences_obligatoires", 1) * details["niveau"]

        # Compétences bonus
        for comp_id, details in projet.competences_bonus.items():
            if comp_id in [comp.id for comp in utilisateur.competences]:
                competence = next(comp for comp in utilisateur.competences if comp.id == comp_id)
                if competence.niveau >= details["niveau"]:
                    score += coefficients.get("competences_bonus", 0.5) * details["niveau"]

        # Expérience
        for critere in projet.criteres_experience:
            if (utilisateur.experience["annees"] >= critere["annees_min"] and
                utilisateur.experience["projets_realises"] >= critere["projets_min"]):
                score += coefficients.get("experience", 1)

        # Notes historiques
        score += coefficients.get("notes", 1) * utilisateur.repmaster["moyenne_notes"]

        utilisateur.score_projet = score

    return utilisateurs