// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_retrofit_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _WeatherRetrofitService implements WeatherRetrofitService {
  _WeatherRetrofitService(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://api.openweathermap.org/data/2.5/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<Map<String, dynamic>> getWeather(
    String cityName,
    String apiKey,
    String units,
    String lang,
  ) async {
    final queryParameters = <String, dynamic>{
      r'q': cityName,
      r'appid': apiKey,
      r'units': units,
      r'lang': lang,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
      Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: <String, dynamic>{},
      )
          .compose(
            _dio.options,
            '/weather',
            queryParameters: queryParameters,
          )
          .copyWith(
            baseUrl: baseUrl ?? _dio.options.baseUrl,
          ),
    );
    final value = _result.data!;
    return value;
  }
}
