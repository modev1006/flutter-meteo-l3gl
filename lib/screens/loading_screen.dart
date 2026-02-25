// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'dart:async';
// import '../widgets/loading_gauge.dart';
// import '../providers/weather_provider.dart';
// import '../providers/loading_provider.dart';
// import '../routes/app_routes.dart';
//
// class LoadingScreen extends StatefulWidget {
//   @override
//   _LoadingScreenState createState() => _LoadingScreenState();
// }
//
// class _LoadingScreenState extends State<LoadingScreen> {
//   Timer? _messageTimer;
//   Timer? _progressTimer;
//   bool _hasError = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _startLoadingProcess();
//   }
//
//   void _startLoadingProcess() {
//     final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
//     final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
//
//     loadingProvider.startLoading();
//
//     // Timer pour changer les messages toutes les 2.5 secondes
//     _messageTimer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
//       if (mounted && !_hasError) {
//         loadingProvider.nextMessage();
//       }
//     });
//
//     // Lancer le chargement des données
//     weatherProvider.loadWeatherData().then((_) {
//       if (weatherProvider.state == LoadingState.success) {
//         loadingProvider.finishLoading();
//         _navigateToCityList();
//       } else if (weatherProvider.state == LoadingState.error) {
//         setState(() {
//           _hasError = true;
//         });
//       }
//     });
//
//     // Simuler une progression fluide
//     _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       if (mounted && !_hasError) {
//         final currentProgress = loadingProvider.progress;
//         if (currentProgress < 0.95) {
//           loadingProvider.updateProgress(currentProgress + 0.01);
//         }
//       }
//     });
//   }
//
//   void _navigateToCityList() {
//     if (mounted) {
//       _messageTimer?.cancel();
//       _progressTimer?.cancel();
//       Navigator.pushReplacementNamed(context, AppRoutes.cityList);
//     }
//   }
//
//   void _retry() {
//     setState(() {
//       _hasError = false;
//     });
//     _startLoadingProcess();
//   }
//
//   @override
//   void dispose() {
//     _messageTimer?.cancel();
//     _progressTimer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer2<WeatherProvider, LoadingProvider>(
//       builder: (context, weatherProvider, loadingProvider, child) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Chargement magique'),
//             automaticallyImplyLeading: false,
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (weatherProvider.state == LoadingState.error)
//                   _buildErrorWidget(weatherProvider.errorMessage)
//                 else
//                   _buildLoadingWidget(loadingProvider),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildLoadingWidget(LoadingProvider loadingProvider) {
//     return Column(
//       children: [
//         LoadingGauge(
//           progress: loadingProvider.progress,
//           size: 200,
//         ),
//         const SizedBox(height: 40),
//         AnimatedSwitcher(
//           duration: const Duration(milliseconds: 500),
//           child: Text(
//             loadingProvider.loadingMessages[loadingProvider.currentMessageIndex],
//             key: ValueKey(loadingProvider.currentMessageIndex),
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         const SizedBox(height: 20),
//         LinearProgressIndicator(
//           value: loadingProvider.progress,
//           backgroundColor: Colors.grey[300],
//           valueColor: AlwaysStoppedAnimation<Color>(
//             Theme.of(context).colorScheme.primary,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildErrorWidget(String errorMessage) {
//     return Column(
//       children: [
//         Icon(
//           Icons.error_outline,
//           size: 100,
//           color: Colors.red[300],
//         ),
//         const SizedBox(height: 20),
//         Text(
//           'Oups ! Une erreur est survenue',
//           style: const TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 10),
//         Text(
//           errorMessage,
//           style: const TextStyle(fontSize: 16),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 30),
//         ElevatedButton.icon(
//           onPressed: _retry,
//           icon: const Icon(Icons.refresh),
//           label: const Text('Réessayer'),
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//             textStyle: const TextStyle(fontSize: 18),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../widgets/loading_gauge.dart';
import '../providers/weather_provider.dart';
import '../providers/loading_provider.dart';
import '../routes/app_routes.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Timer? _messageTimer;
  Timer? _progressTimer;
  bool _hasError = false;
  bool _isLoadingStarted = false;

  @override
  void initState() {
    super.initState();
    // Ne pas démarrer le chargement ici, utiliser postFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isLoadingStarted) {
        _startLoadingProcess();
      }
    });
  }

  void _startLoadingProcess() {
    setState(() {
      _isLoadingStarted = true;
    });

    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);

    // Réinitialiser avant de commencer
    loadingProvider.reset();
    loadingProvider.startLoading();

    // Timer pour changer les messages toutes les 2.5 secondes
    _messageTimer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      if (mounted && !_hasError) {
        loadingProvider.nextMessage();
      }
    });

    // Lancer le chargement des données
    weatherProvider.loadWeatherData().then((_) {
      if (mounted) {
        if (weatherProvider.state == LoadingState.success) {
          loadingProvider.finishLoading();
          _navigateToCityList();
        } else if (weatherProvider.state == LoadingState.error) {
          setState(() {
            _hasError = true;
          });
        }
      }
    });

    // Simuler une progression fluide
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted && !_hasError && loadingProvider.isLoading) {
        final currentProgress = loadingProvider.progress;
        if (currentProgress < 0.95) {
          loadingProvider.updateProgress(currentProgress + 0.01);
        }
      }
    });
  }

  void _navigateToCityList() {
    if (mounted) {
      _messageTimer?.cancel();
      _progressTimer?.cancel();
      Navigator.pushReplacementNamed(context, AppRoutes.cityList);
    }
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _isLoadingStarted = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isLoadingStarted) {
        _startLoadingProcess();
      }
    });
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WeatherProvider, LoadingProvider>(
      builder: (context, weatherProvider, loadingProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Chargement magique'),
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_hasError || weatherProvider.state == LoadingState.error)
                  _buildErrorWidget(weatherProvider.errorMessage)
                else
                  _buildLoadingWidget(loadingProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingWidget(LoadingProvider loadingProvider) {
    return Column(
      children: [
        LoadingGauge(
          progress: loadingProvider.progress,
          size: 200,
        ),
        const SizedBox(height: 40),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Text(
            loadingProvider.loadingMessages[loadingProvider.currentMessageIndex],
            key: ValueKey(loadingProvider.currentMessageIndex),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        LinearProgressIndicator(
          value: loadingProvider.progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Column(
      children: [
        Icon(
          Icons.error_outline,
          size: 100,
          color: Colors.red[300],
        ),
        const SizedBox(height: 20),
        Text(
          'Oups ! Une erreur est survenue',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          errorMessage,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: _retry,
          icon: const Icon(Icons.refresh),
          label: const Text('Réessayer'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}