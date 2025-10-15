import 'package:excelerate/views/screens/home/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/home_controller.dart';
import '../../../models/entities/achievements_model.dart';
import '../../../models/entities/program_model.dart';
import '../../widgets/specific/program_card.dart';
import '../programs/program_list_screen.dart';
import 'dashboard_screen.dart';

// This is the main screen with the bottom navigation.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // 'Home' is the first tab

  // Here we list the actual screens for each tab.
  static const List<Widget> _pages = <Widget>[
    HomeContent(),
    ProgramListScreen(),
    DashboardScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Programs'),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

// This is the specific UI for the 'Home' tab content.
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the data from the controller.
    final controller = context.watch<HomeController>();

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.error != null) {
      return Center(child: Text('Error: ${controller.error}'));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, controller),
            const SizedBox(height: 16),
            if (controller.achievements != null)
              _buildAchievementsCard(controller.achievements!),
            const SizedBox(height: 24),
            Center(
              child: Text(
                ':::Xcelerate',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.orange.shade700,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildProgramCarousel(
              context: context,
              title: 'Your Experiences',
              programs: controller.experiences,
            ),
            const SizedBox(height: 24),
            _buildProgramCarousel(
              context: context,
              title: 'Favorites',
              programs: controller.favorites,
            ),
            const SizedBox(height: 24),
            _buildProgramCarousel(
              context: context,
              title: 'Upcoming',
              programs: controller.upcoming,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeController controller) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: controller.user?.avatar != null
              ? NetworkImage(controller.user!.avatar!)
              : null,
          backgroundColor: Colors.grey.shade300,
          child: controller.user?.avatar == null
              ? const Icon(Icons.person, size: 28)
              : null,
        ),
        const SizedBox(width: 12),
        Text(
          'Hi, ${controller.user?.name ?? 'User'}!',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined)),
      ],
    );
  }

  Widget _buildAchievementsCard(AchievementsModel achievements) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "You've Achieved",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(achievements.enrolled.toString(), 'Enrolled'),
                _buildStatColumn(
                  achievements.completed.toString(),
                  'Completed',
                ),
                _buildStatColumn(achievements.badges.toString(), 'Badges'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildProgramCarousel({
    required BuildContext context,
    required String title,
    required List<ProgramModel> programs,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.pink,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: programs.length,
            itemBuilder: (context, index) {
              final program = programs[index];
              return ProgramCard(
                program: program,
                onTap: () {
                  // Navigation will be our next step.
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
