# Generated by Django 5.1.7 on 2025-04-23 21:56

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('matchmakingApp', '0008_remove_equipe_heures_homme'),
    ]

    operations = [
        migrations.AlterField(
            model_name='equipemembre',
            name='equipe',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='matchmakingApp.equipe'),
        ),
    ]
