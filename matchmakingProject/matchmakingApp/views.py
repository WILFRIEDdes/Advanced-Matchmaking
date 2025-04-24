from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import login, authenticate, update_session_auth_hash
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .forms import LoginForm, FirstLoginForm, ProjetForm, ProfilForm, UtilisateurCompetenceFormSet
from .models import (
    UtilisateurCompetence, 
    Disponibilite, 
    Utilisateur, 
    Projet, 
    ProjetCompetenceRequise, 
    ProjetCompetenceBonus, 
    ProjetExperienceRequise, 
    ProjetHoraires, 
    Competence, 
    Equipe, 
    EquipeMembre
)
from .utils.decorators import role_required
from datetime import date, time
import json
import sys
import os

from .Algo.main import pipeline_creation_equipe, pipeline_ajustement_coefficients
from .Algo.classes import Projet as AlgoProjet

# Create your views here.

def index(request):
    return render(request, 'index.html')


def login_view(request):
    form = LoginForm(request.POST or None)
    error = None

    if request.method == 'POST' and form.is_valid():
        email = form.cleaned_data['email']
        password = form.cleaned_data['password']
        user = authenticate(request, mail=email, password=password)
        if user:
            if user.last_login is None:
                login(request, user)
                return redirect('first_login')
            login(request, user)
            return redirect('index')
        else:
            error = "Email ou mot de passe incorrect."

    return render(request, 'login.html', {'form': form, 'error': error})

@login_required
def first_login(request):
    if request.method == 'POST':
        form = FirstLoginForm(request.POST)
        if form.is_valid():
            user = request.user
            user.set_password(form.cleaned_data['new_password'])
            user.mobilite = form.cleaned_data['mobilite']
            user.save()
            update_session_auth_hash(request, user)

            competences = form.cleaned_data['competences']
            for competence in competences:
                niveau = request.POST.get(f'niveau_{competence.id}', 'Débutant')
                UtilisateurCompetence.objects.create(
                    utilisateur=user,
                    competence=competence,
                    niveau=niveau
                )

            jours = request.POST.getlist("jour")
            heures_debut = request.POST.getlist("heure_debut")
            heures_fin = request.POST.getlist("heure_fin")

            for jour, debut, fin in zip(jours, heures_debut, heures_fin):
                if jour and debut and fin:
                    Disponibilite.objects.create(
                        utilisateur=user,
                        jour=jour,
                        heure_debut=debut,
                        heure_fin=fin
                    )

            return redirect('index')
    else:
        form = FirstLoginForm()

    return render(request, 'first_login.html', {'form': form})


def unauthorized(request):
    return render(request, 'unauthorized.html')


