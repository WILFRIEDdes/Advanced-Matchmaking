from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import Utilisateur

class UtilisateurAdmin(UserAdmin):
    model = Utilisateur
    list_display = ('mail', 'nom', 'prenom', 'role', 'salaire_horaire', 'is_staff')
    fieldsets = (
        (None, {'fields': ('mail', 'password')}),
        ('Informations personnelles', {'fields': ('nom', 'prenom', 'role', 'salaire_horaire', 'annees_experience', 'projets_realises', 'moyenne_notes', 'historique_notes', 'mobilite', 'score_projet')}),
        ('Permissions', {'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')}),
    )
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('mail', 'nom', 'prenom', 'password1', 'password2', 'role', 'salaire_horaire')}
        ),
    )
    search_fields = ('mail',)
    ordering = ('mail',)

admin.site.register(Utilisateur, UtilisateurAdmin)