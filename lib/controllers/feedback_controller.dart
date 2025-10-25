import 'package:flutter/material.dart';
import './base_controller.dart';
import '../models/entities/feedback_model.dart'; // Make sure this model is imported

/// This controller handles everything for the feedback form.
/// It keeps track of the rating and comment, validates the input,
/// and handles the submission process.
class FeedbackController extends BaseController {
  // --- State ---

  // Stores the selected star rating (1-5). 0 means nothing selected.
  int _currentRating = 0;
  int get currentRating => _currentRating;

  // Handles the text typed into the comment box.
  final TextEditingController commentController = TextEditingController();

  // Need to know which program this feedback is for.
  String _programId = '';

  // --- Core Methods ---

  /// Sets up the controller when the feedback screen is opened.
  /// Needs the [programId] to know which program is being reviewed.
  void initialize(String programId) {
    _programId = programId;
    _currentRating = 0; // Reset rating when screen loads
    commentController.clear(); // Clear any old comments
    clearError(); // Clear previous submission errors
    setLoading(false); // Make sure we are not in loading state
  }

  /// Called when the user taps on a star rating.
  /// Updates the internal state and tells the UI to rebuild.
  void updateRating(int newRating) {
    // Only accept valid ratings (1 to 5 stars)
    if (newRating >= 1 && newRating <= 5) {
      _currentRating = newRating;
      safeNotifyListeners(); // Update the UI to show the selected stars
    }
  }

  /// Checks if the form is ready to be submitted.
  /// Returns an error message if something is missing, or null if all good.
  String? validateForm() {
    if (_currentRating == 0) {
      return 'Please select a rating.'; // Make sure a star rating was chosen
    }
    if (commentController.text.trim().isEmpty) {
      return 'Please enter your comments.'; // Make sure comment is not empty
    }
    // Could add more checks here later, like minimum comment length.
    return null; // Looks good!
  }

  /// Called when the user presses the 'Submit' button.
  /// Validates the form, creates the data model, simulates sending it,
  /// and gives feedback to the user.
  /// Returns true if submission was successful, false otherwise.
  Future<bool> submitFeedback() async {
    // First, check if rating and comment are provided.
    final validationError = validateForm();
    if (validationError != null) {
      setError(validationError); // Store the error message
      safeNotifyListeners(); // Tell the UI to show the error
      return false; // Stop submission
    }

    bool success = false;
    // Use the handleAsync wrapper to show loading spinner during submission
    // and catch basic errors.
    await handleAsync(() async {
      // Create the data object using the current state.
      // For now, I'll use placeholders for user ID/name.
      final newFeedback = FeedbackModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Temp ID
        userId: 'temp_user_id', // Placeholder - get from auth later
        userName: 'Temp User', // Placeholder - get from auth later
        programId: _programId,
        programTitle: 'Fetched Program Title', // Placeholder - get later
        rating: _currentRating,
        comment: commentController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Simulate sending this data to the backend.
      print('--- Submitting Feedback (Week 3 Simulation) ---');
      print(newFeedback.toJson()); // Log the data we would send

      await Future.delayed(const Duration(seconds: 1)); // Simulate network time

      print('--- Submission Successful ---');
      success = true; // Mark as successful for this simulation

      // If this was a real API call, I'd add error handling here.
      // catch (e) {
      //   setError('Failed to submit. Please try again.');
      //   success = false;
      // }
    }); // handleAsync sets loading back to false

    // If it worked, clear the form for the next time.
    if (success) {
      _currentRating = 0;
      commentController.clear();
      clearError(); // Clear any previous validation errors
    }

    // Tell the UI to update (either clear fields or show error).
    safeNotifyListeners();

    return success; // Let the UI know if it succeeded
  }

  // --- Cleanup ---
  @override
  void dispose() {
    // Need to dispose the TextEditingController to prevent memory leaks.
    commentController.dispose();
    super.dispose();
  }
}