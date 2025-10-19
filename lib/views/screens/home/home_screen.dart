import 'package:excelerate/core/constants/theme_constants.dart';
import 'package:excelerate/core/routes/app_routes.dart';
import 'package:excelerate/views/widgets/common/error_display_widget.dart';
import 'package:excelerate/views/widgets/common/main_app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/home_controller.dart';
import '../../../models/entities/achievements_model.dart';
import '../../../models/entities/program_model.dart';
import '../../widgets/specific/program_card.dart';

/// Main home screen that uses the centralized navigation scaffold
///
/// This screen now delegates navigation to MainAppScaffold for consistency
/// across the application.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return const MainAppScaffold(initialIndex: 1); // Home tab
  }
}

/// Home content widget displaying the main dashboard sections
///
/// Manages the display of user information, achievements, branding,
/// and program carousels. Uses Provider pattern for state management.
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error != null) {
          return ErrorDisplayWidget(
            message: 'Failed to load home screen data.',
            onRetry: controller.fetchHomePageData,
          );
        }

        return _buildContent(context, controller);
      },
    );
  }

  /// Builds the main content layout
  Widget _buildContent(BuildContext context, HomeController controller) {
    return Container(
      color: ThemeConstants.appBackgroundColor,
      child: SingleChildScrollView(
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
            ..._buildProgramCarousels(context, controller),
          ],
        ),
      ),
    );
  }

  /// Builds all program carousels with proper spacing
  List<Widget> _buildProgramCarousels(
    BuildContext context,
    HomeController controller,
  ) {
    final carousels = <Widget>[];

    final carouselData = [
      ('Your Experiences', controller.experiences),
      ('Favorites', controller.favorites),
      ('Upcoming', controller.upcoming),
    ];

    for (int i = 0; i < carouselData.length; i++) {
      if (i > 0) {
        carousels.add(const SizedBox(height: ThemeConstants.spacing8));
      }
      carousels.add(
        _buildProgramCarousel(
          context: context,
          title: carouselData[i].$1,
          programs: carouselData[i].$2,
        ),
      );
    }

    return carousels;
  }

  /// Builds the header section with user info and action buttons
  ///
  /// Displays user avatar, greeting, and action buttons for search,
  /// notifications, and settings.
  Widget _buildHeader(BuildContext context, HomeController controller) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spacing12),
      decoration: BoxDecoration(
        color: ThemeConstants.appBackgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(ThemeConstants.borderRadiusMedium),
        ),
      ),
      child: Row(
        children: [
          _buildUserAvatar(controller),
          const SizedBox(width: ThemeConstants.spacing12),
          _buildGreeting(textTheme, controller),
          ..._buildActionButtons(),
        ],
      ),
    );
  }

  /// Builds user avatar with fallback
  Widget _buildUserAvatar(HomeController controller) {
    return CircleAvatar(
      radius: 24,
      backgroundImage: controller.user?.avatar != null
          ? NetworkImage(controller.user!.avatar!)
          : null,
      backgroundColor: Colors.grey.shade300,
      child: controller.user?.avatar == null
          ? const Icon(Icons.person, size: 28)
          : null,
    );
  }

  /// Builds greeting text
  Widget _buildGreeting(TextTheme textTheme, HomeController controller) {
    return Expanded(
      child: Text(
        'Hi, ${controller.user?.name ?? 'User'}!',
        style: textTheme.titleLarge,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  /// Builds action buttons
  List<Widget> _buildActionButtons() {
    return [
      _buildActionButton(
        icon: Icons.search,
        label: 'Search programs',
        onPressed: () {
          // TODO: Implement search functionality
        },
      ),
      _buildActionButton(
        icon: Icons.notifications_outlined,
        label: 'View notifications',
        onPressed: () {
          // TODO: Implement notifications
        },
      ),
      _buildActionButton(
        icon: Icons.settings_outlined,
        label: 'Open settings',
        onPressed: () {
          // TODO: Implement settings
        },
      ),
    ];
  }

  /// Builds individual action button with semantics
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Semantics(
      label: label,
      child: IconButton(onPressed: onPressed, icon: Icon(icon)),
    );
  }

  /// Builds the achievements card displaying user statistics
  ///
  /// Shows enrolled programs, completed programs, and badges earned
  /// with proper styling and layout.
  Widget _buildAchievementsCard(
    BuildContext context,
    AchievementsModel achievements,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ThemeConstants.spacing16),
      decoration: BoxDecoration(
        color: ThemeConstants.surfaceColor,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAchievementsTitle(),
          const SizedBox(height: ThemeConstants.spacing16),
          _buildStatisticsRow(achievements),
        ],
      ),
    );
  }

  /// Builds the achievements section title
  Widget _buildAchievementsTitle() {
    return Text(
      "You've Achieved",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: ThemeConstants.primaryColor,
      ),
    );
  }

  /// Builds the statistics row with achievements data
  Widget _buildStatisticsRow(AchievementsModel achievements) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatColumn(achievements.enrolled.toString(), 'Enrolled'),
        _buildStatColumn(achievements.completed.toString(), 'Completed'),
        _buildStatColumn(achievements.badges.toString(), 'Badges'),
      ],
    );
  }

  /// Builds individual statistic column with value and label
  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ThemeConstants.primaryColor,
          ),
        ),
        const SizedBox(height: ThemeConstants.spacing4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  /// Builds the logo section with branding
  ///
  /// Displays the Xcelerate logo with gradient text,
  /// decorative dashes, and tagline.
  Widget _buildLogo(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ThemeConstants.spacing16),
      decoration: BoxDecoration(
        color: ThemeConstants.surfaceColor,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
      ),
      child: Center(
        child: Column(
          children: [
            _buildLogoRow(textTheme),
            const SizedBox(height: ThemeConstants.spacing4),
            _buildTagline(textTheme),
          ],
        ),
      ),
    );
  }

  /// Builds the main logo row with dashes and text
  Widget _buildLogoRow(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildDashColumn(),
        const SizedBox(width: 1),
        _buildGradientText('Xcelerate', textTheme),
      ],
    );
  }

  /// Builds the column of decorative dashes
  Widget _buildDashColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildDash(),
        const SizedBox(height: 4),
        _buildDash(),
        const SizedBox(height: 4),
        _buildDash(),
      ],
    );
  }

  /// Builds gradient text for the logo
  Widget _buildGradientText(String text, TextTheme textTheme) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        colors: [ThemeConstants.tertiaryColor, ThemeConstants.errorColor],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(text, style: textTheme.displaySmall),
    );
  }

  /// Builds the tagline text
  Widget _buildTagline(TextTheme textTheme) {
    return Text('Learn. Engage. Grow.', style: textTheme.bodySmall);
  }

  /// Builds individual decorative dash
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

  /// Builds a program carousel section with title and horizontal list
  ///
  /// Creates a titled section containing a horizontal scrollable list
  /// of program cards for easy browsing.
  Widget _buildProgramCarousel({
    required BuildContext context,
    required String title,
    required List<ProgramModel> programs,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ThemeConstants.spacing16),
      decoration: BoxDecoration(
        color: ThemeConstants.surfaceColor,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCarouselTitle(title, textTheme),
          const SizedBox(height: ThemeConstants.spacing8),
          _buildHorizontalProgramList(programs),
        ],
      ),
    );
  }

  /// Builds the carousel title with styled text
  Widget _buildCarouselTitle(String title, TextTheme textTheme) {
    return Text(
      title,
      style: textTheme.titleLarge?.copyWith(color: ThemeConstants.errorColor),
    );
  }

  /// Builds the horizontal scrollable program list
  Widget _buildHorizontalProgramList(List<ProgramModel> programs) {
    return SizedBox(
      height: 80, // Optimized height for row layout
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: programs.length,
        itemBuilder: (context, index) {
          final program = programs[index];
          return ProgramCard(
            program: program,
            onTap: () => AppRoutes.toProgramDetail(context, program.id),
          );
        },
      ),
    );
  }
}
