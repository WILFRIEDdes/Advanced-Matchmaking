from django.shortcuts import render, redirect
from django.contrib.auth import login, authenticate, update_session_auth_hash
from django.contrib.auth.decorators import login_required
from .forms import LoginForm, FirstLoginForm, ProjetForm, CompetenceRequiseForm
from .models import UtilisateurCompetence, Disponibilite, Utilisateur, Projet, ProjetCompetenceRequise, Competence
from .utils.decorators import role_required
import json
from django.core.serializers import serialize

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
                UtilisateurCompetence.objects.create(
                    utilisateur=user,
                    competence=competence,
                    niveau="Débutant"
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
            'competences_json': competences_json
        })

    competences = Competence.objects.all()
    return render(request, 'create_project.html', {'form': form, 'competences': competences})