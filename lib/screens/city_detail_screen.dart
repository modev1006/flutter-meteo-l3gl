import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../api/models/weather_model.dart';

class CityDetailScreen extends StatefulWidget {
  final WeatherModel? weather;
  const CityDetailScreen({Key? key, this.weather}) : super(key: key);

  @override
  _CityDetailScreenState createState() => _CityDetailScreenState();
}

class _CityDetailScreenState extends State<CityDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final weather = widget.weather ?? ModalRoute.of(context)!.settings.arguments as WeatherModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(weather.cityName, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildWeatherHeader(weather),
            _buildDetailsGrid(weather),
            _buildMapSection(weather),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherHeader(WeatherModel weather) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Text(
            weather.getWeatherIcon(),
            style: const TextStyle(fontSize: 100),
          ),
          const SizedBox(height: 10),
          Text(
            "${weather.temperature.toStringAsFixed(1)}°C",
            style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
          ),
          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(fontSize: 20, color: Colors.grey, letterSpacing: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid(WeatherModel weather) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _detailCard(Icons.water_drop, "Humidité", "${weather.humidity}%"),
          _detailCard(Icons.air, "Vent", "${weather.windSpeed} km/h"),
        ],
      ),
    );
  }

  Widget _detailCard(IconData icon, String label, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 150,
        child: Column(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection(WeatherModel weather) {
    // Sécurité pour le Web car Google Maps Flutter ne supporte pas le web sans configuration JS complexe
    const bool isWeb = bool.fromEnvironment('dart.library.js_util'); 

    return Container(
      height: 300,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: isWeb 
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("Carte disponible sur Android/iOS uniquement", 
                       textAlign: TextAlign.center,
                       style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(weather.latitude, weather.longitude),
                zoom: 12,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(weather.cityName),
                  position: LatLng(weather.latitude, weather.longitude),
                  infoWindow: InfoWindow(title: weather.cityName),
                ),
              },
            ),
      ),
    );
  }
}
