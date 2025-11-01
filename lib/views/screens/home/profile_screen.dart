import 'package:flutter/material.dart';
import '../../../core/constants/theme_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.appBackgroundColor,
      body: const Center(
        child: Text('Profile Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
