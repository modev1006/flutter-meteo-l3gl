import 'package:flutter/material.dart';
import 'dart:async';
import '../api/models/city_model.dart';
import '../api/models/weather_model.dart';
import '../api/services/api_service.dart';
import '../routes/app_routes.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {

  final ApiService _apiService = ApiService();

  late AnimationController _progressController;

  Timer? _messageTimer;
  Timer? _completionTimer;

  int _currentMessageIndex = 0;
  bool _hasError = false;
  bool _dataLoadingComplete = false;
  bool _navigationTriggered = false;
  String _errorMessage = '';
  List<WeatherModel> _weatherData = [];

  int _citiesLoaded = 0;
  int _totalCities = CityModel.defaultCities.length;

  static const int LOADING_TIME = 8;

  final List<String> _loadingMessages = [
    'Préparation de la baguette magique...',
    'Consultation des nuages français...',
    'Réveil du coq gaulois. cog koriko..',
    'Analyse des fromages régionaux...',
    'Chargement du vin local...',
    'Calcul de l\'indice de grasse matinée...',
    'Mesure de l\'accent du sud...',
    'Prévision de bouchons parisiens...',
    'Estimation de la consommation de café...',
    'Prédiction de la prochaine grève...',
  ];

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: LOADING_TIME),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkLoadingCompletion();
      }
    });

    _startLoadingProcess();
  }

  void _startLoadingProcess() {
    _progressController.reset();
    _progressController.forward();

    _citiesLoaded = 0;
    _weatherData.clear();
    _hasError = false;
    _dataLoadingComplete = false;
    _navigationTriggered = false;

    _messageTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted && !_hasError && !_navigationTriggered) {
        setState(() {
          _currentMessageIndex =
              (_currentMessageIndex + 1) % _loadingMessages.length;
        });
      }
    });

    _loadWeatherDataInBackground();
  }

  Future<void> _loadWeatherDataInBackground() async {
    try {
      bool hasConnection = await _apiService.checkConnectivity();
      if (!hasConnection) {
        throw Exception('Pas de connexion internet');
      }

      List<String> cityNames =
      CityModel.defaultCities.map((city) => city.name).toList();

      List<WeatherModel> tempWeatherData = [];

      for (String cityName in cityNames) {
        if (!mounted) return;

        try {
          WeatherModel weather =
          await _apiService.fetchWeather(cityName);
          tempWeatherData.add(weather);
          _citiesLoaded++;
          setState(() {});
        } catch (_) {}
      }

      if (!mounted) return;

      _weatherData = tempWeatherData;
      _dataLoadingComplete = true;

      _checkLoadingCompletion();

    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage =
              e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  void _checkLoadingCompletion() {
    if (_navigationTriggered || !mounted) return;

    if (_progressController.isCompleted) {
      if (_dataLoadingComplete &&
          _weatherData.length == _totalCities) {
        _navigateToCityList();
      } else {
        _completionTimer = Timer(const Duration(seconds: 2), () {
          if (mounted && !_navigationTriggered) {
            if (_dataLoadingComplete &&
                _weatherData.length == _totalCities) {
              _navigateToCityList();
            } else {
              setState(() {
                _hasError = true;
                _errorMessage = 'Délai de chargement dépassé';
              });
            }
          }
        });
      }
    }
  }

  void _navigateToCityList() {
    if (_navigationTriggered || !mounted) return;

    _navigationTriggered = true;
    _cancelTimers();

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.cityList,
      arguments: _weatherData,
    );
  }

  void _cancelTimers() {
    _messageTimer?.cancel();
    _completionTimer?.cancel();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _cancelTimers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalMargin = screenWidth * 0.20;

    double remainingSeconds =
    (LOADING_TIME * (1 - _progressController.value))
        .clamp(0.0, LOADING_TIME.toDouble());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
          child: Center(
            child: _hasError
                ? _buildErrorWidget()
                : _buildLoadingWidget(remainingSeconds),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(double remainingSeconds) {

    final screenWidth = MediaQuery.of(context).size.width;
    final gaugeSize = screenWidth * 0.65;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        AnimatedBuilder(
          animation: _progressController,
          builder: (context, child) {

            final progress = Curves.easeInOut.transform(
              _progressController.value,
            );

            return SizedBox(
              width: gaugeSize,
              height: gaugeSize,
              child: Stack(
                alignment: Alignment.center,
                children: [

                  // Cercle principal
                  SizedBox(
                    width: gaugeSize,
                    height: gaugeSize,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 14,
                      backgroundColor: Colors.yellow,
                    ),
                  ),

                  // Cercle blanc intérieur
                  Container(
                    width: gaugeSize * 0.65,
                    height: gaugeSize * 0.65,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                  ),

                  // Texte centré
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Chargement',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.yellow,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 40),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: Text(
            _loadingMessages[_currentMessageIndex],
            key: ValueKey(_currentMessageIndex),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(height: 25),

        Text(
          'Temps restant : ${remainingSeconds.toStringAsFixed(1)} s',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 30),

        LinearProgressIndicator(
          value: _citiesLoaded / _totalCities,
          minHeight: 6,
        ),

        const SizedBox(height: 8),

        Text(
          '$_citiesLoaded/$_totalCities villes traitées',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        const Icon(Icons.error_outline,
            size: 80, color: Colors.red),

        const SizedBox(height: 20),

        const Text(
          'Erreur de chargement',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          _errorMessage.isEmpty
              ? 'Impossible de charger les données météo'
              : _errorMessage,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 30),

        ElevatedButton.icon(
          onPressed: _startLoadingProcess,
          icon: const Icon(Icons.refresh),
          label: const Text('Réessayer'),
        ),
      ],
    );
  }
}