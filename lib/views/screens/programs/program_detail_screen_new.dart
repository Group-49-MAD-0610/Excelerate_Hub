import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../controllers/program_controller.dart';
import '../../../models/entities/program_model.dart';
import '../../../core/constants/theme_constants.dart';
import '../../widgets/common/loading_indicator.dart';

/// Modern Program Details Screen following Figma design specifications
/// Implements Material Design 3 principles with enhanced UX patterns
class ProgramDetailScreen extends StatefulWidget {
  final String programId;

  const ProgramDetailScreen({super.key, required this.programId});
  static const String routeName = '/program-detail';

  @override
  State<ProgramDetailScreen> createState() => _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends State<ProgramDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isEnrollmentLoading = false;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load program details when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgramController>().loadProgram(widget.programId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.backgroundColor,
      body: Consumer<ProgramController>(
        builder: (context, programController, child) {
          // Loading state
          if (programController.isLoading &&
              programController.currentProgram == null) {
            return Scaffold(
              appBar: _buildAppBar(context, null),
              body: const Center(
                child: LoadingIndicator(message: 'Loading program details...'),
              ),
            );
          }

          // Error state
          if (programController.error != null &&
              programController.currentProgram == null) {
            return Scaffold(
              appBar: _buildAppBar(context, null),
              body: _buildErrorState(programController),
            );
          }

          final program = programController.currentProgram;
          if (program == null) {
            return Scaffold(
              appBar: _buildAppBar(context, null),
              body: _buildNotFoundState(),
            );
          }

          return _buildProgramContent(context, program, programController);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ProgramModel? program,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: ThemeConstants.onSurfaceColor,
            size: 18,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              _isFavorited ? Icons.favorite : Icons.favorite_border,
              color: _isFavorited
                  ? ThemeConstants.errorColor
                  : ThemeConstants.onSurfaceColor,
              size: 18,
            ),
          ),
          onPressed: () {
            setState(() {
              _isFavorited = !_isFavorited;
            });
            _showSnackBar(
              context,
              _isFavorited ? 'Added to favorites' : 'Removed from favorites',
              ThemeConstants.successColor,
            );
          },
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.share_outlined,
              color: ThemeConstants.onSurfaceColor,
              size: 18,
            ),
          ),
          onPressed: () => _handleShare(context, program),
        ),
        const SizedBox(width: ThemeConstants.spacing8),
      ],
    );
  }

  Widget _buildErrorState(ProgramController programController) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(ThemeConstants.spacing24),
              decoration: BoxDecoration(
                color: ThemeConstants.errorColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(
                  ThemeConstants.borderRadiusLarge,
                ),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: ThemeConstants.errorColor,
              ),
            ),
            const SizedBox(height: ThemeConstants.spacing24),
            const Text(
              'Failed to load program',
              style: TextStyle(
                fontSize: ThemeConstants.titleLargeFontSize,
                fontWeight: FontWeight.w600,
                color: ThemeConstants.onSurfaceColor,
              ),
            ),
            const SizedBox(height: ThemeConstants.spacing12),
            Text(
              'We couldn\'t load the program details. Please check your connection and try again.',
              style: TextStyle(
                fontSize: ThemeConstants.bodyMediumFontSize,
                color: ThemeConstants.onSurfaceVariantColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ThemeConstants.spacing32),
            ElevatedButton.icon(
              onPressed: () {
                programController.loadProgram(widget.programId);
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeConstants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.spacing24,
                  vertical: ThemeConstants.spacing12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ThemeConstants.borderRadiusMedium,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(ThemeConstants.spacing24),
              decoration: BoxDecoration(
                color: ThemeConstants.onSurfaceVariantColor.withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(
                  ThemeConstants.borderRadiusLarge,
                ),
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 64,
                color: ThemeConstants.onSurfaceVariantColor,
              ),
            ),
            const SizedBox(height: ThemeConstants.spacing24),
            const Text(
              'Program not found',
              style: TextStyle(
                fontSize: ThemeConstants.titleLargeFontSize,
                fontWeight: FontWeight.w600,
                color: ThemeConstants.onSurfaceColor,
              ),
            ),
            const SizedBox(height: ThemeConstants.spacing12),
            Text(
              'The program you\'re looking for doesn\'t exist or has been removed.',
              style: TextStyle(
                fontSize: ThemeConstants.bodyMediumFontSize,
                color: ThemeConstants.onSurfaceVariantColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramContent(
    BuildContext context,
    ProgramModel program,
    ProgramController programController,
  ) {
    return CustomScrollView(
      slivers: [
        // Hero Image Section
        SliverAppBar(
          expandedHeight: 280,
          pinned: false,
          backgroundColor: Colors.transparent,
          leading: const SizedBox.shrink(),
          flexibleSpace: FlexibleSpaceBar(
            background: _buildHeroSection(program),
          ),
        ),

        // Main Content
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              color: ThemeConstants.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ThemeConstants.borderRadiusLarge),
                topRight: Radius.circular(ThemeConstants.borderRadiusLarge),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: ThemeConstants.spacing24),

                // Program Header
                _buildProgramHeader(program),

                // Program Stats
                _buildProgramStats(program),

                // Description
                _buildDescription(program),

                // Enrollment Section
                _buildEnrollmentSection(context, program, programController),

                // Tab Section
                _buildTabSection(program),

                const SizedBox(height: ThemeConstants.spacing24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection(ProgramModel program) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ThemeConstants.primaryColor.withValues(alpha: 0.8),
            ThemeConstants.primaryColor.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background pattern or image would go here
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: ThemeConstants.primaryColor.withValues(alpha: 0.1),
              ),
              child: Center(
                child: Icon(
                  Icons.play_circle_outline_rounded,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),

          // App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildAppBar(context, program),
          ),

          // Program Badge
          Positioned(
            bottom: ThemeConstants.spacing16,
            right: ThemeConstants.spacing16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.spacing12,
                vertical: ThemeConstants.spacing4,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  ThemeConstants.borderRadiusSmall,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.category_rounded,
                    size: 16,
                    color: ThemeConstants.primaryColor,
                  ),
                  const SizedBox(width: ThemeConstants.spacing4),
                  Text(
                    program.category,
                    style: const TextStyle(
                      fontSize: ThemeConstants.bodySmallFontSize,
                      fontWeight: FontWeight.w600,
                      color: ThemeConstants.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramHeader(ProgramModel program) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.spacing8,
                  vertical: ThemeConstants.spacing4,
                ),
                decoration: BoxDecoration(
                  color: _getLevelColor(program.level).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    ThemeConstants.borderRadiusSmall,
                  ),
                ),
                child: Text(
                  program.level.toUpperCase(),
                  style: TextStyle(
                    fontSize: ThemeConstants.bodySmallFontSize,
                    fontWeight: FontWeight.w700,
                    color: _getLevelColor(program.level),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              if (program.price != null && program.price! > 0) ...[
                Text(
                  '\$${program.price!.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: ThemeConstants.titleLargeFontSize,
                    fontWeight: FontWeight.w700,
                    color: ThemeConstants.primaryColor,
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.spacing8,
                    vertical: ThemeConstants.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeConstants.successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      ThemeConstants.borderRadiusSmall,
                    ),
                  ),
                  child: const Text(
                    'FREE',
                    style: TextStyle(
                      fontSize: ThemeConstants.bodySmallFontSize,
                      fontWeight: FontWeight.w700,
                      color: ThemeConstants.successColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: ThemeConstants.spacing12),
          Text(
            program.title,
            style: const TextStyle(
              fontSize: ThemeConstants.headlineMediumFontSize,
              fontWeight: FontWeight.w700,
              color: ThemeConstants.onSurfaceColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: ThemeConstants.spacing8),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: ThemeConstants.primaryColor.withValues(
                  alpha: 0.1,
                ),
                child: Text(
                  program.instructorName.isNotEmpty
                      ? program.instructorName[0].toUpperCase()
                      : 'I',
                  style: const TextStyle(
                    fontSize: ThemeConstants.bodySmallFontSize,
                    fontWeight: FontWeight.w600,
                    color: ThemeConstants.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: ThemeConstants.spacing8),
              Text(
                'By ${program.instructorName}',
                style: TextStyle(
                  fontSize: ThemeConstants.bodyMediumFontSize,
                  color: ThemeConstants.onSurfaceVariantColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgramStats(ProgramModel program) {
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.spacing16),
      child: Row(
        children: [
          _buildStatItem(
            icon: Icons.star_rounded,
            value: program.rating.toString(),
            label: '${program.reviewCount} reviews',
            color: Colors.orange,
          ),
          const SizedBox(width: ThemeConstants.spacing16),
          _buildStatItem(
            icon: Icons.people_rounded,
            value: _formatNumber(program.enrollmentCount),
            label: 'students',
            color: ThemeConstants.primaryColor,
          ),
          const SizedBox(width: ThemeConstants.spacing16),
          _buildStatItem(
            icon: Icons.schedule_rounded,
            value: program.duration.split(' ')[0],
            label: program.duration.split(' ').skip(1).join(' '),
            color: ThemeConstants.secondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: ThemeConstants.spacing8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: ThemeConstants.bodyMediumFontSize,
                fontWeight: FontWeight.w600,
                color: ThemeConstants.onSurfaceColor,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: ThemeConstants.bodySmallFontSize,
                color: ThemeConstants.onSurfaceVariantColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(ProgramModel program) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this program',
            style: TextStyle(
              fontSize: ThemeConstants.titleMediumFontSize,
              fontWeight: FontWeight.w600,
              color: ThemeConstants.onSurfaceColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.spacing12),
          Text(
            program.description,
            style: TextStyle(
              fontSize: ThemeConstants.bodyMediumFontSize,
              color: ThemeConstants.onSurfaceVariantColor,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentSection(
    BuildContext context,
    ProgramModel program,
    ProgramController programController,
  ) {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.spacing16),
      padding: const EdgeInsets.all(ThemeConstants.spacing20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (program.isEnrolled && program.progress != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: ThemeConstants.bodyMediumFontSize,
                    fontWeight: FontWeight.w600,
                    color: ThemeConstants.onSurfaceColor,
                  ),
                ),
                Text(
                  '${program.progress!.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: ThemeConstants.bodyMediumFontSize,
                    fontWeight: FontWeight.w600,
                    color: ThemeConstants.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: ThemeConstants.spacing8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: program.progress! / 100,
                backgroundColor: ThemeConstants.outlineColor,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  ThemeConstants.primaryColor,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: ThemeConstants.spacing20),
          ],

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isEnrollmentLoading
                  ? null
                  : () =>
                        _handleEnrollment(context, program, programController),
              style: ElevatedButton.styleFrom(
                backgroundColor: program.isEnrolled
                    ? ThemeConstants.successColor
                    : ThemeConstants.primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: ThemeConstants.outlineColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ThemeConstants.borderRadiusMedium,
                  ),
                ),
                elevation: 0,
              ),
              child: _isEnrollmentLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          program.isEnrolled
                              ? Icons.play_arrow_rounded
                              : Icons.school_rounded,
                          size: 20,
                        ),
                        const SizedBox(width: ThemeConstants.spacing8),
                        Text(
                          program.isEnrolled
                              ? 'Continue Learning'
                              : 'Enroll Now',
                          style: const TextStyle(
                            fontSize: ThemeConstants.bodyMediumFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection(ProgramModel program) {
    return Column(
      children: [
        // Tab Bar
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spacing16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ThemeConstants.borderRadiusMedium,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: ThemeConstants.primaryColor,
            unselectedLabelColor: ThemeConstants.onSurfaceVariantColor,
            indicator: BoxDecoration(
              color: ThemeConstants.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                ThemeConstants.borderRadiusMedium,
              ),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: const TextStyle(
              fontSize: ThemeConstants.bodyMediumFontSize,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: ThemeConstants.bodyMediumFontSize,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Curriculum'),
              Tab(text: 'Instructor'),
            ],
          ),
        ),

        const SizedBox(height: ThemeConstants.spacing16),

        // Tab Content
        Container(
          height: 300,
          margin: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spacing16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ThemeConstants.borderRadiusMedium,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(program),
              _buildCurriculumTab(program),
              _buildInstructorTab(program),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab(ProgramModel program) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(ThemeConstants.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What you\'ll learn',
            style: TextStyle(
              fontSize: ThemeConstants.titleMediumFontSize,
              fontWeight: FontWeight.w600,
              color: ThemeConstants.onSurfaceColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.spacing12),
          if (program.outcomes.isNotEmpty) ...[
            ...program.outcomes
                .map(
                  (outcome) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: ThemeConstants.spacing8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: ThemeConstants.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: ThemeConstants.spacing12),
                        Expanded(
                          child: Text(
                            outcome,
                            style: TextStyle(
                              fontSize: ThemeConstants.bodyMediumFontSize,
                              color: ThemeConstants.onSurfaceVariantColor,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ] else ...[
            Text(
              'Comprehensive learning outcomes will help you master key concepts and practical skills in ${program.category.toLowerCase()}.',
              style: TextStyle(
                fontSize: ThemeConstants.bodyMediumFontSize,
                color: ThemeConstants.onSurfaceVariantColor,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCurriculumTab(ProgramModel program) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(ThemeConstants.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Course Content',
            style: TextStyle(
              fontSize: ThemeConstants.titleMediumFontSize,
              fontWeight: FontWeight.w600,
              color: ThemeConstants.onSurfaceColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.spacing12),
          if (program.curriculum.isNotEmpty) ...[
            ...program.curriculum.asMap().entries.map((entry) {
              final index = entry.key;
              final week = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: ThemeConstants.spacing12),
                padding: const EdgeInsets.all(ThemeConstants.spacing16),
                decoration: BoxDecoration(
                  color: ThemeConstants.surfaceVariantColor,
                  borderRadius: BorderRadius.circular(
                    ThemeConstants.borderRadiusSmall,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: ThemeConstants.primaryColor.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: ThemeConstants.bodySmallFontSize,
                            fontWeight: FontWeight.w600,
                            color: ThemeConstants.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: ThemeConstants.spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            week.title,
                            style: const TextStyle(
                              fontSize: ThemeConstants.bodyMediumFontSize,
                              fontWeight: FontWeight.w600,
                              color: ThemeConstants.onSurfaceColor,
                            ),
                          ),
                          if (week.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              week.description,
                              style: TextStyle(
                                fontSize: ThemeConstants.bodySmallFontSize,
                                color: ThemeConstants.onSurfaceVariantColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(ThemeConstants.spacing16),
              decoration: BoxDecoration(
                color: ThemeConstants.surfaceVariantColor,
                borderRadius: BorderRadius.circular(
                  ThemeConstants.borderRadiusSmall,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.book_outlined,
                    size: 48,
                    color: ThemeConstants.onSurfaceVariantColor,
                  ),
                  const SizedBox(height: ThemeConstants.spacing12),
                  Text(
                    'Curriculum Coming Soon',
                    style: TextStyle(
                      fontSize: ThemeConstants.bodyMediumFontSize,
                      fontWeight: FontWeight.w600,
                      color: ThemeConstants.onSurfaceVariantColor,
                    ),
                  ),
                  const SizedBox(height: ThemeConstants.spacing4),
                  Text(
                    'Detailed course structure will be available soon.',
                    style: TextStyle(
                      fontSize: ThemeConstants.bodySmallFontSize,
                      color: ThemeConstants.onSurfaceVariantColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInstructorTab(ProgramModel program) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(ThemeConstants.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: ThemeConstants.primaryColor.withValues(
                  alpha: 0.1,
                ),
                child: Text(
                  program.instructorName.isNotEmpty
                      ? program.instructorName[0].toUpperCase()
                      : 'I',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: ThemeConstants.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: ThemeConstants.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.instructorName,
                      style: const TextStyle(
                        fontSize: ThemeConstants.titleMediumFontSize,
                        fontWeight: FontWeight.w600,
                        color: ThemeConstants.onSurfaceColor,
                      ),
                    ),
                    const SizedBox(height: ThemeConstants.spacing4),
                    Text(
                      '${program.category} Expert',
                      style: TextStyle(
                        fontSize: ThemeConstants.bodyMediumFontSize,
                        color: ThemeConstants.onSurfaceVariantColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: ThemeConstants.spacing20),
          const Text(
            'About the Instructor',
            style: TextStyle(
              fontSize: ThemeConstants.bodyMediumFontSize,
              fontWeight: FontWeight.w600,
              color: ThemeConstants.onSurfaceColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.spacing8),
          Text(
            'Experienced ${program.category.toLowerCase()} professional with expertise in delivering comprehensive educational content. Passionate about helping students achieve their learning goals.',
            style: TextStyle(
              fontSize: ThemeConstants.bodyMediumFontSize,
              color: ThemeConstants.onSurfaceVariantColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Helper Methods
  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return ThemeConstants.successColor;
      case 'intermediate':
        return ThemeConstants.warningColor;
      case 'advanced':
        return ThemeConstants.errorColor;
      default:
        return ThemeConstants.primaryColor;
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }

  void _handleShare(BuildContext context, ProgramModel? program) {
    _showSnackBar(
      context,
      'Share feature coming soon!',
      ThemeConstants.infoColor,
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusSmall),
        ),
      ),
    );
  }

  Future<void> _handleEnrollment(
    BuildContext context,
    ProgramModel program,
    ProgramController programController,
  ) async {
    if (program.isEnrolled) {
      _showSnackBar(
        context,
        'Continue learning feature coming soon!',
        ThemeConstants.infoColor,
      );
      return;
    }

    setState(() {
      _isEnrollmentLoading = true;
    });

    try {
      await programController.enrollInProgram(program.id);
      if (mounted) {
        _showSnackBar(
          context,
          'Successfully enrolled in ${program.title}!',
          ThemeConstants.successColor,
        );
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(
          context,
          'Failed to enroll: ${e.toString()}',
          ThemeConstants.errorColor,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isEnrollmentLoading = false;
        });
      }
    }
  }
}
