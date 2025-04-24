from django.core.management.base import BaseCommand
from matchmakingApp.Algo.generator import generate_and_insert_users

class Command(BaseCommand):
    help = "Génère des utilisateurs fictifs et les insère en base"

    def add_arguments(self, parser):
        parser.add_argument('n', type=int, help='Nombre d’utilisateurs à générer')

    def handle(self, *args, **kwargs):
        n = kwargs['n']
        self.stdout.write(f"Génération de {n} utilisateurs...")
        generate_and_insert_users(n)
        self.stdout.write(self.style.SUCCESS(f"{n} utilisateurs générés avec succès !"))