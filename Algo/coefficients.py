def obtenir_coefficients():
    """
    Renvoie un dictionnaire contenant les coefficients de pondération utilisés
    pour le calcul des scores.

    :return: Dictionnaire des coefficients
    """
    coefficients = {
        "competences_obligatoires": 1,
        "competences_bonus": 0.5,
        "experience": 1,
        "notes": 1
    }
    return coefficients