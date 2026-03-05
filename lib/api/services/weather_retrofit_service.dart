import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/weather_model.dart';

part 'weather_retrofit_service.g.dart';

/// Client API Retrofit pour l'accès aux données météo OpenWeatherMap.
/// Conforme aux spécifications de l'examen L3GL ISI 2026.
@RestApi(baseUrl: "https://api.openweathermap.org/data/2.5/")
abstract class WeatherRetrofitService {
  factory WeatherRetrofitService(Dio dio, {String baseUrl}) = _WeatherRetrofitService;

  @GET("/weather")
  Future<Map<String, dynamic>> getWeather(
    @Query("q") String cityName,
    @Query("appid") String apiKey,
    @Query("units") String units,
    @Query("lang") String lang,
  );
}
