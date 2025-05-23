# Generated by Django 5.1.7 on 2025-04-24 16:38

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('matchmakingApp', '0011_projet_questionnaire'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='projet',
            name='questionnaire',
        ),
        migrations.CreateModel(
            name='ProjetSurvey',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('projet', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='matchmakingApp.projet')),
                ('questionnaire', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='matchmakingApp.surveyresponse')),
            ],
            options={
                'db_table': 'Projet_Questionnaire',
                'managed': True,
            },
        ),
    ]
