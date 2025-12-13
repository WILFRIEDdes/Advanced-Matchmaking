# wait-for-db.py
import socket
import sys
import time
import subprocess
import os

HOST = os.environ.get('DATABASE_HOST')
PORT = 3306
TIMEOUT = 30 # Temps maximum d'attente en secondes

print(f"Waiting for {HOST}:{PORT} to be ready...")

start_time = time.time()
while True:
    try:
        sock = socket.create_connection((HOST, PORT), timeout=1)
        sock.close()
        print(f"{HOST}:{PORT} is ready. Starting web application...")
        break # Succès
    except socket.error as e:
        if time.time() - start_time > TIMEOUT:
            print(f"Timeout reached. Could not connect to {HOST}:{PORT}")
            sys.exit(1) # Échec du démarrage
        print(f"DB not available yet ({e}). Waiting 1 second...")
        time.sleep(1)

# Exécute la commande passée en argument (la CMD du Dockerfile)
subprocess.run(sys.argv[1:])