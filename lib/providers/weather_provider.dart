import 'package:flutter/material.dart';
import '../api/models/weather_model.dart';
import '../api/services/weather_api_service.dart';
import '../utils/constants.dart';

enum LoadingState { idle, loading, success, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherApiService _apiService = WeatherApiService();
  
  List<WeatherModel> _weatherData = [];
  LoadingState _state = LoadingState.idle;
  String _errorMessage = '';
  double _progress = 0.0;
  String _loadingMessage = 'Nous téléchargeons les données...';
  WeatherModel? _selectedCity;

  List<WeatherModel> get weatherData => _weatherData;
  LoadingState get state => _state;
  String get errorMessage => _errorMessage;
  double get progress => _progress;
  String get loadingMessage => _loadingMessage;
  WeatherModel? get selectedCity => _selectedCity;

  WeatherProvider();

  void selectCity(WeatherModel city) {
    _selectedCity = city;
    notifyListeners();
  }

  void clearSelection() {
    _selectedCity = null;
    notifyListeners();
  }

  Future<void> loadWeatherData() async {
    _state = LoadingState.loading;
    _weatherData = [];
    _progress = 0.0;
    _errorMessage = '';
    _loadingMessage = 'Démarrage du téléchargement...';
    notifyListeners();

    final cities = Constants.cities;
    final messages = [
      "Initialisation de la connexion...",
      "Récupération de la première ville...",
      "C'est presque fini...",
      "Encore un petit effort...",
      "Plus que quelques secondes avant d'avoir le résultat..."
    ];

    try {
      for (int i = 0; i < cities.length; i++) {
        _loadingMessage = messages[i % messages.length];
        
        final weather = await _apiService.getWeather(
          cities[i],
          Constants.apiKey,
        );
        
        _weatherData.add(weather);
        _progress = (i + 1) / cities.length;
        notifyListeners();

        // Délai de 2 secondes requis par l'examen
        if (i < cities.length - 1) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
      _state = LoadingState.success;
    } catch (e) {
      _state = LoadingState.error;
      _errorMessage = "Erreur lors du chargement : ${e.toString()}";
    }
    notifyListeners();
  }

  void reset() {
    _weatherData = [];
    _state = LoadingState.idle;
    _progress = 0.0;
    notifyListeners();
  }
}
