import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/models/weather_model.dart';
import '../api/models/city_model.dart';

class WeatherService {
  static const String _cacheKey = 'cached_weather';

  Future<void> cacheWeatherData(List<WeatherModel> weatherData) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList =
    weatherData.map((weather) => weather.toJson()).toList();
    await prefs.setString(_cacheKey, json.encode(jsonList));
  }

  Future<List<WeatherModel>?> getCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cachedData = prefs.getString(_cacheKey);

    if (cachedData != null) {
      final List<dynamic> jsonList = json.decode(cachedData);
      return jsonList.map((json) => WeatherModel.fromJson(json)).toList();
    }
    return null;
  }

  List<String> getDefaultCityNames() {
    return CityModel.defaultCities.map((city) => city.name).toList();
  }
}