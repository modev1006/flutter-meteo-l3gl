import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/loading_screen.dart';


class AppRoutes {
  static const String home = '/';
  static const String loading = '/loading';
  static const String cityList = '/city-list';
  static const String cityDetail = '/city-detail';

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => HomeScreen(),
    loading: (context) => LoadingScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case loading:
        return MaterialPageRoute(builder: (_) => LoadingScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Page non trouvée: ${settings.name}'),
            ),
          ),
        );
    }
  }
}