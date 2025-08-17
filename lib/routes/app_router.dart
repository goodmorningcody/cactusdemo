import 'package:flutter/material.dart';
import '../presentation/screens/tts_demo/tts_demo_screen.dart';
import '../presentation/screens/model_management/model_management_screen.dart';

class AppRouter {
  static const String ttsDemo = '/';
  static const String modelManagement = '/model-management';

  static Map<String, WidgetBuilder> get routes => {
        ttsDemo: (context) => const TTSDemoScreen(),
        modelManagement: (context) => const ModelManagementScreen(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ttsDemo:
        return MaterialPageRoute(
          builder: (_) => const TTSDemoScreen(),
        );
      case modelManagement:
        return MaterialPageRoute(
          builder: (_) => const ModelManagementScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const TTSDemoScreen(),
        );
    }
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => const TTSDemoScreen(),
    );
  }
}