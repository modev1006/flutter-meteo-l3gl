class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final double latitude;
  final double longitude;
  final String iconCode;
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

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? json['cityName'] ?? '',
      temperature: (json['main'] != null ? json['main']['temp'] : json['temperature'] as num).toDouble(),
      description: json['weather'] != null ? json['weather'][0]['description'] : json['description'],
      humidity: json['main'] != null ? json['main']['humidity'] : json['humidity'],
      windSpeed: (json['wind'] != null ? json['wind']['speed'] : json['windSpeed'] as num).toDouble(),
      latitude: (json['coord'] != null ? json['coord']['lat'] : json['latitude'] as num).toDouble(),
      longitude: (json['coord'] != null ? json['coord']['lon'] : json['longitude'] as num).toDouble(),
      iconCode: json['weather'] != null ? json['weather'][0]['icon'] : json['iconCode'],
      lastUpdated: json['lastUpdated'] != null ? DateTime.parse(json['lastUpdated']) : DateTime.now(),
    );
  }

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

  String getWeatherIcon() {
    switch (iconCode.substring(0, 2)) {
      case '01': return '☀️';
      case '02': return '⛅';
      case '03':
      case '04': return '☁️';
      case '09':
      case '10': return '🌧️';
      case '11': return '⛈️';
      case '13': return '❄️';
      case '50': return '🌫️';
      default: return '☀️';
    }
  }
}
