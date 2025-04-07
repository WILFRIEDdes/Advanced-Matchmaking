from django import forms
from django.contrib.auth.forms import AuthenticationForm

class LoginForm(AuthenticationForm):
    username = forms.CharField(label="Nom d'utilisateur", widget=forms.TextInput(attrs={"class": "w-full py-2 px-3 text-lg border rounded"}))
    password = forms.CharField(label="Mot de passe", widget=forms.PasswordInput(attrs={"class": "w-full py-2 px-3 text-lg border rounded"}))