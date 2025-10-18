import 'package:excelerate/core/constants/theme_constants.dart';
import 'package:excelerate/core/routes/app_routes.dart';
import 'package:excelerate/views/screens/home/profile_screen.dart';
import 'package:excelerate/views/widgets/common/error_display_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/home_controller.dart';
import '../../../models/entities/achievements_model.dart';
import '../../../models/entities/program_model.dart';
import '../../widgets/specific/program_card.dart';
import '../programs/program_list_screen.dart';
// Note: dashboard_screen.dart is no longer imported.

/// The main screen of the application that contains the bottom navigation bar.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- CHANGES ARE IN THIS SECTION ---

  // Default to the 'Home' tab, which is now at index 1.
  int _selectedIndex = 1;

  // The list of pages now has only three items.
  static const List<Widget> _pages = <Widget>[
    ProgramListScreen(), // Index 0
    HomeContent(), // Index 1
    ProfileScreen(), // Index 2
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
      // The BottomNavigationBar is now customized to match the design.
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label:
                'Programs', // Label is required by the widget, but we hide it.
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        // Styling adjustments to match the wireframe
        selectedItemColor: ThemeConstants.errorColor, // Reddish-pink for active
        unselectedItemColor:
            ThemeConstants.onSurfaceVariantColor, // Gray for inactive
        showSelectedLabels: false, // Hides the text label for the active item
        showUnselectedLabels: false, // Hides the text labels for inactive items
        type: BottomNavigationBarType.fixed, // Ensures consistent behavior
      ),
    );
  }
}

// --- HomeContent and its methods below remain completely unchanged ---
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.error != null) {
      return ErrorDisplayWidget(
        message: 'Failed to load home screen data.',
        onRetry: controller.fetchHomePageData,
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, controller),
            const SizedBox(height: ThemeConstants.spacing8),
            if (controller.achievements != null)
              _buildAchievementsCard(context, controller.achievements!),
            const SizedBox(height: ThemeConstants.spacing8),
            _buildLogo(context),
            const SizedBox(height: ThemeConstants.spacing8),
            _buildProgramCarousel(
              context: context,
              title: 'Your Experiences',
              programs: controller.experiences,
            ),
            _buildProgramCarousel(
              context: context,
              title: 'Favorites',
              programs: controller.favorites,
            ),
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
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: controller.user?.avatar != null
              ? NetworkImage(controller.user!.avatar!)
              : null,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest,
          child: controller.user?.avatar == null
              ? const Icon(Icons.person, size: 28)
              : null,
        ),
        const SizedBox(width: ThemeConstants.spacing12),
        Expanded(
          child: Text(
            'Hi, ${controller.user?.name ?? 'User'}!',
            style: textTheme.titleLarge,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        Semantics(
          label: 'Search programs',
          child: IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ),
        Semantics(
          label: 'View notifications',
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ),
        Semantics(
          label: 'Open settings',
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsCard(
    BuildContext context,
    AchievementsModel achievements,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.spacing8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "You've Achieved",
              style: textTheme.titleLarge?.copyWith(
                color: ThemeConstants.errorColor,
              ),
            ),
            const SizedBox(height: ThemeConstants.spacing16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  context,
                  achievements.enrolled.toString(),
                  'Enrolled',
                ),
                _buildStatColumn(
                  context,
                  achievements.completed.toString(),
                  'Completed',
                ),
                _buildStatColumn(
                  context,
                  achievements.badges.toString(),
                  'Badges',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String value, String label) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(value, style: textTheme.titleLarge),
        const SizedBox(height: ThemeConstants.spacing4),
        Text(label, style: textTheme.titleSmall),
      ],
    );
  }

  Widget _buildLogo(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildDash(),
                  const SizedBox(height: 4),
                  _buildDash(),
                  const SizedBox(height: 4),
                  _buildDash(),
                ],
              ),
              const SizedBox(width: 1),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) =>
                    const LinearGradient(
                      colors: [
                        ThemeConstants.tertiaryColor,
                        ThemeConstants.errorColor,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                child: Text('Xcelerate', style: textTheme.displaySmall),
              ),
            ],
          ),
          const SizedBox(height: ThemeConstants.spacing4),
          Text('Learn. Engage. Grow.', style: textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildDash() {
    return Container(
      height: 6,
      width: 25,
      decoration: BoxDecoration(
        color: ThemeConstants.tertiaryColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildProgramCarousel({
    required BuildContext context,
    required String title,
    required List<ProgramModel> programs,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            color: ThemeConstants.errorColor,
          ),
        ),
        const SizedBox(height: ThemeConstants.spacing8),
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
                  AppRoutes.toProgramDetail(context, program.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
