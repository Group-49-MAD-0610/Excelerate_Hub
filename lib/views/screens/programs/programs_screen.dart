import 'package:flutter/material.dart';
import 'package:excelerate/views/widgets/common/main_app_scaffold.dart';

/// Programs screen that uses the centralized navigation scaffold
///
/// This screen delegates navigation to MainAppScaffold for consistency
/// across the application.
class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  static const String routeName = '/programs';

  @override
  Widget build(BuildContext context) {
    return const MainAppScaffold(initialIndex: 0); // Programs tab
  }
}
