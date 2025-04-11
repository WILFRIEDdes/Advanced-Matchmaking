from django import forms

class LoginForm(forms.Form):
    email = forms.EmailField(label='Adresse mail', widget=forms.TextInput(attrs={"class": "w-full py-2 px-3 text-lg border rounded"}))
    password = forms.CharField(label='Mot de passe', widget=forms.PasswordInput(attrs={"class": "w-full py-2 px-3 text-lg border rounded"}))

class FirstLoginForm(forms.Form):
    new_password = forms.CharField(widget=forms.PasswordInput)
    mobilite = forms.ChoiceField(choices=[('présentiel', 'Présentiel'), ('distanciel', 'Distanciel')])