from django import forms
from .models import Projet, Competence

class LoginForm(forms.Form):
    email = forms.EmailField(label='Adresse mail', widget=forms.TextInput(attrs={"class": "w-full py-2 px-3 text-lg border rounded"}))
    password = forms.CharField(label='Mot de passe', widget=forms.PasswordInput(attrs={"class": "w-full py-2 px-3 text-lg border rounded"}))


class FirstLoginForm(forms.Form):
    new_password = forms.CharField(
        label="Nouveau mot de passe ",
        widget=forms.PasswordInput(attrs={
            "class": "w-full p-2 border rounded-lg",
            "placeholder": "Entrez un nouveau mot de passe"
        })
    )
    confirm_password = forms.CharField(
        label="Confirmer le mot de passe ",
        widget=forms.PasswordInput(attrs={
            "class": "w-full p-2 border rounded-lg",
            "placeholder": "Confirmez votre mot de passe"
        })
    )
    
    mobilite = forms.ChoiceField(
        label="Mobilité ",
        choices=[
            ('présentiel', 'Présentiel'),
            ('distanciel', 'Distanciel'),
            ('mixte', 'Mixte')
        ],
        widget=forms.Select(attrs={
            "class": "w-full p-2 border rounded-lg cursor-pointer"
        })
    )

    competences = forms.ModelMultipleChoiceField(
        label="Compétences ",
        queryset=Competence.objects.all(),
        widget=forms.CheckboxSelectMultiple(attrs={
            "class": "grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-2"
        }),
        required=False
    )

    disponibilites = forms.MultipleChoiceField(
        label="Disponibilités ",
        choices=[
            ('lundi', 'Lundi'),
            ('mardi', 'Mardi'),
            ('mercredi', 'Mercredi'),
            ('jeudi', 'Jeudi'),
            ('vendredi', 'Vendredi')
        ],
        widget=forms.CheckboxSelectMultiple(attrs={
            "class": "grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-2"
        }),
        required=False,
    )

    def clean(self):
        cleaned_data = super().clean()
        password = cleaned_data.get("new_password")
        confirm = cleaned_data.get("confirm_password")
        if password and confirm and password != confirm:
            self.add_error('confirm_password', "Les mots de passe ne correspondent pas.")

            
class ProjetForm(forms.ModelForm):
    class Meta:
        model = Projet
        fields = ['nom', 'description', 'date_debut', 'date_fin']
        widgets = {
            'date_debut': forms.DateInput(attrs={'type': 'date'}),
            'date_fin': forms.DateInput(attrs={'type': 'date'}),
        }

class CompetenceRequiseForm(forms.Form):
    competence = forms.ModelChoiceField(queryset=Competence.objects.all(), label='Compétence')
    niveau_requis = forms.CharField(max_length=13, label='Niveau requis')