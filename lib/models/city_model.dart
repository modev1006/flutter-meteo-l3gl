class CityModel {
  final String name;
  final String country;
  final double latitude;
  final double longitude;

  const CityModel({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  static const List<CityModel> defaultCities = [
    CityModel(name: 'Paris', country: 'FR', latitude: 48.8566, longitude: 2.3522),
    CityModel(name: 'Londres', country: 'GB', latitude: 51.5074, longitude: -0.1278),
    CityModel(name: 'New York', country: 'US', latitude: 40.7128, longitude: -74.0060),
    CityModel(name: 'Tokyo', country: 'JP', latitude: 35.6762, longitude: 139.6503),
    CityModel(name: 'Sydney', country: 'AU', latitude: -33.8688, longitude: 151.2093),
  ];
}