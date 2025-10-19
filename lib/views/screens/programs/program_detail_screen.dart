import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/entities/program_model.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../widgets/common/app_bottom_navigation.dart';

/// Modern Program Details Screen following Figma design specifications
/// Implements Material Design 3 principles with enhanced UX patterns
///
/// This screen displays comprehensive program information including:
/// - Program overview with title, duration, and institution
/// - Detailed curriculum and learning objectives
/// - Application deadlines and requirements
/// - Rewards and recognition information
/// - Enrollment capabilities with loading states
class ProgramDetailScreen extends StatefulWidget {
  final String programId;

  const ProgramDetailScreen({super.key, required this.programId});
  static const String routeName = '/program-detail';

  @override
  State<ProgramDetailScreen> createState() => _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends State<ProgramDetailScreen> {
  // Constants
  static const Color _primaryAccentColor = Color(0xFFF76169);
  static const double _iconSize = 18.0;
  static const double _cardElevation = 4.0;
  static const double _titleVerticalMargin = 12.0;

  // State variables
  bool _isEnrollmentLoading = false;
  bool _isLiked = false;

  // ═══════════════════════════════════════════════════════════════════════════════
  // MAIN BUILD METHOD
  // ═══════════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final program = _getDummyProgram();

    return Scaffold(
      backgroundColor: ThemeConstants.appBackgroundColor,
      appBar: _buildAppBar(context, program),
      body: _buildProgramContent(context, program),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 0, // Programs tab
        onTap: (index) => _handleBottomNavigation(context, index),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════════
  // DATA METHODS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Creates dummy program data for Machine Learning program
  ///
  /// This method provides mock data that matches the Figma design specifications
  /// for the Machine Learning internship program. In production, this would be
  /// replaced with actual API calls or database queries.
  ///
  /// Returns a [ProgramModel] with complete program information including
  /// curriculum, deadlines, and instructor details.
  ProgramModel _getDummyProgram() {
    final now = DateTime.now();
    return ProgramModel(
      id: 'ml-program-001',
      title: 'Machine Learning',
      description:
          'Want to experience what it\'s like to manage projects in the real world? In this internship, you\'ll work as a project management trainee, guiding a project from initial planning through to delivery.',
      category: 'Business & Management',
      level: '',
      duration: '4 weeks',
      price: 0.0,
      rating: 0.0,
      reviewCount: 0,
      enrollmentCount: 15847,
      instructorId: 'instructor-slu',
      instructorName: 'St. Louis University',
      instructorAvatar: '',
      isEnrolled: false,
      progress: null,
      createdAt: now.subtract(const Duration(days: 15)),
      updatedAt: now,
      isFree: true,
      outcomes: [
        'Define goals and create a project charter',
        'Develop a detailed schedule with milestones and Gantt charts',
        'Identify stakeholders, resources, and communication needs',
        'Solve real-world challenges such as low engagement and participation',
        'Deliver a final project proposal and team presentation',
        'Gain hands-on experience in project planning, scheduling, communication, and problem-solving',
      ],
      curriculum: [
        CurriculumWeek(
          week: 1,
          title: 'Project Planning & Charter Development',
          description:
              'Define project goals, create a comprehensive project charter, and establish foundation for successful project execution',
        ),
        CurriculumWeek(
          week: 2,
          title: 'Scheduling & Milestone Planning',
          description:
              'Develop detailed project schedules with milestones and create Gantt charts for visual project tracking',
        ),
        CurriculumWeek(
          week: 3,
          title: 'Stakeholder & Resource Management',
          description:
              'Identify key stakeholders, allocate resources effectively, and establish communication protocols',
        ),
        CurriculumWeek(
          week: 4,
          title: 'Problem-Solving & Final Delivery',
          description:
              'Address real-world challenges like low engagement, finalize project proposal, and deliver team presentation',
        ),
      ],
      tags: [
        'Remote',
        'Virtual',
        'Project Management',
        'Internship',
        'Scholarship',
        'Certificate',
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════════
  // UI BUILDING METHODS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Builds the custom app bar with navigation and action buttons
  ///
  /// Features:
  /// - Back navigation button with shadow
  /// - Centered program title  /// Builds the custom app bar with navigation and action buttons
  ///
  /// Features:
  /// - Back navigation button with black icons
  /// - Centered program title
  /// - Like/Unlike functionality button
  /// - White background with proper elevation
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ProgramModel? program,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      toolbarHeight: kToolbarHeight,
      leading: Center(
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: _iconSize,
          ),
          onPressed: () => _handleBackNavigation(context),
        ),
      ),
      title: Container(
        margin: const EdgeInsets.symmetric(vertical: _titleVerticalMargin),
        child: Center(
          child: Text(
            program?.title ?? 'Program Details',
            style: _buildContentTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      centerTitle: true,
      titleSpacing: 0,
      actions: [
        Center(
          child: IconButton(
            icon: Icon(
              _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
              color: Colors.black,
              size: _iconSize,
            ),
            onPressed: () {
              setState(() {
                _isLiked = !_isLiked;
              });
              _showSnackBar(
                context,
                _isLiked ? 'Liked' : 'Like removed',
                ThemeConstants.successColor,
              );
            },
          ),
        ),
      ],
    );
  }

  /// Builds the program information card header
  ///
  /// Contains:
  /// - Program title with highlighted background
  /// - Duration with clock icon
  /// - Institution with school icon
  /// - Apply button with primary action styling
  Widget _buildProgramHeader(ProgramModel program) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Program Meta Info and Apply Button Card
          Card(
            elevation: _cardElevation,
            shadowColor: Colors.black.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                ThemeConstants.borderRadiusMedium,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(ThemeConstants.spacing16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Program Title
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            program.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: ThemeConstants.spacing12),
                        // Duration
                        Row(
                          children: [
                            Icon(
                              Icons.schedule_outlined,
                              size: 16,
                              color: _primaryAccentColor,
                            ),
                            const SizedBox(width: ThemeConstants.spacing4),
                            Text(
                              program.duration,
                              style: _buildContentTextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: ThemeConstants.spacing8),
                        // Instructor - Clickable
                        GestureDetector(
                          onTap: () => _navigateToInstructorProfile(
                            context,
                            program.instructorId,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.school_outlined,
                                size: 16,
                                color: _primaryAccentColor,
                              ),
                              const SizedBox(width: ThemeConstants.spacing4),
                              Text(
                                program.instructorName,
                                style: _buildContentTextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: _primaryAccentColor,
                                ),
                              ),
                              const SizedBox(width: ThemeConstants.spacing4),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: _primaryAccentColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Apply Button
                  ElevatedButton(
                    onPressed: () => _handleApplyNavigation(context, program),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryAccentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.spacing20,
                        vertical: ThemeConstants.spacing12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ThemeConstants.borderRadiusMedium,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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

  Widget _buildProgramContent(BuildContext context, ProgramModel program) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(ThemeConstants.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Program Header
          _buildProgramHeader(program),
          const SizedBox(height: ThemeConstants.spacing16),

          // Description
          _buildDescription(program),
          const SizedBox(height: ThemeConstants.spacing16),

          // Internship Details
          _buildInternshipDetails(),
          const SizedBox(height: ThemeConstants.spacing16),

          // Application Deadlines
          _buildApplicationDeadlines(),
          const SizedBox(height: ThemeConstants.spacing16),

          // Rewards & Skills
          _buildRewardsAndSkills(),
          const SizedBox(height: ThemeConstants.spacing16),

          // Enrollment Section
          _buildEnrollmentSection(context, program),
          const SizedBox(height: ThemeConstants.spacing24),
        ],
      ),
    );
  }

  // Hero section removed — replaced by a simple header in the slivers above.

  /// Builds the program description section
  ///
  /// Features:
  /// - Centered section title
  /// - Left-aligned description text
  /// - White background container with rounded corners
  Widget _buildDescription(ProgramModel program) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.spacing20),
      padding: const EdgeInsets.all(ThemeConstants.spacing20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About This Internship',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: ThemeConstants.spacing12),
          Text(
            program.description,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              color: Colors.black,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInternshipDetails() {
    return _buildContentSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What You\'ll Learn',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: ThemeConstants.spacing16),
          ...[
            'Define goals and create a project charter',
            'Develop a detailed schedule with milestones and Gantt charts',
            'Identify stakeholders, resources, and communication needs',
            'Solve real-world challenges such as low engagement and participation',
            'Deliver a final project proposal and team presentation',
            'Gain hands-on experience in project planning, scheduling, communication, and problem-solving',
          ].map(
            (outcome) => Padding(
              padding: const EdgeInsets.only(bottom: ThemeConstants.spacing12),
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: ThemeConstants.spacing16),
          // View Detailed Curriculum Button
          Center(
            child: OutlinedButton.icon(
              onPressed: () =>
                  _navigateToCurriculum(context, _getDummyProgram()),
              icon: Icon(
                Icons.visibility_outlined,
                size: 16,
                color: _primaryAccentColor,
              ),
              label: Text(
                'View Detailed Curriculum',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: _primaryAccentColor,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: _primaryAccentColor, width: 1.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.spacing16,
                  vertical: ThemeConstants.spacing8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ThemeConstants.borderRadiusMedium,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationDeadlines() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.spacing20),
      padding: const EdgeInsets.all(ThemeConstants.spacing20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                color: ThemeConstants.warningColor,
                size: 20,
              ),
              const SizedBox(width: ThemeConstants.spacing8),
              const Text(
                'Application Deadlines',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: ThemeConstants.spacing12),
          _buildDeadlineItem('Early Application', 'February 15, 2024', true),
          _buildDeadlineItem('Regular Application', 'March 15, 2024', false),
          _buildDeadlineItem('Final Application', 'April 1, 2024', false),
        ],
      ),
    );
  }

  Widget _buildDeadlineItem(String title, String date, bool isHighlighted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ThemeConstants.spacing8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            date,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsAndSkills() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.spacing20),
      padding: const EdgeInsets.all(ThemeConstants.spacing20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rewards & Recognition',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: ThemeConstants.spacing16),
          Row(
            children: [
              Expanded(
                child: _buildRewardCard(
                  Icons.card_giftcard_rounded,
                  'Scholarship',
                  'Up to \$2,000',
                  ThemeConstants.successColor,
                ),
              ),
              const SizedBox(width: ThemeConstants.spacing12),
              Expanded(
                child: _buildRewardCard(
                  Icons.workspace_premium_rounded,
                  'Certificate',
                  'Completion',
                  ThemeConstants.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: ThemeConstants.spacing12),
          Row(
            children: [
              Expanded(
                child: _buildRewardCard(
                  Icons.business_center_rounded,
                  'Experience',
                  'Real Project',
                  ThemeConstants.infoColor,
                ),
              ),
              const SizedBox(width: ThemeConstants.spacing12),
              Expanded(
                child: _buildRewardCard(
                  Icons.groups_rounded,
                  'Networking',
                  'Industry Connect',
                  ThemeConstants.warningColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spacing16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: ThemeConstants.spacing8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ThemeConstants.spacing4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentSection(BuildContext context, ProgramModel program) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.spacing20),
      padding: const EdgeInsets.all(ThemeConstants.spacing24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Price and enrollment info
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apply Now',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: ThemeConstants.spacing4),
                    Text(
                      'Early Application Open',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: ThemeConstants.spacing20),

          // Apply Button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _isEnrollmentLoading
                  ? null
                  : () => _handleApplyNavigation(context, program),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryAccentColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ThemeConstants.borderRadiusMedium,
                  ),
                ),
              ),
              child: _isEnrollmentLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      program.isEnrolled
                          ? 'Continue Internship'
                          : 'Apply for Internship',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: ThemeConstants.spacing16),

          // Additional Action Buttons Row
          Row(
            children: [
              // Feedback Button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _navigateToFeedback(context, program.id),
                  icon: Icon(
                    Icons.rate_review_outlined,
                    size: 16,
                    color: _primaryAccentColor,
                  ),
                  label: Text(
                    'Reviews',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: _primaryAccentColor,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: _primaryAccentColor.withValues(alpha: 0.3),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: ThemeConstants.spacing12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ThemeConstants.borderRadiusMedium,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: ThemeConstants.spacing12),

              // Share Button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _handleShare(context, program),
                  icon: Icon(
                    Icons.share_outlined,
                    size: 16,
                    color: _primaryAccentColor,
                  ),
                  label: Text(
                    'Share',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: _primaryAccentColor,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: _primaryAccentColor.withValues(alpha: 0.3),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: ThemeConstants.spacing12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ThemeConstants.borderRadiusMedium,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Methods
  // ═══════════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Creates standardized text style for general content
  TextStyle _buildContentTextStyle({
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: 'Poppins',
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// Creates a standardized white content section container
  Widget _buildContentSection({
    required Widget child,
    EdgeInsets? margin,
    EdgeInsets? padding,
  }) {
    return Container(
      margin:
          margin ??
          const EdgeInsets.symmetric(horizontal: ThemeConstants.spacing20),
      padding: padding ?? const EdgeInsets.all(ThemeConstants.spacing20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
      ),
      child: child,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════════
  // NAVIGATION METHODS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Handles bottom navigation bar tap events using centralized navigation
  ///
  /// Features:
  /// - Routes to appropriate screens using AppRoutes
  /// - Maintains navigation consistency across the app
  /// - Uses centralized navigation system
  void _handleBottomNavigation(BuildContext context, int index) {
    switch (index) {
      case 0: // Programs
        AppRoutes.toPrograms(context);
        break;
      case 1: // Home
        AppRoutes.toHome(context);
        break;
      case 2: // Profile
        AppRoutes.toProfile(context);
        break;
    }
  }

  /// Handles back navigation with proper route management
  ///
  /// Features:
  /// - Checks if navigation stack allows popping
  /// - Fallback navigation to home screen if no previous route
  /// - Proper route cleanup
  void _handleBackNavigation(BuildContext context) {
    if (AppRoutes.canPop(context)) {
      AppRoutes.pop(context);
    } else {
      // If no previous route, navigate to home
      AppRoutes.toHome(context);
    }
  }

  /// Handles Apply button navigation to enrollment/application screen
  ///
  /// Features:
  /// - Navigates to appropriate application form
  /// - Passes program information as arguments
  /// - Handles different program states (enrolled vs. new application)
  void _handleApplyNavigation(BuildContext context, ProgramModel program) {
    if (program.isEnrolled) {
      // Navigate to program dashboard/continue learning
      _showSnackBar(
        context,
        'Continue learning feature coming soon!',
        ThemeConstants.infoColor,
      );
    } else {
      // For now, show enrollment flow - in production this would navigate to application form
      _handleEnrollment(context, program);
    }
  }

  /// Navigate to instructor profile screen
  ///
  /// Features:
  /// - Passes instructor ID for profile loading
  /// - Handles navigation to instructor details
  void _navigateToInstructorProfile(BuildContext context, String instructorId) {
    // TODO: Implement navigation to instructor profile screen
    _showSnackBar(
      context,
      'Instructor profile coming soon!',
      ThemeConstants.infoColor,
    );
  }

  /// Navigate to program curriculum detailed view
  ///
  /// Features:
  /// - Opens detailed curriculum breakdown
  /// - Allows deeper dive into course content
  void _navigateToCurriculum(BuildContext context, ProgramModel program) {
    // TODO: Implement navigation to detailed curriculum screen
    _showSnackBar(
      context,
      'Detailed curriculum coming soon!',
      ThemeConstants.infoColor,
    );
  }

  /// Navigate to feedback/review screen
  ///
  /// Features:
  /// - Opens program feedback form
  /// - Allows users to submit reviews
  void _navigateToFeedback(BuildContext context, String programId) {
    AppRoutes.toFeedback(context, programId);
  }

  // ═══════════════════════════════════════════════════════════════════════════════
  // EVENT HANDLERS & UTILITY METHODS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Shows a styled SnackBar with the given message and color
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

  /// Handles sharing program information
  ///
  /// Features:
  /// - Share program details via system share sheet
  /// - Formats program information for sharing
  /// - Fallback message for development
  void _handleShare(BuildContext context, ProgramModel program) {
    // TODO: Implement actual sharing functionality
    _showSnackBar(
      context,
      'Share feature coming soon! You can share "${program.title}" with others.',
      ThemeConstants.infoColor,
    );
  }

  /// Handles enrollment button press with loading state management
  ///
  /// Features:
  /// - Loading state indication
  /// - Success feedback via SnackBar
  /// - Simulated API call with delay
  /// - Error handling (to be implemented)
  Future<void> _handleEnrollment(
    BuildContext context,
    ProgramModel program,
  ) async {
    if (program.isEnrolled) {
      _showSnackBar(
        context,
        'Continue internship feature coming soon!',
        ThemeConstants.infoColor,
      );
      return;
    }

    setState(() {
      _isEnrollmentLoading = true;
    });

    // Simulate application process with dummy data
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isEnrollmentLoading = false;
      });

      // Use a post-frame callback to safely show the snackbar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showSnackBar(
            context,
            'Application submitted successfully for ${program.title}!',
            ThemeConstants.successColor,
          );
        }
      });
    }
  }
}
