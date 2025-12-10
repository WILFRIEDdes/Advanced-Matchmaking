# Utilisation de l'image officielle de Python
FROM python:3.13.2

# Définition du répertoire de travail
WORKDIR /app

# Copier le script d'attente Python
COPY wait-for-db.py /usr/local/bin/

# Copier les fichiers du projet dans le conteneur
COPY . /app/

# Installer les dépendances
RUN pip install --no-cache-dir -r matchmakingProject/requirements.txt

# Exposer le port de Django
EXPOSE 8000

# Définir le script d'attente comme point d'entrée (ENTRYPOINT)
ENTRYPOINT ["python", "/usr/local/bin/wait-for-db.py"]

# Commande de lancement du serveur Django
CMD ["python", "matchmakingProject/manage.py", "runserver", "0.0.0.0:8000"]