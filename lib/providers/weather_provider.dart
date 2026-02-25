// import 'package:flutter/material.dart';
// import '../models/weather_model.dart';
// import '../services/api_service.dart';
// import '../services/weather_service.dart';
//
// enum LoadingState { idle, loading, success, error }
//
// class WeatherProvider extends ChangeNotifier {
//   final ApiService _apiService = ApiService();
//   final WeatherService _weatherService = WeatherService();
//
//   List<WeatherModel> _weatherData = [];
//   LoadingState _state = LoadingState.idle;
//   String _errorMessage = '';
//   WeatherModel? _selectedCity;
//
//   List<WeatherModel> get weatherData => _weatherData;
//   LoadingState get state => _state;
//   String get errorMessage => _errorMessage;
//   WeatherModel? get selectedCity => _selectedCity;
//
//   Future<void> loadWeatherData() async {
//     _state = LoadingState.loading;
//     _errorMessage = '';
//     notifyListeners();
//
//     try {
//       final cities = _weatherService.getDefaultCityNames();
//       _weatherData = await _apiService.fetchMultipleCities(cities);
//       await _weatherService.cacheWeatherData(_weatherData);
//       _state = LoadingState.success;
//     } catch (e) {
//       _state = LoadingState.error;
//       _errorMessage = e.toString().replaceAll('Exception: ', '');
//
//       // Essayer de charger les données en cache
//       final cachedData = await _weatherService.getCachedWeather();
//       if (cachedData != null) {
//         _weatherData = cachedData;
//       }
//     }
//     notifyListeners();
//   }
//
//   void selectCity(WeatherModel city) {
//     _selectedCity = city;
//     notifyListeners();
//   }
//
//   void clearSelection() {
//     _selectedCity = null;
//     notifyListeners();
//   }
//
//   void reset() {
//     _weatherData = [];
//     _state = LoadingState.idle;
//     _errorMessage = '';
//     _selectedCity = null;
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/api_service.dart';
import '../services/weather_service.dart';

enum LoadingState { idle, loading, success, error }

class WeatherProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final WeatherService _weatherService = WeatherService();

  List<WeatherModel> _weatherData = [];
  LoadingState _state = LoadingState.idle;
  String _errorMessage = '';
  WeatherModel? _selectedCity;

  List<WeatherModel> get weatherData => _weatherData;
  LoadingState get state => _state;
  String get errorMessage => _errorMessage;
  WeatherModel? get selectedCity => _selectedCity;

  Future<void> loadWeatherData() async {
    _state = LoadingState.loading;
    _errorMessage = '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final cities = _weatherService.getDefaultCityNames();
      _weatherData = await _apiService.fetchMultipleCities(cities);
      await _weatherService.cacheWeatherData(_weatherData);
      _state = LoadingState.success;
    } catch (e) {
      _state = LoadingState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');

      // Essayer de charger les données en cache
      final cachedData = await _weatherService.getCachedWeather();
      if (cachedData != null) {
        _weatherData = cachedData;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void selectCity(WeatherModel city) {
    _selectedCity = city;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void clearSelection() {
    _selectedCity = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void reset() {
    _weatherData = [];
    _state = LoadingState.idle;
    _errorMessage = '';
    _selectedCity = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}