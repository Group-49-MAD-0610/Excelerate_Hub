import 'package:flutter/material.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../widgets/common/app_bottom_navigation.dart';

/// Dashboard screen for analytics and overview
///
/// This screen provides analytics and overview information
/// while maintaining consistent navigation across the application.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.appBackgroundColor,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: ThemeConstants.surfaceColor,
        foregroundColor: ThemeConstants.onSurfaceColor,
      ),
      body: const Center(
        child: Text(
          'Dashboard Screen\n(Implementation in progress)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 1, // Home tab (dashboard is part of home section)
        onTap: (index) => _handleBottomNavigation(context, index),
      ),
    );
  }

  /// Handles bottom navigation tap events
  void _handleBottomNavigation(BuildContext context, int index) {
    switch (index) {
      case 0: // Programs
        AppRoutes.toPrograms(context);
        break;
      case 1: // Home
        AppRoutes.toHome(context);
        break;
      case 2: // Profile
        AppRoutes.toProfile(context);
        break;
    }
  }
}
