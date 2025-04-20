from django.shortcuts import render, redirect
from django.contrib.auth import login, authenticate, update_session_auth_hash
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .forms import LoginForm, FirstLoginForm, ProjetForm, ProfilForm, UtilisateurCompetenceFormSet
from .models import UtilisateurCompetence, Disponibilite, Utilisateur, Projet, ProjetCompetenceRequise, Competence
from .utils.decorators import role_required
import json

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
def team_generation(request):
    # code ici
    return render(request, 'team_generation.html')


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

            total = int(request.POST.get('total_competences', 0))
            for i in range(1, total + 1):
                comp_id = request.POST.get(f'competence_{i}')
                niveau = request.POST.get(f'niveau_{i}')
                if comp_id and niveau:
                    ProjetCompetenceRequise.objects.create(
                        projet=projet,
                        competence_id=comp_id,
                        niveau_requis=niveau
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