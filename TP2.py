from flask import Flask, jsonify, request
import os
import requests

app = Flask(__name__)

@app.route('/weather', methods=['GET'])
def get_weather():
    # Récupère la latitude et la longitude depuis la requête HTTP
    latitude = request.args.get('lat')
    longitude = request.args.get('lon')
    api_key = os.environ.get('API_KEY')

    # Vérifie si les paramètres et la clé API sont présents
    if not latitude or not longitude:
        return jsonify({'error': 'Latitude ou longitude non spécifiée.'}), 400
    elif not api_key:
        return jsonify({'error': 'Aucune clé API'}), 400

    # Construit l'URL de l'API OpenWeatherMap et fait une requête
    api_url = f"https://api.openweathermap.org/data/2.5/weather?lat={latitude}&lon={longitude}&appid={api_key}&units=metric"
    response = requests.get(api_url)
    
    # Gère la réponse de l'API OpenWeatherMap
    if response.status_code == 200:
        data = response.json()
        weather = data.get('weather', [])
        main = data.get('main')
        if weather and main:
            # Récupère la description météorologique et la température
            description = weather[0].get('description')
            temperature = main.get('temp')
            # Renvoie les données en tant que JSON
            return jsonify({
                'description': description,
                'temperature': temperature
            })
        else:
            return jsonify({'error': 'Aucune donnée météorologique disponible.'}), 404
    else:
        # Renvoie une erreur si l'API OpenWeatherMap ne répond pas correctement
        return jsonify({'error': 'Erreur lors de la requête à l\'API OpenWeather'}), response.status_code

# Démarre le serveur pour écouter sur le port 8081
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8081)
