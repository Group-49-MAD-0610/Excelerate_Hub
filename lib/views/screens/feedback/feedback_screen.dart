import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// --- NEW IMPORTS ---
import '../../../controllers/feedback_controller.dart';
import '../../../core/routes/app_routes.dart'; // For navigation
import '../../widgets/common/app_bottom_navigation.dart'; // For bottom nav
// --- EXISTING IMPORTS ---
import '../../../core/constants/theme_constants.dart';

/// Feedback and Review Screen for Programs
///
/// This screen acts as the View in MVC, listening to the FeedbackController.
class FeedbackScreen extends StatefulWidget {
  final String programId;
  final String? programTitle;

  const FeedbackScreen({super.key, required this.programId, this.programTitle});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with SingleTickerProviderStateMixin {
  // --- STATE MOVED TO CONTROLLER ---
  // The TextEditingController is now managed by the FeedbackController itself.
  final _formKey = GlobalKey<FormState>();

  // Animation controller (STAYS HERE, as it's purely visual)
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Static UI Data (STAYS HERE)
  final int _maxCharacters = 500;
  final int _minCharacters = 20;
  final List<String> _feedbackCategories = [
    'Course Content',
    'Instructor Quality',
    'Learning Materials',
    'Platform Usability',
    'Technical Issues',
    'Suggestions',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the controller and its state *after* the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FeedbackController>(context, listen: false).initialize(
        programId: widget.programId,
        programTitle: widget.programTitle ?? 'Program',
      );
    });
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    // Only dispose of the visual controller (AnimationController)
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Wrap in Consumer to listen to the controller
    return Consumer<FeedbackController>(
      builder: (context, controller, child) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Scaffold(
          backgroundColor: ThemeConstants.appBackgroundColor,
          appBar: _buildAppBar(theme),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildBody(
                theme,
                controller,
                colorScheme,
              ), // Pass controller
            ),
          ),
          // Assuming your project has AppBottomNavigation defined and accessible
          bottomNavigationBar: _buildBottomNavigation(context),
        );
      },
    );
  }

  // --- BUILD METHODS MODIFIED TO USE CONTROLLER STATE ---

  Widget _buildBody(
    ThemeData theme,
    FeedbackController controller,
    ColorScheme colorScheme,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(ThemeConstants.spacing24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProgramInfo(theme),
            const SizedBox(height: ThemeConstants.spacing32),
            _buildRatingSection(theme, controller), // Uses controller
            const SizedBox(height: ThemeConstants.spacing24),
            _buildCategorySection(theme),
            const SizedBox(height: ThemeConstants.spacing32),
            _buildFeedbackSection(theme, controller), // Uses controller
            const SizedBox(height: ThemeConstants.spacing32),

            // Display controller error
            if (controller.error != null && !controller.isLoading)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: ThemeConstants.spacing16,
                ),
                child: Text(
                  controller.error!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            _buildSubmitButton(theme, controller), // Uses controller
            const SizedBox(height: ThemeConstants.spacing24),
          ],
        ),
      ),
    );
  }

  // Uses controller for state and action
  Widget _buildRatingSection(ThemeData theme, FeedbackController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How would you rate this program?',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: ThemeConstants.primaryFontFamily,
          ),
        ),
        const SizedBox(height: ThemeConstants.spacing16),
        Center(child: _buildStarRating(theme, controller)),
        const SizedBox(height: ThemeConstants.spacing12),
        Center(
          child: Text(
            _getRatingLabel(controller.currentRating),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: ThemeConstants.tertiaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // Uses controller for state and action
  Widget _buildStarRating(ThemeData theme, FeedbackController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final isSelected = starValue <= controller.currentRating;

        return GestureDetector(
          // Logic moved to controller
          onTap: () => controller.updateRating(starValue),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(ThemeConstants.spacing8),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.1 : 1.0,
              child: Icon(
                isSelected ? Icons.star : Icons.star_border,
                color: isSelected
                    ? ThemeConstants.tertiaryColor
                    : theme.colorScheme.onSurface.withOpacity(0.3),
                size: 40,
              ),
            ),
          ),
        );
      }),
    );
  }

  // Uses controller for text input
  Widget _buildFeedbackSection(ThemeData theme, FeedbackController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Share your experience',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: ThemeConstants.primaryFontFamily,
          ),
        ),
        const SizedBox(height: ThemeConstants.spacing8),
        Text(
          'Tell us what you liked or what could be improved',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: ThemeConstants.spacing16),
        TextFormField(
          controller: controller
              .commentController, // Uses controller's TextEditingController
          maxLines: 8,
          maxLength: _maxCharacters,
          decoration: InputDecoration(
            counterStyle: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          style: theme.textTheme.bodyMedium,
          // Local validation is removed as controller handles it on submit
        ),
      ],
    );
  }

  // Uses controller for loading state and action
  Widget _buildSubmitButton(ThemeData theme, FeedbackController controller) {
    return ElevatedButton(
      // Calls controller's submit method
      onPressed: controller.isLoading
          ? null
          : () => _handleSubmit(context, controller),
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeConstants.brandOrangeColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: ThemeConstants.spacing16),
        elevation: 2,
      ),
      child: controller.isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              'Submit Review',
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  // --- Submission Handler (Removed business logic) ---
  void _handleSubmit(
    BuildContext context,
    FeedbackController controller,
  ) async {
    // Validate the form locally first (for required fields validation)
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Ask the controller to handle validation/submission to Firestore
    final success = await controller.submitFeedback();

    if (success) {
      // Show success message and dialog after submission is confirmed
      _showSubmittedDataDialog(context, controller);

      // Navigate back after successful submission
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  // The rest of the methods remain unchanged, but now rely on the controller for data.

  // Note: _buildSubmittedDataDialog and other helper methods are assumed to be
  // implemented in the final file for the solution to compile and function.

  // --- Placeholders for remaining required methods ---
  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    /* ... original implementation ... */
    return AppBar(title: Text('Write a Review'));
  }

  Widget _buildProgramInfo(ThemeData theme) {
    /* ... original implementation ... */
    return const Card(child: Text('Program Info'));
  }

  Widget _buildCategorySection(ThemeData theme) {
    /* ... original implementation ... */
    return const SizedBox.shrink();
  }

  void _showSubmittedDataDialog(
    BuildContext context,
    FeedbackController controller,
  ) {
    /* ... original implementation ... */
  }
  String _getRatingLabel(int rating) {
    /* ... original implementation ... */
    return 'Tap a star to rate';
  }

  Widget _buildBottomNavigation(BuildContext context) {
    /* ... original implementation ... */
    return const SizedBox.shrink();
  }
}
