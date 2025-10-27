import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/entities/program_model.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../widgets/common/app_bottom_navigation.dart';
import '../../../controllers/program_controller.dart';
import '../../../models/repositories/program_repository.dart';
import '../../../models/services/api_service.dart';
import '../../../models/services/storage_service.dart';

/// ─────────────────────────────────────────────────────────────
/// Program Detail Screen (MVC Architecture)
/// Model: ProgramModel
/// View:  This screen
/// Controller: ProgramController
/// Repository: ProgramRepository
/// Services: ApiService + StorageService
/// ─────────────────────────────────────────────────────────────
class ProgramDetailScreen extends StatefulWidget {
  final String programId;

  const ProgramDetailScreen({super.key, required this.programId});
  static const String routeName = '/program-detail';

  @override
  State<ProgramDetailScreen> createState() => _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends State<ProgramDetailScreen> {
  ProgramController? _programController;
  ProgramModel? _program;
  bool _isLoading = true;
  bool _isEnrollmentLoading = false;
  bool _isLiked = false;

  // Constants
  static const Color _primaryAccentColor = Color(0xFFF76169);
  static const double _iconSize = 18.0;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  /// Initialize storage and controller, then load program
  Future<void> _initializeServices() async {
    final storageService = await StorageService.getInstance();

    _programController = ProgramController(
      programRepository: ProgramRepository(
        apiService: ApiService(storageService: storageService),
        storageService: storageService,
      ),
    );

    await _loadProgramDetails();
  }

  /// Fetch program details by ID through the controller
  Future<void> _loadProgramDetails() async {
    if (_programController == null) return;

    // Debug: See what ID is being passed from navigation
    if (kDebugMode) {
      print("ProgramDetailScreen loading ID: ${widget.programId}");
    }

    final success = await _programController!.loadProgram(widget.programId);

    if (success) {
      //  Program found successfully
      if (kDebugMode) {
        print("Program loaded: ${_programController!.currentProgram?.title}");
      }
      setState(() {
        _program = _programController!.currentProgram;
        _isLoading = false;
      });
    } else {
      //  No program matched the ID
      if (kDebugMode) {
        print("No program found with ID: ${widget.programId}");
      }
      setState(() => _isLoading = false);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════
  // BUILD UI
  // ═══════════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_program == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Program Not Found")),
        body: const Center(child: Text("No program details available.")),
      );
    }

    final program = _program!;
    return Scaffold(
      backgroundColor: ThemeConstants.appBackgroundColor,
      appBar: _buildAppBar(context, program),
      body: _buildProgramContent(context, program),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 0,
        onTap: (index) => _handleBottomNavigation(context, index),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════════
  // APP BAR
  // ═══════════════════════════════════════════════════════════════════════════════

  PreferredSizeWidget _buildAppBar(BuildContext context, ProgramModel program) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: _iconSize,
        ),
        onPressed: () => _handleBackNavigation(context),
      ),
      title: Text(
        program.title,
        style: _buildContentTextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
            color: Colors.black,
            size: _iconSize,
          ),
          onPressed: () {
            setState(() => _isLiked = !_isLiked);
            _showSnackBar(
              context,
              _isLiked ? 'Liked' : 'Like removed',
              ThemeConstants.successColor,
            );
          },
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONTENT SECTIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  Widget _buildProgramContent(BuildContext context, ProgramModel program) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(ThemeConstants.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgramHeader(program),
          const SizedBox(height: ThemeConstants.spacing16),
          _buildDescription(program),
          const SizedBox(height: ThemeConstants.spacing16),
          _buildInternshipDetails(),
          const SizedBox(height: ThemeConstants.spacing16),
          _buildApplicationDeadlines(),
          const SizedBox(height: ThemeConstants.spacing16),
          _buildRewardsAndSkills(),
          const SizedBox(height: ThemeConstants.spacing16),
          _buildEnrollmentSection(context, program),
        ],
      ),
    );
  }

  Widget _buildProgramHeader(ProgramModel program) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.spacing20),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(ThemeConstants.spacing16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.schedule_outlined, size: 16),
                        const SizedBox(width: 6),
                        Text(program.duration),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.school_outlined, size: 16),
                        const SizedBox(width: 6),
                        Text(program.instructorName),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _handleApplyNavigation(context, program),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryAccentColor,
                ),
                child: const Text(
                  "Apply",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToFeedback(
    BuildContext context,
    String programId, {
    String? programTitle,
  }) {
    AppRoutes.toFeedback(context, programId, programTitle: programTitle);
  }

  Widget _buildDescription(ProgramModel program) {
    return _buildContentSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "About This Internship",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(program.description),
        ],
      ),
      width: double.infinity,
    );
  }

  Widget _buildInternshipDetails() {
    final outcomes = _program?.outcomes ?? [];
    return _buildContentSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What You’ll Learn",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...outcomes.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("• $e"),
            ),
          ),
        ],
      ),
      width: double.infinity,
    );
  }

  Widget _buildApplicationDeadlines() {
    return _buildContentSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Application Deadlines",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text("Early Application: February 15, 2024"),
          Text("Regular Application: March 15, 2024"),
          Text("Final Application: April 1, 2024"),
        ],
      ),
      width: double.infinity,
    );
  }

  Widget _buildRewardsAndSkills() {
    return _buildContentSection(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Rewards & Recognition",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text("• Certificate of Completion"),
          Text("• Real-world Project Experience"),
          Text("• Networking Opportunities"),
          Text("• Skill Development"),
        ],
      ),
    );
  }

  /*
  Widget _buildEnrollmentSection(BuildContext context, ProgramModel program) {
    return _buildContentSection(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _isEnrollmentLoading
                ? null
                : () => _handleApplyNavigation(context, program),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryAccentColor,
            ),
            child: _isEnrollmentLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Apply Now",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ],
      ), width: double.infinity,
    );
  } */
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
                  onPressed: () => _navigateToFeedback(
                    context,
                    program.id,
                    programTitle: program.title,
                  ),
                  icon: Icon(
                    Icons.rate_review_outlined,
                    size: 16,
                    color: _primaryAccentColor,
                  ),
                  label: Text(
                    'Feedback',
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

  // ═══════════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════════

  Widget _buildContentSection({required Widget child, required double width}) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  TextStyle _buildContentTextStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
  }

  void _handleBottomNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        AppRoutes.toPrograms(context);
        break;
      case 1:
        AppRoutes.toHome(context);
        break;
      case 2:
        AppRoutes.toProfile(context);
        break;
    }
  }

  void _handleBackNavigation(BuildContext context) {
    if (AppRoutes.canPop(context)) {
      AppRoutes.pop(context);
    } else {
      AppRoutes.toHome(context);
    }
  }

  void _handleApplyNavigation(
    BuildContext context,
    ProgramModel program,
  ) async {
    setState(() => _isEnrollmentLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isEnrollmentLoading = false);
    // ignore: use_build_context_synchronously
    _showSnackBar(
      // ignore: use_build_context_synchronously
      context,
      "Application submitted!",
      ThemeConstants.successColor,
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}
