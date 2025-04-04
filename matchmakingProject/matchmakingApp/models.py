from django.contrib.auth.models import AbstractUser
from django.db import models

class Utilisateur(AbstractUser):
    ROLE_CHOICES = [
        ('manager', 'Manager'),
        ('employe', 'Employé'),
    ]
    role = models.CharField(max_length=10, choices=ROLE_CHOICES, default='employe')

    groups = models.ManyToManyField(
        "auth.Group",
        related_name="utilisateurs",
        blank=True
    )
    user_permissions = models.ManyToManyField(
        "auth.Permission",
        related_name="utilisateurs",
        blank=True
    )

    def __str__(self):
        return f"{self.username} ({self.role})"
