/// Modèle représentant les données météo d'une ville.
class WeatherModel {
  /// Nom de la ville.
  final String cityName;
  
  /// Température actuelle en degrés Celsius.
  final double temperature;
  
  /// Description textuelle du temps (ex: "ciel dégagé").
  final String description;
  
  /// Taux d'humidité en pourcentage.
  final int humidity;
  
  /// Vitesse du vent en m/s.
  final double windSpeed;
  
  /// Coordonnée latitude de la ville.
  final double latitude;
  
  /// Coordonnée longitude de la ville.
  final double longitude;
  
  /// Code de l'icône météo fourni par l'API (ex: "01d").
  final String iconCode;
  
  /// Date et heure de la dernière mise à jour des données.
  final DateTime lastUpdated;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.latitude,
    required this.longitude,
    required this.iconCode,
    required this.lastUpdated,
  });

  /// Construit une instance de [WeatherModel] à partir d'un objet JSON.
  /// 
  /// [json] : Les données brutes de l'API.
  /// [cityName] : Le nom de la ville associée.
  factory WeatherModel.fromJson(Map<String, dynamic> json, String cityName) {
    return WeatherModel(
      cityName: cityName,
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      latitude: json['coord']['lat'].toDouble(),
      longitude: json['coord']['lon'].toDouble(),
      iconCode: json['weather'][0]['icon'],
      lastUpdated: DateTime.now(),
    );
  }

  /// Convertit l'instance actuelle en un objet JSON (pour le stockage local).
  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'description': description,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'latitude': latitude,
      'longitude': longitude,
      'iconCode': iconCode,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Retourne un emoji correspondant au code de l'icône météo.
  /// 
  /// Utile pour l'affichage textuel ou simplifié.
  String getWeatherIcon() {
    switch (iconCode.substring(0, 2)) {
      case '01':
        return '☀️';
      case '02':
        return '⛅';
      case '03':
      case '04':
        return '☁️';
      case '09':
      case '10':
        return '🌧️';
      case '11':
        return '⛈️';
      case '13':
        return '❄️';
      case '50':
        return '🌫️';
      default:
        return '☀️';
    }
  }
}