@login_required
@role_required(['manager'])
def team_generation(request, projet_id):
    projetinfos = get_object_or_404(Projet, pk=projet_id)

    niveau_mapping = {
        "Débutant": 1,
        "Novice": 2,
        "Intermédiaire": 3,
        "Avancé": 4,
        "Expert": 5
    }

    if request.method == "POST":
        id = projet_id
        nom = projetinfos.nom
        description = projetinfos.description
        date_debut = projetinfos.date_debut
        date_fin = projetinfos.date_fin
        budget_max = projetinfos.budget
        mobilite = projetinfos.mobilite
        taille_equipe_min = projetinfos.taille_equipe_min
        taille_equipe_max = projetinfos.taille_equipe_max
        competences_requises_query = ProjetCompetenceRequise.objects.filter(projet=projetinfos)
        competences_bonus_query = ProjetCompetenceBonus.objects.filter(projet=projetinfos)
        experience_query = ProjetExperienceRequise.objects.filter(projet=projetinfos)
        horaires_query = ProjetHoraires.objects.filter(projet=projetinfos)
        
        horaires = {
            h.jour.lower(): {"debut": h.heure_debut.hour, "fin": h.heure_fin.hour}
            for h in horaires_query
        }   

        competences_requises = {
            c.competence.id: {
                "niveau": niveau_mapping.get(c.niveau_requis, 1),
                "nombre_personnes": c.nombre_personnes
            }
            for c in competences_requises_query
        }

        competences_bonus = {
            c.competence.id: {
                "niveau": niveau_mapping.get(c.niveau_requis, 1),
                "nombre_personnes": c.nombre_personnes
            }
            for c in competences_bonus_query
        }

        experience = [
            {
                "annees_min": e.annees_experience,
                "projets_min": e.projets_realises,
                "nombre_personnes": e.nombre_personnes
            }
            for e in experience_query
        ]

        taille_equipe = {
            "min": taille_equipe_min,
            "max": taille_equipe_max
        }

        if not isinstance(date_debut, date):
            date_debut = date.fromisoformat(date_debut)

        if not isinstance(date_fin, date):
            date_fin = date.fromisoformat(date_fin)

        # Création de l'objet Projet
        projet = AlgoProjet(
            id=id,
            nom=nom,
            date_debut=date_debut,
            date_fin=date_fin,
            horaires=horaires,
            competences_obligatoires=competences_requises,
            competences_bonus=competences_bonus,
            taille_equipe=taille_equipe,
            criteres_experience=experience,
            budget_max=budget_max,
            mobilite=mobilite
        )

        if projet:
            meilleure_equipe = pipeline_creation_equipe(projet)

            if meilleure_equipe is None:
                messages.error(request, "Aucune équipe optimale n’a pu être générée pour ce projet. Veuillez vérifier les contraintes ou les ressources disponibles.")
                return redirect("list_projects")
            
            noms_membres = [
                f"{Utilisateur.objects.get(pk=membre.id).prenom} {Utilisateur.objects.get(pk=membre.id).nom}"
                for membre in meilleure_equipe.membres
            ]

            # -------------- Sauvegarde de l'équipe optimisée dans la base de données --------------

            # Créer et sauvegarder l'équipe
            nouvelle_equipe = Equipe.objects.create(
                taille=len(meilleure_equipe.membres),
                budget_total=meilleure_equipe.budget_total,
                score_global=meilleure_equipe.score_global
            )

            # Créer les membres de l'équipe
            for membre in meilleure_equipe.membres:
                EquipeMembre.objects.create(
                    equipe=nouvelle_equipe,
                    utilisateur_id=membre.id
                )

            projetinfos.equipe = nouvelle_equipe
            projetinfos.save()
                
            messages.success(request, f"Équipe générée avec succès : {', '.join(noms_membres)} pour projet '{projet.nom}'")
        else:
            messages.error(request, "Impossible de générer une équipe. Vérifiez les données.")
        return redirect("list_projects")

    return render(request, 'team_generation.html', {
        'projet': projet,
        'competences_requises': competences_requises,
        'competences_bonus': competences_bonus,
        'experience': experience,
        'horaires': horaires,
        "taille_equipe": taille_equipe,
    })


@login_required
@role_required(['manager'])
def list_employees(request):
    employes = Utilisateur.objects.filter(role='employe')
    return render(request, 'list_employees.html', {'employes': employes})


@login_required
@role_required(['manager'])
def list_projects(request):
    projets = Projet.objects.select_related('equipe').all()
    return render(request, 'list_projects.html', {'projets': projets})


