import 'package:flutter/material.dart';
import '../../views/screens/auth/login_screen.dart';
import '../../views/screens/auth/register_screen.dart';
import '../../views/screens/home/home_screen.dart';
import '../../views/screens/home/dashboard_screen.dart';
import '../../views/screens/programs/program_list_screen.dart';
import '../../views/screens/programs/program_detail_screen.dart';
import '../../views/screens/feedback/feedback_screen.dart';

/// Application route configuration
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // Route Names
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String programList = '/programs';
  static const String programDetail = '/programs/detail';
  static const String feedback = '/feedback';
  static const String profile = '/profile';
  static const String settings = '/settings';

  /// Generate route based on route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
          settings: settings,
        );

      case programList:
        return MaterialPageRoute(
          builder: (_) => const ProgramListScreen(),
          settings: settings,
        );

      case programDetail:
        final String programId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => ProgramDetailScreen(programId: programId),
          settings: settings,
        );

      case feedback:
        final String programId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => FeedbackScreen(programId: programId),
          settings: settings,
        );

      default:
        return _errorRoute(settings);
    }
  }

  /// Error route for unknown routes
  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Page Not Found',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Route: ${settings.name}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(home, (route) => false),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
      settings: settings,
    );
  }

  /// Navigate to login screen
  static void toLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(login, (route) => false);
  }

  /// Navigate to home screen
  static void toHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(home, (route) => false);
  }

  /// Navigate to program detail screen
  static void toProgramDetail(BuildContext context, String programId) {
    Navigator.of(context).pushNamed(programDetail, arguments: programId);
  }

  /// Navigate to feedback screen
  static void toFeedback(BuildContext context, String programId) {
    Navigator.of(context).pushNamed(feedback, arguments: programId);
  }

  /// Pop current route
  static void pop(BuildContext context, [dynamic result]) {
    Navigator.of(context).pop(result);
  }

  /// Check if can pop current route
  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }
}
