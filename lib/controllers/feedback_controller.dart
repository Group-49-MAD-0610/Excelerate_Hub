import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import './base_controller.dart';
import '../models/entities/feedback_model.dart';

/// Manages the state, validation, and submission of the Feedback form to Firestore.
class FeedbackController extends BaseController {
  // --- State Variables ---

  // Stores the selected star rating (1-5).
  int _currentRating = 0;
  int get currentRating => _currentRating;

  // Handles the text for the comment box.
  final TextEditingController commentController = TextEditingController();

  // Info about the program we're reviewing.
  String _programId = '';
  String _programTitle = '';

  // Validation constant (setting minimum characters for quality)
  final int _minCharacters = 20;

  // --- Core Methods ---

  /// Sets up the controller when the screen opens.
  void initialize({required String programId, String programTitle = 'Course'}) {
    _programId = programId;
    _programTitle = programTitle;
    _currentRating = 0;
    commentController.clear();
    clearError();
    setLoading(false);
    safeNotifyListeners();
  }

  /// Updates the current rating selected by the user.
  void updateRating(int newRating) {
    if (newRating >= 1 && newRating <= 5) {
      _currentRating = newRating;
      clearError(); // Clear any error message when the user starts interacting
      safeNotifyListeners();
    }
  }

  /// Checks if the form is ready to be submitted.
  String? _validateForm() {
    // 1. Check if user is logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return 'You must be logged in to leave feedback.';
    }
    // 2. Check if a rating was selected
    if (_currentRating == 0) {
      return 'Please select a star rating.';
    }
    // 3. Check if the comment meets the minimum length
    if (commentController.text.trim().length < _minCharacters) {
      return 'Feedback must be at least $_minCharacters characters.';
    }
    return null;
  }

  /// Handles the submission logic to Firestore.
  Future<bool> submitFeedback() async {
    final validationError = _validateForm();
    if (validationError != null) {
      setError(validationError);
      safeNotifyListeners();
      return false;
    }

    final user = FirebaseAuth.instance.currentUser!;
    bool success = false;

    // Wrap submission in handleAsync to manage loading state
    await handleAsync(() async {
      // Create the FeedbackModel object
      final newFeedback = FeedbackModel(
        id: '', // Firestore will generate this
        userId: user.uid,
        userName: user.displayName ?? user.email!,
        userAvatar: user.photoURL,
        programId: _programId,
        programTitle: _programTitle,
        rating: _currentRating,
        comment: commentController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 1. Get the Firestore instance
      final db = FirebaseFirestore.instance;
      // 2. Send data to the 'feedback' collection
      await db.collection('feedback').add(newFeedback.toJson());

      if (kDebugMode) {
        print(
          'Feedback submitted successfully to Firestore for program: $_programTitle',
        );
      }
      success = true;
    });

    // Reset form on success
    if (success) {
      initialize(programId: _programId, programTitle: _programTitle);
    }

    safeNotifyListeners();
    return success;
  }

  // --- Cleanup ---
  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}