@login_required
@role_required(['manager'])
def create_project(request):
    if request.method == 'POST':
        form = ProjetForm(request.POST)
        if form.is_valid():
            projet = form.save()

            budget_max = request.POST.get('budget_max')
            taille_equipe_min = request.POST.get('taille_equipe_min')
            taille_equipe_max = request.POST.get('taille_equipe_max')
            mobilite = request.POST.get('mobilite')

            if budget_max:
                projet.budget = budget_max
            if taille_equipe_min:
                projet.taille_equipe_min = taille_equipe_min
            if taille_equipe_max:
                projet.taille_equipe_max = taille_equipe_max
            if mobilite:
                projet.mobilite = mobilite

            projet.save()


            # Compétences requises
            competence_ids_req = request.POST.getlist("competence_req_id")
            niveaux_req = request.POST.getlist("competence_req_niveau")
            nb_personnes_req = request.POST.getlist("compet_req_nb_personnes")

            for i in range(len(competence_ids_req)):
                comp_id = competence_ids_req[i]
                niveau = niveaux_req[i] if i < len(niveaux_req) else None
                nb_pers = nb_personnes_req[i] if i < len(nb_personnes_req) else None

                if comp_id and niveau:
                    ProjetCompetenceRequise.objects.create(
                        projet=projet,
                        competence_id=comp_id,
                        niveau_requis=niveau,
                        nombre_personnes=nb_pers if nb_pers else None
                    )

            # Compétences bonus
            competence_ids_bon = request.POST.getlist("competence_bon_id")
            niveaux_bon = request.POST.getlist("competence_bon_niveau")
            nb_personnes_bon = request.POST.getlist("compet_bon_nb_personnes")

            for i in range(len(competence_ids_bon)):
                comp_id = competence_ids_bon[i]
                niveau = niveaux_bon[i] if i < len(niveaux_bon) else None
                nb_pers = nb_personnes_bon[i] if i < len(nb_personnes_bon) else None

                if comp_id and niveau:
                    ProjetCompetenceBonus.objects.create(
                        projet=projet,
                        competence_id=comp_id,
                        niveau_requis=niveau,
                        nombre_personnes=nb_pers if nb_pers else None
                    )

            # Expériences requises
            total_exp = int(request.POST.get('total_experience', 0))
            for i in range(1, total_exp + 1):
                annees = request.POST.get(f'annees_experience_{i}')
                projets_real = request.POST.get(f'projets_realises_{i}')
                nb_pers = request.POST.get(f'nombre_personnes_exp_{i}')
                if annees and projets_real and nb_pers:
                    ProjetExperienceRequise.objects.create(
                        projet=projet,
                        annees_experience=int(annees),
                        projets_realises=int(projets_real),
                        nombre_personnes=int(nb_pers)
                    )

            # Horaires
            jours = request.POST.getlist('jour')
            heures_debut = request.POST.getlist('heure_debut')
            heures_fin = request.POST.getlist('heure_fin')

            for i in range(len(jours)):
                jour = jours[i]
                debut = heures_debut[i] if i < len(heures_debut) else None
                fin = heures_fin[i] if i < len(heures_fin) else None

                if jour and debut and fin:
                    ProjetHoraires.objects.create(
                        projet=projet,
                        jour=jour.lower(),  # ou .capitalize() selon comment tu stockes ça dans le modèle
                        heure_debut=time.fromisoformat(debut),
                        heure_fin=time.fromisoformat(fin)
                    )

            return redirect('list_projects')
    else:
        form = ProjetForm()
        competences = Competence.objects.all()
        competences_json = json.dumps([
            {'id': c.id, 'nom': c.nom} for c in competences
        ])
        return render(request, 'create_project.html', {
            'form': form,
            "niveaux_competence": UtilisateurCompetence.niveaux,
            'competences_json': competences_json,
            "competences": competences
        })

    competences = Competence.objects.all()
    return render(request, 'create_project.html', {
        'form': form, 
        'competences': competences,
        "niveaux_competence": UtilisateurCompetence.niveaux,
        'competences_json': competences_json,
    })


@login_required
def calendar(request):
    # code ici
    return render(request, 'calendar.html')


@login_required
def profile(request):
    user = request.user

    if request.method == 'POST':
        profil_form = ProfilForm(request.POST, instance=user)

        # Récupération manuelle des compétences
        competence_ids = request.POST.getlist('competence_id')
        competence_niveaux = request.POST.getlist('competence_niveau')

        # Validation manuelle
        valid = True
        
        for cid, niveau in zip(competence_ids, competence_niveaux):
            if not cid or not niveau:
                valid = False
                messages.error(request, "Veuillez remplir toutes les compétences.")
                break
            if not Competence.objects.filter(id=cid).exists():
                valid = False
                messages.error(request, "Une compétence sélectionnée est invalide.")
                break
            if niveau not in dict(UtilisateurCompetence.niveaux):
                valid = False
                messages.error(request, "Niveau de compétence invalide.")
                break


        if profil_form.is_valid() and valid:
            profil_form.save()

            # Supprimer les anciennes compétences
            UtilisateurCompetence.objects.filter(utilisateur=user).delete()

            # Créer les nouvelles compétences
            for cid, niveau in zip(competence_ids, competence_niveaux):
                comp = Competence.objects.get(id=cid)
                UtilisateurCompetence.objects.create(utilisateur=user, competence=comp, niveau=niveau)

            # 🔹 Suppression des anciennes disponibilités
            Disponibilite.objects.filter(utilisateur=user).delete()

            # 🔹 Ajout des nouvelles disponibilités
            jours = request.POST.getlist('jour')
            heures_debut = request.POST.getlist('heure_debut')
            heures_fin = request.POST.getlist('heure_fin')

            for jour, debut, fin in zip(jours, heures_debut, heures_fin):
                if jour and debut and fin:
                    Disponibilite.objects.create(
                        utilisateur=user,
                        jour=jour,
                        heure_debut=debut,
                        heure_fin=fin
                    )

            messages.success(request, "Profil mis à jour avec succès.")

            return redirect('profile')

        jours_selectionnes = request.POST.getlist('jours[]')

    else:
        profil_form = ProfilForm(instance=user)
        jours_selectionnes = Disponibilite.objects.filter(utilisateur=user).values_list('jour', flat=True)
        competences = Competence.objects.all()
        competences_json = json.dumps([
            {'id': c.id, 'nom': c.nom} for c in competences
        ])
        
    # Construction du dictionnaire {comp_id: niveau} pour l'affichage dans le template
    competence_niveaux_dict = {
        uc.competence.id: uc.niveau
        for uc in UtilisateurCompetence.objects.filter(utilisateur=user)
    }

    return render(request, "profile.html", {
        "form": profil_form,
        'jours_selectionnes': jours_selectionnes,
        "niveaux_competence": UtilisateurCompetence.niveaux,
        "competences": Competence.objects.all(),
        "competence_niveaux": competence_niveaux_dict,
        "competences_json": competences_json,
    })



