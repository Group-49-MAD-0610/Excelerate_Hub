import 'package:flutter/material.dart';

/// Program detail screen showing specific program information
class ProgramDetailScreen extends StatelessWidget {
  final String programId;

  const ProgramDetailScreen({super.key, required this.programId});
  static const String routeName = '/program-detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Program Details')),
      body: Center(
        child: Text(
          'Program Detail Screen\nProgram ID: $programId\n(Implementation in progress)',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
