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
import 'dashboard_screen.dart';

/// The main screen of the application that contains the bottom navigation bar.
///
/// This widget acts as a shell, displaying the content of the currently
/// selected tab.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
      ),
    );
  }
}

/// Displays the primary content for the 'Home' tab.
///
/// This widget is responsible for showing the user greeting, achievements,
/// and various program carousels.
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // --- THIS IS THE UPDATED BLOCK ---
    if (controller.error != null) {
      return ErrorDisplayWidget(
        message:
            'Failed to load home screen data.', // A more user-friendly message
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

  /// Builds the header section with a user greeting and action icons.
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

        // --- ACCESSIBILITY WIDGETS ADDED ---
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

  /// Builds the card displaying the user's achievement statistics.
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

  /// Builds a single column for a statistic (e.g., '10 Enrolled').
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

  /// Builds the stylized 'Xcelerate' logo and tagline.
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

  /// Builds a single horizontal dash for the logo graphic.
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

  /// Builds a horizontally scrollable carousel of program cards.
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
