import os
import requests

def get_weather():
    latitude = os.environ.get('LATITUDE')
    longitude = os.environ.get('LONGITUDE')
    api_key = os.environ.get('API_KEY')

    if not latitude or not longitude:
        print("Latitude ou longitude non spécifiée.")
        return None
    elif not api_key:
        print("Aucune clé API")
        return None

    api_url = f"https://api.openweathermap.org/data/2.5/weather?lat={latitude}&lon={longitude}&appid={api_key}"
    response = requests.get(api_url)
    if response.status_code == 200:
        data = response.json()
        weather = data.get('weather', [])
        main=data.get('main')
        if weather and main:
            description = weather[0].get('description')
            temperature=main.get('temp')
            return description,temperature
        else:
            print("Aucune donnée météorologique disponible.")
            return None
    else:
        print("Erreur lors de la requête à l'API OpenWeather:", response.status_code)
        return None
        
if __name__ == "__main__":
    weather_description = get_weather()
    if weather_description:
        print("Météo:", weather_description)
    else:
        print("Impossible d'obtenir la météo.")
