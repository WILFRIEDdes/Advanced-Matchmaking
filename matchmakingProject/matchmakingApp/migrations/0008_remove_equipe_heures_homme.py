# Generated by Django 5.1.7 on 2025-04-23 21:50

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('matchmakingApp', '0007_alter_projet_mobilite_alter_utilisateur_mobilite'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='equipe',
            name='heures_homme',
        ),
    ]
