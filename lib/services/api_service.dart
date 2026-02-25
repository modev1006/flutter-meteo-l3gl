import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/weather_model.dart';
import '../utils/constants.dart';

class ApiService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<bool> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<WeatherModel> fetchWeather(String cityName) async {
    // Vérifier la connexion
    if (!await checkConnectivity()) {
      throw Exception('Pas de connexion internet');
    }

    final url = '$_baseUrl?q=$cityName&appid=${Constants.apiKey}&units=metric&lang=fr';

    try {
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Délai d\'attente dépassé'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return WeatherModel.fromJson(jsonData, cityName);
      } else if (response.statusCode == 401) {
        throw Exception('Clé API invalide');
      } else if (response.statusCode == 404) {
        throw Exception('Ville non trouvée');
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Délai d\'attente dépassé');
    } catch (e) {
      throw Exception('Erreur réseau: $e');
    }
  }

  Future<List<WeatherModel>> fetchMultipleCities(List<String> cityNames) async {
    List<Future<WeatherModel>> futures = [];

    for (String city in cityNames) {
      futures.add(fetchWeather(city));
    }

    return Future.wait(futures);
  }
}