# image Python 
FROM python:3.11-slim

# répertoire de travail dans le conteneur
WORKDIR /app

# Copie des fichiers nécessaires dans le conteneur
COPY . .

# Installation des dépendances Python
RUN pip install --no-cache-dir requests

# Exécution du script Python lorsque le conteneur démarre
CMD ["python", "TP1.py"]