@login_required
def change_password(request):
    if request.method == "POST":
        old_password = request.POST.get("old_password")
        new_password = request.POST.get("new_password")
        confirm_password = request.POST.get("confirm_password")

        user = request.user

        if not user.check_password(old_password):
            messages.error(request, "Ancien mot de passe incorrect.")
            return redirect("profile")

        if new_password != confirm_password:
            messages.error(request, "Les mots de passe ne correspondent pas.")
            return redirect("profile")

        user.set_password(new_password)
        user.save()
        update_session_auth_hash(request, user)
        messages.success(request, "Mot de passe mis à jour avec succès.")
        return redirect("profile")

# import 

@login_required
def test(request):
    return render(request, 'test.html')

@login_required
def demander_equipe(request):
    if request.method == "POST":
        # Exemple de données pour le projet et les utilisateurs
        horaires = {
            "lundi": {"debut": 9, "fin": 17},
            "mardi": {"debut": 9, "fin": 17},
            "mercredi": {"debut": 9, "fin": 17},
            "jeudi": {"debut": 9, "fin": 17},
            "vendredi": {"debut": 9, "fin": 17}
        }

        competences_obligatoires = {
            1: {"niveau": 3, "nombre_personnes": 2},
            2: {"niveau": 2, "nombre_personnes": 1}
        }

        competences_bonus = {
            3: {"niveau": 1, "nombre_personnes": 1},
            4: {"niveau": 2, "nombre_personnes": 1}
        }

        taille_equipe = {"min": 3, "max": 5}

        criteres_experience = [
            {"annees_min": 2, "projets_min": 3, "nombre_personnes": 2},
            {"annees_min": 5, "projets_min": 5, "nombre_personnes": 1}
        ]

        # Création de l'objet Projet
        projet = AlgoProjet(
            id=101,
            nom="Développement Plateforme Matchmaking",
            date_debut=date(2025, 4, 15),
            date_fin=date(2025, 7, 15),
            horaires=horaires,
            competences_obligatoires=competences_obligatoires,
            competences_bonus=competences_bonus,
            taille_equipe=taille_equipe,
            criteres_experience=criteres_experience,
            budget_max=18000,
            mobilite="distanciel"
        )

        if projet:
            meilleure_equipe = pipeline_creation_equipe(projet)
            messages.success(request, f"Équipe générée avec succès : {[membre.id for membre in meilleure_equipe.membres]}")
        else:
            messages.error(request, "Impossible de générer une équipe. Vérifiez les données.")
        return redirect("test")

@login_required
def ajuster_coefficients(request):
    if request.method == "POST":
        # Exemple de feedbacks simulés
        feedbacks = [
            {"utilisateur_id": 1, "reponses": {"q1": 4, "q2": 5, "q3": 3, "q4": 4, "q5": 5}, "poids": 1.5},
            {"utilisateur_id": 2, "reponses": {"q1": 3, "q2": 4, "q3": 4, "q4": 3, "q5": 4}, "poids": 1.2},
        ]
        projet_id = 1  # Exemple d'ID de projet
        nouveaux_coeffs = pipeline_ajustement_coefficients(feedbacks, projet_id)
        messages.success(request, f"Coefficients ajustés avec succès : {nouveaux_coeffs}")
        return redirect("test")