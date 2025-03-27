# Utilisation de l'image officielle de Python
FROM python:3.13.2

# Définition du répertoire de travail
WORKDIR /app

# Copier les fichiers du projet dans le conteneur
COPY . /app/

# Installer les dépendances
RUN pip install --no-cache-dir -r matchmakingProject/requirements.txt

# Exposer le port de Django
EXPOSE 8000

# Commande de lancement du serveur Django
CMD ["python", "matchmakingProject/manage.py", "runserver", "127.0.0.1:8000"]