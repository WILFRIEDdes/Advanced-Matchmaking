from django.shortcuts import render, redirect
from django.contrib.auth import login, authenticate, update_session_auth_hash
from django.contrib.auth.decorators import login_required
from .forms import LoginForm, FirstLoginForm

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
    if request.user.a_change_mdp:
        return redirect('index')
    
    if request.method == 'POST':
        form = FirstLoginForm(request.POST)
        if form.is_valid():
            request.user.set_password(form.cleaned_data['new_password'])
            request.user.mobilite = form.cleaned_data['mobilite']
            request.user.a_change_mdp = True
            request.user.save()
            update_session_auth_hash(request, request.user)  # évite la déconnexion
            return redirect('index')
    else:
        form = FirstLoginForm()

    return render(request, 'premiere_connexion.html', {'form': form})