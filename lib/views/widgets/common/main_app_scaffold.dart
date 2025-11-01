import 'package:flutter/material.dart';
import 'package:excelerate/core/constants/theme_constants.dart';
import 'package:excelerate/views/widgets/common/app_bottom_navigation.dart';
import 'package:excelerate/views/screens/home/home_screen.dart';
import 'package:excelerate/views/screens/home/profile_screen.dart';
import 'package:excelerate/views/screens/programs/program_list_screen.dart';

/// Main app scaffold that manages navigation between primary screens
///
/// This widget serves as the central navigation controller for the app,
/// providing consistent bottom navigation across all main screens.
class MainAppScaffold extends StatefulWidget {
  final int initialIndex;

  const MainAppScaffold({
    super.key,
    this.initialIndex = 1, // Default to Home
  });

  static const String routeName = '/main';

  @override
  State<MainAppScaffold> createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold> {
  late int _selectedIndex;

  // Navigation pages
  static const List<Widget> _pages = <Widget>[
    ProgramListScreen(),
    HomeContent(), // Using HomeContent instead of full HomeScreen
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.appBackgroundColor,
      body: SafeArea(child: _pages.elementAt(_selectedIndex)),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _onNavigationItemTapped,
      ),
    );
  }

  /// Handles bottom navigation item taps
  void _onNavigationItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}
