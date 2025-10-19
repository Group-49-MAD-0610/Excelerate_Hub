import 'package:flutter/material.dart';
import 'package:excelerate/core/constants/theme_constants.dart';

/// Centralized bottom navigation bar for the entire application
///
/// This widget provides consistent navigation across all main screens
/// and can be easily reused throughout the app.
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(currentIndex == 0 ? Icons.school : Icons.school_outlined),
          activeIcon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: ThemeConstants.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.school),
          ),
          label: 'Programs',
        ),
        BottomNavigationBarItem(
          icon: Icon(currentIndex == 1 ? Icons.home : Icons.home_outlined),
          activeIcon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: ThemeConstants.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.home),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            currentIndex == 2 ? Icons.person : Icons.person_outline_rounded,
          ),
          activeIcon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: ThemeConstants.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.person),
          ),
          label: 'Profile',
        ),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: ThemeConstants.accentColor,
      unselectedItemColor: ThemeConstants.onSurfaceVariantColor,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 12,
      selectedFontSize: 12,
      unselectedFontSize: 10,
      iconSize: 24,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
    );
  }
}
