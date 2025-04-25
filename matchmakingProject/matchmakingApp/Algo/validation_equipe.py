def valider_equipe(equipe):
    projet = equipe.projet
    membres = equipe.membres

    # 1. Taille d'équipe
    taille_min = projet.taille_equipe.get("min", 0)
    taille_max = projet.taille_equipe.get("max", float("inf"))
    if not (taille_min <= len(membres) <= taille_max):
        print("❌ Échec : Taille d'équipe non respectée.")
        return False

    # 2. Compétences obligatoires
    for comp_id, exigences in projet.competences_obligatoires.items():
        niveau_requis = exigences["niveau"]
        nb_requis = exigences["nombre_personnes"]
        nb_valide = sum(
            1 for membre in membres
            if any(comp.id == comp_id and comp.niveau >= niveau_requis for comp in membre.competences)
        )
        if nb_valide < nb_requis:
            print(f"❌ Échec : Compétence obligatoire ID {comp_id} couverte par {nb_valide}/{nb_requis} membres requis.")
            return False

    # 3. Expérience
    for crit in projet.criteres_experience:
        nb_valide = sum(
            1 for membre in membres
            if membre.experience["annees"] >= crit["annees_min"] and
               membre.experience["projets_realises"] >= crit["projets_min"]
        )
        if nb_valide < crit["nombre_personnes"]:
            print(f"❌ Échec : Critère d'expérience {crit} non respecté (valides : {nb_valide})")
            return False

    # 4. Mobilité
    for membre in membres:
        if not (
            membre.mobilite == projet.mobilite or
            membre.mobilite == "hybride" or
            projet.mobilite == "hybride"
        ):
            print(f"❌ Échec : Mobilité incompatible - Projet : {projet.mobilite}, Membre {membre.id} : {membre.mobilite}")
            return False

    # 5. Budget
    if equipe.budget_total > projet.budget_max:
        print(f"❌ Échec : Budget dépassé ({equipe.budget_total:.2f} € > {projet.budget_max} €)")
        return False

    # ✅ Si tout passe :
    return True
