
import 'package:flutter/material.dart';

class LoadingProvider extends ChangeNotifier {
  double _progress = 0.0;
  int _currentMessageIndex = 0;
  bool _isLoading = false;

  double get progress => _progress;
  int get currentMessageIndex => _currentMessageIndex;
  bool get isLoading => _isLoading;

  final List<String> loadingMessages = [
    "Nous téléchargeons les données...",
    "C'est presque fini...",
    "Plus que quelques secondes avant d'avoir le résultat...",
    "Préparation de la magie météo...",
    "Presque prêt !",
  ];

  void startLoading() {
    _progress = 0.0;
    _currentMessageIndex = 0;
    _isLoading = true;
    // Ne pas notifier ici si appelé pendant build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void updateProgress(double progress) {
    _progress = progress.clamp(0.0, 1.0);

    // Changer de message en fonction de la progression
    if (_progress > 0.66 && _currentMessageIndex < 4) {
      _currentMessageIndex = 4;
    } else if (_progress > 0.33 && _currentMessageIndex < 2) {
      _currentMessageIndex = 2;
    } else if (_progress > 0.0 && _currentMessageIndex < 1) {
      _currentMessageIndex = 1;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void nextMessage() {
    if (_currentMessageIndex < loadingMessages.length - 1) {
      _currentMessageIndex++;
    } else {
      _currentMessageIndex = 0;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void finishLoading() {
    _progress = 1.0;
    _isLoading = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void reset() {
    _progress = 0.0;
    _currentMessageIndex = 0;
    _isLoading = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}