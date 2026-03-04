import 'package:intl/intl.dart';

class Helpers {
  static String formatTemperature(double temp) {
    return '${temp.toStringAsFixed(1)}°C';
  }

  static String formatHumidity(int humidity) {
    return '$humidity%';
  }

  static String formatWindSpeed(double speed) {
    return '${speed.toStringAsFixed(1)} m/s';
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String getWeatherBackground(String description) {
    if (description.contains('pluie')) {
      return 'rainy';
    } else if (description.contains('nuage')) {
      return 'cloudy';
    } else if (description.contains('soleil') || description.contains('clair')) {
      return 'sunny';
    } else {
      return 'default';
    }
  }
}