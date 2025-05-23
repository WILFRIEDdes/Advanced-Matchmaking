# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin, BaseUserManager


class UtilisateurManager(BaseUserManager):
    def create_user(self, mail, nom, prenom, password=None, **extra_fields):
        if not mail:
            raise ValueError("L'adresse mail est obligatoire")
        mail = self.normalize_email(mail)
        user = self.model(mail=mail, nom=nom, prenom=prenom, **extra_fields)
        user.set_password(password)  # hash le mot de passe
        user.save(using=self._db)
        return user

    def create_superuser(self, mail, nom, prenom, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('role', 'admin')

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Un superutilisateur doit avoir is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Un superutilisateur doit avoir is_superuser=True.')
        

        return self.create_user(mail, nom, prenom, password, **extra_fields)

class Utilisateur(AbstractBaseUser, PermissionsMixin):
    id = models.AutoField(primary_key=True)
    nom = models.CharField(max_length=255)
    prenom = models.CharField(max_length=255)
    mail = models.EmailField(unique=True)
    role = models.CharField(max_length=10, choices=[('employe', 'Employé'), ('manager', 'Manager')], default='employe')
    annees_experience = models.IntegerField(default=0)
    projets_realises = models.IntegerField(default=0)
    salaire_horaire = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    moyenne_notes = models.DecimalField(max_digits=3, decimal_places=2, blank=True, null=True)
    historique_notes = models.JSONField(blank=True, null=True)
    mobilite = models.CharField(max_length=20, choices=[('presentiel', 'Presentiel'), ('distanciel', 'Distanciel'), ('mixte', 'Mixte')], blank=True, null=True)
    score_projet = models.IntegerField(blank=True, null=True)

    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    USERNAME_FIELD = 'mail'
    REQUIRED_FIELDS = ['nom', 'prenom']

    objects = UtilisateurManager()

    class Meta:
        managed = True
        db_table = 'Utilisateur'


class Disponibilite(models.Model):
    id = models.AutoField(primary_key=True)
    utilisateur = models.ForeignKey('Utilisateur', on_delete=models.CASCADE)
    jour = models.CharField(max_length=8)
    heure_debut = models.TimeField(blank=True, null=True)
    heure_fin = models.TimeField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'Disponibilite'
        unique_together = ('utilisateur', 'jour', 'heure_debut', 'heure_fin')


class Competence(models.Model):
    nom = models.CharField(unique=True, max_length=100)

    def __str__(self):
        return self.nom

    class Meta:
        managed = True
        db_table = 'Competence'


class UtilisateurCompetence(models.Model):
    niveaux = [
        ('Débutant', 'Débutant'),
        ('Novice', 'Novice'),
        ('Intermédiaire', 'Intermédiaire'),
        ('Avancé', 'Avancé'),
        ('Expert', 'Expert'),
    ]

    id = models.AutoField(primary_key=True)
    utilisateur = models.ForeignKey(Utilisateur, on_delete=models.CASCADE)
    competence = models.ForeignKey(Competence, on_delete=models.CASCADE)
    niveau = models.CharField(max_length=50, choices=niveaux, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'Utilisateur_Competence'
        unique_together = (('utilisateur', 'competence'),)


class Projet(models.Model):
    nom = models.CharField(max_length=255)
    description = models.TextField(blank=True, null=True)
    date_debut = models.DateField()
    date_fin = models.DateField()
    taille_equipe_min = models.IntegerField(blank=True, null=True)
    taille_equipe_max = models.IntegerField(blank=True, null=True)
    budget = models.DecimalField(max_digits=15, decimal_places=2, blank=True, null=True)
    mobilite = models.CharField(max_length=20, choices=[('presentiel', 'Presentiel'), ('distanciel', 'Distanciel'), ('mixte', 'Mixte')], blank=True, null=True)
    equipe = models.OneToOneField('Equipe', on_delete=models.SET_NULL, null=True, blank=True)
    

    def __str__(self):
        return self.nom

    class Meta:
        managed = True
        db_table = 'Projet'


class ProjetExperienceRequise(models.Model):
    projet = models.ForeignKey('Projet', on_delete=models.CASCADE)
    annees_experience = models.IntegerField(blank=True, null=True)
    projets_realises = models.IntegerField(blank=True, null=True)
    nombre_personnes = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'Projet_ExperienceRequise'
        unique_together = (('projet', 'annees_experience', 'projets_realises', 'nombre_personnes'),)


class ProjetCompetenceRequise(models.Model):
    projet = models.ForeignKey('Projet', on_delete=models.CASCADE)
    competence = models.ForeignKey('Competence', on_delete=models.CASCADE)
    niveau_requis = models.CharField(max_length=13, blank=True, null=True)
    nombre_personnes = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'Projet_CompetenceRequise'
        unique_together = (('projet', 'competence'),)


class ProjetCompetenceBonus(models.Model):
    projet = models.ForeignKey('Projet', on_delete=models.CASCADE)
    competence = models.ForeignKey(Competence, on_delete=models.CASCADE)
    niveau_requis = models.CharField(max_length=13, blank=True, null=True)
    nombre_personnes = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'Projet_CompetenceBonus'
        unique_together = (('projet', 'competence'),)


class ProjetHoraires(models.Model):
    id = models.AutoField(primary_key=True)
    projet = models.ForeignKey('Projet', on_delete=models.CASCADE)
    jour = models.CharField(max_length=8)
    heure_debut = models.TimeField(blank=True, null=True)
    heure_fin = models.TimeField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'Projet_Horaires'
        unique_together = (('projet', 'jour', 'heure_debut', 'heure_fin'),)


class SurveyResponse(models.Model):
    id = models.AutoField(primary_key=True)
    q1 = models.IntegerField(choices=[(i, i) for i in range(1, 6)])
    q2 = models.IntegerField(choices=[(i, i) for i in range(1, 6)])
    q3 = models.IntegerField(choices=[(i, i) for i in range(1, 6)])
    q4 = models.IntegerField(choices=[(i, i) for i in range(1, 6)])
    q5 = models.IntegerField(choices=[(i, i) for i in range(1, 6)])
    submitted_at = models.DateTimeField(auto_now_add=True)
    utilisateur = models.ForeignKey('Utilisateur', on_delete=models.CASCADE, related_name='questionnaires_utilisateur', null=True, blank=True)
    projet = models.ForeignKey('Projet', on_delete=models.CASCADE, related_name='questionnaires_projet', null=True, blank=True)
    
    class Meta:
        managed = True
        db_table = 'Questionnaire'


class Equipe(models.Model):
    id = models.AutoField(primary_key=True)
    taille = models.IntegerField(blank=True, null=True)
    budget_total = models.DecimalField(max_digits=15, decimal_places=2, blank=True, null=True)
    score_global = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'Equipe'


class EquipeMembre(models.Model):
    id = models.AutoField(primary_key=True)
    equipe = models.ForeignKey(Equipe, on_delete=models.CASCADE)
    utilisateur = models.ForeignKey('Utilisateur', on_delete=models.CASCADE)

    class Meta:
        managed = True
        db_table = 'Equipe_Membre'
        unique_together = (('equipe', 'utilisateur'),)


class MobiliteEquipe(models.Model):
    id = models.AutoField(primary_key=True)
    equipe = models.OneToOneField(Equipe, on_delete=models.CASCADE)
    presentiel = models.IntegerField(blank=True, null=True)
    distanciel = models.IntegerField(blank=True, null=True)
    hybride = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'Mobilite_Equipe'


class PreferenceUtilisateur(models.Model):
    id = models.AutoField(primary_key=True)
    utilisateur = models.OneToOneField('Utilisateur', on_delete=models.CASCADE)
    cible = models.ForeignKey('Utilisateur', on_delete=models.CASCADE, related_name='preferenceutilisateur_cible_set')
    preference = models.CharField(max_length=8, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'Preference_Utilisateur'
        unique_together = (('utilisateur', 'cible'),)


class PreferenceCompetence(models.Model):
    id = models.AutoField(primary_key=True)
    utilisateur = models.OneToOneField('Utilisateur', on_delete=models.CASCADE)
    competence = models.ForeignKey(Competence, on_delete=models.CASCADE)
    preference = models.CharField(max_length=8, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'Preference_Competence'
        unique_together = (('utilisateur', 'competence'),)
