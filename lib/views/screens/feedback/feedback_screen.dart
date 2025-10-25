import 'package:excelerate/core/constants/theme_constants.dart';
import 'package:excelerate/controllers/feedback_controller.dart';
import 'package:excelerate/views/widgets/common/custom_button.dart';
import 'package:excelerate/views/widgets/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../widgets/common/app_bottom_navigation.dart';

/// Screen for users to submit feedback (rating and comments) for a program.
class FeedbackScreen extends StatefulWidget {
  /// The ID of the program this feedback is for. Needs to be passed in.
  final String programId;

  const FeedbackScreen({super.key, required this.programId});

  static const String routeName = '/feedback'; // Route name from AppRoutes

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  // Need a form key for validation.
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Need to initialize the controller after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Pass the programId to the controller so it knows what we're reviewing.
      Provider.of<FeedbackController>(
        context,
        listen: false,
      ).initialize(widget.programId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Using Consumer so the UI updates when controller state changes (like errors or loading).
    return Consumer<FeedbackController>(
      builder: (context, controller, child) {
        return Scaffold(
          // Use the existing AppBar setup.
          backgroundColor: ThemeConstants.appBackgroundColor,
          appBar: AppBar(
            title: const Text('Feedback'),
            backgroundColor: ThemeConstants.surfaceColor,
            foregroundColor: ThemeConstants.onSurfaceColor,
          ),
          // Main form content.
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(ThemeConstants.spacing16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'How would you rate this program?',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: ThemeConstants.spacing16),

                  // The star rating input.
                  _buildStarRating(controller),
                  const SizedBox(height: ThemeConstants.spacing24),

                  // The comment text field.
                  CustomTextField(
                    controller: controller.commentController,
                    label: 'Comments',
                    hint: 'Share your thoughts on the program...',
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: ThemeConstants.spacing16),

                  // Show validation errors here if the controller has one.
                  if (controller.error != null && !controller.isLoading)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: ThemeConstants.spacing8,
                      ),
                      child: Text(
                        controller.error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // The submit button.
                  CustomButton(
                    text: 'Submit Feedback',
                    isLoading: controller
                        .isLoading, // Show spinner on button if loading.
                    onPressed: () => _handleSubmit(context, controller),
                    isFullWidth: true,
                  ),
                  const SizedBox(height: ThemeConstants.spacing24),
                ],
              ),
            ),
          ),
          // Use the existing bottom navigation setup.
          bottomNavigationBar: AppBottomNavigation(
            currentIndex: 0, // Keep Programs highlighted as this is related.
            onTap: (index) => _handleBottomNavigation(context, index),
          ),
        );
      },
    );
  }

  /// Builds the row of 5 stars for rating input.
  Widget _buildStarRating(FeedbackController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final ratingValue = index + 1;
        return IconButton(
          icon: Icon(
            // Show filled star if rating is >= current index, otherwise border.
            controller.currentRating >= ratingValue
                ? Icons.star
                : Icons.star_border,
            color: ThemeConstants.tertiaryColor,
            size: ThemeConstants.iconSizeXLarge,
          ),
          // Tell the controller when the rating changes.
          onPressed: () => controller.updateRating(ratingValue),
        );
      }),
    );
  }

  /// What happens when the submit button is pressed.
  Future<void> _handleSubmit(
    BuildContext context,
    FeedbackController controller,
  ) async {
    // Close the keyboard first.
    FocusScope.of(context).unfocus();

    // Ask the controller to handle the submission logic.
    final success = await controller.submitFeedback();

    // Make sure the screen is still visible before showing messages/navigating.
    if (success && mounted) {
      // Show a success popup message.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback submitted successfully!'),
          backgroundColor: ThemeConstants.successColor,
        ),
      );
      // Go back after successful submission.
      Navigator.pop(context);
    }
    // If it fails, the controller should have set an error message that the UI will show.
  }

  /// Handles taps on the bottom navigation bar.
  void _handleBottomNavigation(BuildContext context, int index) {
    // Use the AppRoutes helpers for navigation consistency.
    switch (index) {
      case 0: // Programs
        // Maybe do nothing since we're already in a program-related screen?
        break;
      case 1: // Home
        AppRoutes.toHome(context);
        break;
      case 2: // Profile
        AppRoutes.toProfile(context);
        break;
    }
  }
}
