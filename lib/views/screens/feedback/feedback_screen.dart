import 'package:flutter/material.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../widgets/common/app_bottom_navigation.dart';

/// Feedback screen for program feedback and reviews
///
/// This screen allows users to provide feedback and reviews for programs
/// while maintaining consistent navigation across the application.
class FeedbackScreen extends StatelessWidget {
  final String programId;

  const FeedbackScreen({super.key, required this.programId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.appBackgroundColor,
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: ThemeConstants.surfaceColor,
        foregroundColor: ThemeConstants.onSurfaceColor,
      ),
      body: Center(
        child: Text(
          'Feedback Screen\nProgram ID: $programId\n(Implementation in progress)',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 0, // Programs tab (since this is program-related)
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
