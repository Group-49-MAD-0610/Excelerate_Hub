import 'package:flutter/material.dart';
import '../../../core/constants/theme_constants.dart';

/// Feedback and Review Screen for Programs
///
/// This screen allows users to provide feedback and reviews for programs
/// with the following features:
/// - Animated star rating system (0-5 stars)
/// - Text feedback with character limit
/// - Smooth animations and transitions
/// - Theme-consistent UI design
/// - Form validation
class FeedbackScreen extends StatefulWidget {
  final String programId;
  final String? programTitle;

  const FeedbackScreen({super.key, required this.programId, this.programTitle});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with SingleTickerProviderStateMixin {
  // Controllers
  final _feedbackController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // State variables
  int _selectedRating = 0;
  bool _isSubmitting = false;
  final int _maxCharacters = 500;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  /// Initialize animations for smooth entrance
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
    _feedbackController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _buildBody(theme),
        ),
      ),
    );
  }

  /// Build app bar with title
  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      title: Text(
        'Write a Review',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// Build main body content
  Widget _buildBody(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(ThemeConstants.spacing24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProgramInfo(theme),
            const SizedBox(height: ThemeConstants.spacing32),
            _buildRatingSection(theme),
            const SizedBox(height: ThemeConstants.spacing32),
            _buildFeedbackSection(theme),
            const SizedBox(height: ThemeConstants.spacing32),
            _buildSubmitButton(theme),
            const SizedBox(height: ThemeConstants.spacing24),
          ],
        ),
      ),
    );
  }

  /// Build program information card
  Widget _buildProgramInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spacing16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spacing12),
            decoration: BoxDecoration(
              color: ThemeConstants.brandOrangeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                ThemeConstants.borderRadiusSmall,
              ),
            ),
            child: Icon(
              Icons.school,
              color: ThemeConstants.brandOrangeColor,
              size: ThemeConstants.iconSizeLarge,
            ),
          ),
          const SizedBox(width: ThemeConstants.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Program Review',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: ThemeConstants.spacing4),
                Text(
                  widget.programTitle ?? 'Program',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build rating section with animated stars
  Widget _buildRatingSection(ThemeData theme) {
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
        Center(child: _buildStarRating(theme)),
        const SizedBox(height: ThemeConstants.spacing12),
        Center(
          child: Text(
            _getRatingLabel(_selectedRating),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: ThemeConstants.brandOrangeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// Build interactive star rating
  Widget _buildStarRating(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final isSelected = starValue <= _selectedRating;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedRating = starValue;
            });
          },
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
                    ? ThemeConstants.brandOrangeColor
                    : theme.colorScheme.onSurface.withOpacity(0.3),
                size: 40,
              ),
            ),
          ),
        );
      }),
    );
  }

  /// Get rating label based on selected stars
  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return 'Tap a star to rate';
    }
  }

  /// Build feedback text section
  Widget _buildFeedbackSection(ThemeData theme) {
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
          controller: _feedbackController,
          maxLines: 8,
          maxLength: _maxCharacters,
          decoration: InputDecoration(
            hintText: 'Write your feedback here...',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
            filled: true,
            fillColor: theme.cardTheme.color,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ThemeConstants.borderRadiusMedium,
              ),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ThemeConstants.borderRadiusMedium,
              ),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ThemeConstants.borderRadiusMedium,
              ),
              borderSide: BorderSide(
                color: ThemeConstants.brandOrangeColor,
                width: 2,
              ),
            ),
            counterStyle: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          style: theme.textTheme.bodyMedium,
          validator: (value) {
            if (_selectedRating > 0 &&
                (value == null || value.trim().isEmpty)) {
              return 'Please provide some feedback about your rating';
            }
            if (value != null && value.trim().length < 10) {
              return 'Feedback should be at least 10 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Build submit button
  Widget _buildSubmitButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: _isSubmitting ? null : _handleSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeConstants.brandOrangeColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: ThemeConstants.spacing16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
        ),
        elevation: 2,
      ),
      child: _isSubmitting
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.onPrimary,
                ),
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

  /// Handle form submission
  void _handleSubmit() async {
    // Validate rating
    if (_selectedRating == 0) {
      _showErrorMessage('Please select a rating');
      return;
    }

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    // Show success message
    _showSuccessMessage();

    // Navigate back after a delay
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  /// Show error message
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: ThemeConstants.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusSmall),
        ),
      ),
    );
  }

  /// Show success message
  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: ThemeConstants.spacing12),
            Expanded(
              child: Text(
                'Thank you for your feedback!',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: ThemeConstants.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusSmall),
        ),
      ),
    );
  }
}
