# Generated by Django 5.1.7 on 2025-04-24 20:01

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('matchmakingApp', '0014_surveyresponse_projet_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='surveyresponse',
            name='projet',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='questionnaires_projet', to='matchmakingApp.projet'),
        ),
    ]
