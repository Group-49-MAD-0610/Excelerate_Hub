import 'package:flutter/material.dart';
import '../../../core/constants/theme_constants.dart';

/// Program list screen showing all available programs
class ProgramListScreen extends StatelessWidget {
  const ProgramListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.appBackgroundColor,
      appBar: AppBar(title: const Text('Programs')),
      body: const Center(
        child: Text(
          'Program List Screen\n(Implementation in progress)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
