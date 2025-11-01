import 'package:flutter/material.dart';
import 'package:excelerate/views/widgets/common/main_app_scaffold.dart';

/// Profile screen wrapper that uses the centralized navigation scaffold
///
/// This screen delegates navigation to MainAppScaffold for consistency
/// across the application.
class ProfileScreenWrapper extends StatelessWidget {
  const ProfileScreenWrapper({super.key});

  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return const MainAppScaffold(initialIndex: 2); // Profile tab
  }
}
