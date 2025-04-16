#!/bin/bash

# Démarrer Docker Compose en arrière-plan
docker-compose up -d

# Attendre quelques secondes pour que Django démarre
sleep 3  

# Détecter le système d'exploitation et ouvrir le navigateur
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open http://localhost:8000/matchmakingApp  # Linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
    open http://localhost:8000/matchmakingApp  # macOS
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    start http://localhost:8000/matchmakingApp  # Windows (cmd/PowerShell)
else
    echo "Système non supporté. Ouvre manuellement http://localhost:8000/matchmakingApp"
fi
