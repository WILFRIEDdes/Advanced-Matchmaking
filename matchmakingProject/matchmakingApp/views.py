from django.shortcuts import render, redirect
from django.contrib.auth import login, authenticate
from .forms import LoginForm
from .models import Utilisateur

# Create your views here.

def index(request):
    return render(request, 'index.html')

def login_view(request):
    if request.user.is_authenticated:
        return redirect("dashboard")

    if request.method == "POST":
        form = LoginForm(data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)
            
            # Rediriger selon le rôle
            if user.role == "manager":
                return redirect("manager_dashboard")
            else:
                return redirect("employee_dashboard")
    else:
        form = LoginForm()
    
    return render(request, "login.html", {"form": form})