import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/weather_model.dart';
import '../../utils/constants.dart';

/// Service responsable de la communication avec l'API OpenWeatherMap.
/// 
/// Ce service gère les requêtes HTTP, la vérification de la connexion
/// et la conversion des réponses JSON en modèles d'objets Dart.
class ApiService {
  /// URL de base pour les requêtes météo actuelles.
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  /// Vérifie si l'appareil a accès à internet.
  /// 
  /// Retourne [true] si une connexion est détectée, [false] sinon.
  Future<bool> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /// Récupère la météo pour une ville donnée par son nom.
  /// 
  /// [cityName] : Le nom de la ville (ex: "Paris").
  /// 
  /// Lance une [Exception] si la connexion échoue, si la ville n'est pas trouvée
  /// ou si la clé API est invalide.
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
        return WeatherModel.fromJson(jsonData);
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

  /// Récupère la météo pour une liste de plusieurs villes simultanément.
  /// 
  /// [cityNames] : Liste des noms de villes.
  /// 
  /// Retourne une liste de [WeatherModel] une fois que toutes les requêtes sont terminées.
  Future<List<WeatherModel>> fetchMultipleCities(List<String> cityNames) async {
    List<Future<WeatherModel>> futures = [];

    for (String city in cityNames) {
      futures.add(fetchWeather(city));
    }

    return Future.wait(futures);
  }
}