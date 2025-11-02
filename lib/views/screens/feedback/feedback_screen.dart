import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/feedback_controller.dart';
import 'program_feedback_list_screen.dart';

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
  String? _selectedCategory;
  bool _isSubmitting = false;
  final int _maxCharacters = 500;
  final int _minCharacters = 20;

  // Feedback categories
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
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(position: _slideAnimation, child: _buildBody()),
      ),
    );
  }

  /// Build app bar with title
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Write a Review',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: const Color(0xFF1A1A1A),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.rate_review, color: Colors.white),
          tooltip: 'View All Reviews',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProgramFeedbackListScreen(
                  programId: widget.programId,
                  programTitle: widget.programTitle,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Build main body content
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Always show program info card
            _buildProgramInfo(),
            const SizedBox(height: 32),
            _buildRatingSection(),
            const SizedBox(height: 32),
            if (_selectedRating > 0) ...[
              _buildCategorySection(),
              const SizedBox(height: 32),
            ],
            _buildFeedbackSection(),
            const SizedBox(height: 32),
            _buildSubmitButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Build program information card
  Widget _buildProgramInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ThemeConstants.brandOrangeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.school, color: Color(0xFFFF6B6B), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Program Review',
                  style: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 12,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.programTitle ?? 'Program',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
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
  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How would you rate this program?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Center(child: _buildStarRating()),
        const SizedBox(height: 16),
        Center(
          child: Text(
            _getRatingLabel(_selectedRating),
            style: TextStyle(
              color: _selectedRating > 0
                  ? const Color(0xFFFF6B6B)
                  : const Color(0xFF666666),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  /// Build interactive star rating
  Widget _buildStarRating() {
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
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.1 : 1.0,
              child: Icon(
                isSelected ? Icons.star : Icons.star_border,
                color: isSelected
                    ? const Color(0xFFFF6B6B)
                    : const Color(0xFF4A4A4A),
                size: 48,
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

  /// Build feedback category dropdown section
  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Feedback Category',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select the area you want to provide feedback about',
          style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          dropdownColor: const Color(0xFF2A2A2A),
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Choose a category',
            hintStyle: const TextStyle(color: Color(0xFF666666), fontSize: 15),
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            prefixIcon: const Icon(
              Icons.category_outlined,
              color: Color(0xFFFF6B6B),
              size: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFFF6B6B),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          items: _feedbackCategories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategory = newValue;
            });
          },
          // Category is optional, so no validator needed
        ),
      ],
    );
  }

  /// Build feedback text section
  Widget _buildFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Share your experience',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tell us what you liked or what could be improved',
          style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _feedbackController,
          maxLines: 6,
          maxLength: _maxCharacters,
          decoration: InputDecoration(
            hintText: 'Write your feedback here...',
            hintStyle: const TextStyle(color: Color(0xFF666666), fontSize: 14),
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFFF6B6B),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFFF6B6B),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 2),
            ),
            counterStyle: const TextStyle(
              color: Color(0xFF999999),
              fontSize: 12,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please provide your feedback';
            }
            if (value.trim().length < _minCharacters) {
              return 'Feedback should be at least $_minCharacters characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Build submit button
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isSubmitting ? null : _handleSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF6B6B),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        disabledBackgroundColor: const Color(0xFF4A4A4A),
      ),
      child: _isSubmitting
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Submit Review',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
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

    try {
      // Get controllers
      final authController = Provider.of<AuthController>(
        context,
        listen: false,
      );
      final feedbackController = Provider.of<FeedbackController>(
        context,
        listen: false,
      );

      // Check if user is authenticated
      if (!authController.isAuthenticated ||
          authController.currentUser == null) {
        _showErrorMessage('You must be logged in to submit feedback');
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      final currentUser = authController.currentUser!;

      // Submit feedback through controller
      final success = await feedbackController.submitFeedback(
        userId: currentUser.id,
        userName: currentUser.name,
        userAvatar: currentUser.avatar,
        programId: widget.programId,
        programTitle: widget.programTitle ?? 'Program',
        rating: _selectedRating,
        comment: _feedbackController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        // Show submitted data dialog
        _showSubmittedDataDialog();

        // Show success message after dialog
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        _showSuccessMessage();

        // Navigate back after a delay
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        Navigator.of(context).pop();
      } else {
        // Show error from controller
        _showErrorMessage(
          feedbackController.error ?? 'Failed to submit feedback',
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
      _showErrorMessage('An error occurred: ${e.toString()}');
    }
  }

  /// Show dialog with submitted data
  void _showSubmittedDataDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF00C896), size: 28),
              SizedBox(width: 12),
              Text(
                'Feedback Submitted',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Your feedback has been recorded:',
                  style: TextStyle(color: Color(0xFF999999), fontSize: 14),
                ),
                const SizedBox(height: 16),
                _buildDataItem(
                  'Program',
                  widget.programTitle ?? 'Program',
                  Icons.school,
                ),
                const SizedBox(height: 12),
                _buildDataItem(
                  'Rating',
                  '$_selectedRating ${_selectedRating == 1 ? 'star' : 'stars'} - ${_getRatingLabel(_selectedRating)}',
                  Icons.star,
                ),
                const SizedBox(height: 12),
                _buildDataItem(
                  'Category',
                  _selectedCategory ?? 'Not specified',
                  Icons.category,
                ),
                const SizedBox(height: 12),
                _buildDataItem(
                  'Feedback',
                  _feedbackController.text.trim(),
                  Icons.comment,
                  isMultiline: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Color(0xFFFF6B6B),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Build a data item for the dialog
  Widget _buildDataItem(
    String label,
    String value,
    IconData icon, {
    bool isMultiline = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        crossAxisAlignment: isMultiline
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: const Color(0xFFFF6B6B)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  maxLines: isMultiline ? null : 2,
                  overflow: isMultiline ? null : TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Show error message
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFFF5757),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Show success message
  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Thank you! Feedback submitted.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF00C896),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
