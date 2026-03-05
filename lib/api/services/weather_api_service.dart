import 'package:dio/dio.dart';
import '../models/weather_model.dart';
import 'weather_retrofit_service.dart';

/// Service API utilisant Retrofit (Dio) pour respecter les standards de l'examen.
/// Utilise le client Retrofit généré pour les appels réseau.
class WeatherApiService {
  late final WeatherRetrofitService _retrofitService;

  WeatherApiService() {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    _retrofitService = WeatherRetrofitService(dio);
  }

  /// Récupère la météo pour une ville via Retrofit.
  Future<WeatherModel> getWeather(String cityName, String apiKey) async {
    try {
      final json = await _retrofitService.getWeather(
        cityName,
        apiKey,
        "metric",
        "fr",
      );
      return WeatherModel.fromJson(json);
    } on DioException catch (e) {
      throw Exception("Erreur réseau: ${e.message}");
    }
  }
}
