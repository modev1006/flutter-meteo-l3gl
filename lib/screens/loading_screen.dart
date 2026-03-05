import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../providers/weather_provider.dart';
import '../providers/theme_provider.dart';
import '../routes/app_routes.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Lancer le chargement au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().loadWeatherData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.state == LoadingState.success) {
            return _buildSuccessWidget(context, provider);
          }
          
          if (provider.state == LoadingState.error) {
            return _buildErrorWidget(context, provider);
          }

          return _buildLoadingWidget(context, provider);
        },
      ),
    );
  }

  Widget _buildLoadingWidget(BuildContext context, WeatherProvider provider) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.surface,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 120.0,
            lineWidth: 15.0,
            percent: provider.progress,
            center: Text(
              "${(provider.progress * 100).toInt()}%",
              style: TextStyle(
                fontSize: 40,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            progressColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animateFromLastPercent: true,
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                provider.loadingMessage,
                key: ValueKey(provider.loadingMessage),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessWidget(BuildContext context, WeatherProvider provider) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Météo Pro"),
        actions: [
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.dark 
              ? Icons.light_mode 
              : Icons.dark_mode),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 10),
            Text(
              "BOOM 💥 ! Données prêtes",
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: provider.weatherData.length,
                itemBuilder: (context, index) {
                  final weather = provider.weatherData[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Text(weather.getWeatherIcon(), style: const TextStyle(fontSize: 30)),
                      title: Text(weather.cityName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(weather.description),
                      trailing: Text("${weather.temperature.toStringAsFixed(1)}°C"),
                      onTap: () {
                        provider.selectCity(weather);
                        Navigator.pushNamed(
                          context,
                          AppRoutes.cityDetail,
                          arguments: weather,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => provider.loadWeatherData(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Recommencer 🔁", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, WeatherProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 80),
          const SizedBox(height: 20),
          Text(
            provider.errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => provider.loadWeatherData(),
            child: const Text("Réessayer ❌🔄"),
          ),
        ],
      ),
    );
  }
}
