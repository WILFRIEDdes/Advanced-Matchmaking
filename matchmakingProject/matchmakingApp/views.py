from django.shortcuts import render, redirect
from django.contrib.auth import login, authenticate, update_session_auth_hash
from django.contrib.auth.decorators import login_required
from .forms import LoginForm, FirstLoginForm
from .models import UtilisateurCompetence, Disponibilite, Utilisateur
from .utils.decorators import role_required

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
def generation_equipe(request):
    # code ici
    return render(request, 'generation_equipe.html')


@login_required
@role_required(['manager'])
def liste_employes(request):
    employes = Utilisateur.objects.filter(role='employe')
    return render(request, 'liste_employes.html', {'employes': employes})


@login_required
@role_required(['manager'])
def liste_projets(request):
    # code ici
    return render(request, 'liste_projets.html')