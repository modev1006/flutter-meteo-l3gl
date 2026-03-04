import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/weather_card.dart';
import '../providers/weather_provider.dart';
import '../routes/app_routes.dart';

class CityListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Météo des villes'),
        elevation: 0,
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.weatherData.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: weatherProvider.weatherData.length,
                  itemBuilder: (context, index) {
                    final weather = weatherProvider.weatherData[index];
                    return WeatherCard(
                      weather: weather,
                      onTap: () {
                        weatherProvider.selectCity(weather);
                        Navigator.pushNamed(context, AppRoutes.cityDetail);
                      },
                    );
                  },
                ),
              ),
              _buildBottomButton(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: const Icon(
              Icons.cloud_off,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Aucune donnée météo disponible',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Provider.of<WeatherProvider>(context, listen: false).reset();
              Navigator.pushReplacementNamed(context, AppRoutes.loading);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Recommencer ✨',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}