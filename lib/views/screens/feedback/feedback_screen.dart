import 'package:flutter/material.dart';

/// Feedback screen for program feedback and reviews
class FeedbackScreen extends StatelessWidget {
  final String programId;

  const FeedbackScreen({super.key, required this.programId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: Center(
        child: Text(
          'Feedback Screen\nProgram ID: $programId\n(Implementation in progress)',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
