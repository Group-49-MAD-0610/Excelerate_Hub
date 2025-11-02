import 'package:flutter/foundation.dart';
import '../models/entities/feedback_model.dart';
import '../models/repositories/feedback_repository.dart';
import 'base_controller.dart';

/// Controller for feedback-related operations and state management
class FeedbackController extends BaseController {
  final FeedbackRepository _feedbackRepository;

  FeedbackController({required FeedbackRepository feedbackRepository})
    : _feedbackRepository = feedbackRepository;

  // State variables
  List<FeedbackModel> _feedbackList = [];
  List<FeedbackModel> _programFeedback = [];
  FeedbackModel? _currentFeedback;
  double _averageRating = 0.0;
  Map<int, int> _ratingDistribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

  // Getters
  List<FeedbackModel> get feedbackList => _feedbackList;
  List<FeedbackModel> get programFeedback => _programFeedback;
  FeedbackModel? get currentFeedback => _currentFeedback;
  double get averageRating => _averageRating;
  Map<int, int> get ratingDistribution => _ratingDistribution;

  /// Load all feedback
  Future<void> loadAllFeedback({int page = 1, int limit = 10}) async {
    try {
      setLoading(true);
      clearError();

      _feedbackList = await _feedbackRepository.getFeedback(
        page: page,
        limit: limit,
      );

      notifyListeners();

      if (kDebugMode) {
        print('Loaded ${_feedbackList.length} feedback items');
      }
    } catch (e) {
      setError('Failed to load feedback: ${e.toString()}');
      if (kDebugMode) {
        print('Error loading feedback: $e');
      }
    } finally {
      setLoading(false);
    }
  }

  /// Load feedback for a specific program
  Future<void> loadProgramFeedback(String programId) async {
    try {
      setLoading(true);
      clearError();

      _programFeedback = await _feedbackRepository.getFeedbackByProgramId(
        programId,
      );

      // Load statistics
      _averageRating = await _feedbackRepository.getAverageRating(programId);
      _ratingDistribution = await _feedbackRepository.getRatingDistribution(
        programId,
      );

      notifyListeners();

      if (kDebugMode) {
        print(
          'Loaded ${_programFeedback.length} feedback items for program $programId',
        );
        print('Average rating: $_averageRating');
      }
    } catch (e) {
      setError('Failed to load program feedback: ${e.toString()}');
      if (kDebugMode) {
        print('Error loading program feedback: $e');
      }
    } finally {
      setLoading(false);
    }
  }

  /// Load feedback by a specific user
  Future<void> loadUserFeedback(String userId) async {
    try {
      setLoading(true);
      clearError();

      _feedbackList = await _feedbackRepository.getFeedbackByUserId(userId);

      notifyListeners();

      if (kDebugMode) {
        print('Loaded ${_feedbackList.length} feedback items for user $userId');
      }
    } catch (e) {
      setError('Failed to load user feedback: ${e.toString()}');
      if (kDebugMode) {
        print('Error loading user feedback: $e');
      }
    } finally {
      setLoading(false);
    }
  }

  /// Submit new feedback
  Future<bool> submitFeedback({
    required String userId,
    required String userName,
    String? userAvatar,
    required String programId,
    required String programTitle,
    required int rating,
    required String comment,
  }) async {
    try {
      setLoading(true);
      clearError();

      // Validate inputs
      if (rating < 1 || rating > 5) {
        setError('Rating must be between 1 and 5');
        return false;
      }

      if (comment.trim().isEmpty) {
        setError('Comment cannot be empty');
        return false;
      }

      if (comment.trim().length < 20) {
        setError('Comment must be at least 20 characters');
        return false;
      }

      // Create feedback
      final feedback = await _feedbackRepository.createFeedback(
        userId: userId,
        userName: userName,
        userAvatar: userAvatar,
        programId: programId,
        programTitle: programTitle,
        rating: rating,
        comment: comment,
      );

      if (feedback != null) {
        _currentFeedback = feedback;

        // Refresh program feedback if we're viewing the same program
        if (_programFeedback.isNotEmpty &&
            _programFeedback.first.programId == programId) {
          await loadProgramFeedback(programId);
        }

        notifyListeners();

        if (kDebugMode) {
          print('Submitted feedback: ${feedback.id}');
        }

        return true;
      } else {
        setError('Failed to submit feedback');
        return false;
      }
    } catch (e) {
      setError('Failed to submit feedback: ${e.toString()}');
      if (kDebugMode) {
        print('Error submitting feedback: $e');
      }
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Update existing feedback
  Future<bool> updateFeedback({
    required String feedbackId,
    int? rating,
    String? comment,
  }) async {
    try {
      setLoading(true);
      clearError();

      // Validate inputs
      if (rating != null && (rating < 1 || rating > 5)) {
        setError('Rating must be between 1 and 5');
        return false;
      }

      if (comment != null && comment.trim().isEmpty) {
        setError('Comment cannot be empty');
        return false;
      }

      if (comment != null && comment.trim().length < 20) {
        setError('Comment must be at least 20 characters');
        return false;
      }

      final updatedFeedback = await _feedbackRepository.updateFeedback(
        feedbackId: feedbackId,
        rating: rating,
        comment: comment,
      );

      if (updatedFeedback != null) {
        _currentFeedback = updatedFeedback;

        // Update in lists
        final index = _feedbackList.indexWhere((f) => f.id == feedbackId);
        if (index != -1) {
          _feedbackList[index] = updatedFeedback;
        }

        final programIndex = _programFeedback.indexWhere(
          (f) => f.id == feedbackId,
        );
        if (programIndex != -1) {
          _programFeedback[programIndex] = updatedFeedback;
        }

        notifyListeners();

        if (kDebugMode) {
          print('Updated feedback: $feedbackId');
        }

        return true;
      } else {
        setError('Failed to update feedback');
        return false;
      }
    } catch (e) {
      setError('Failed to update feedback: ${e.toString()}');
      if (kDebugMode) {
        print('Error updating feedback: $e');
      }
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Delete feedback
  Future<bool> deleteFeedback(String feedbackId) async {
    try {
      setLoading(true);
      clearError();

      final success = await _feedbackRepository.deleteFeedback(feedbackId);

      if (success) {
        // Remove from lists
        _feedbackList.removeWhere((f) => f.id == feedbackId);
        _programFeedback.removeWhere((f) => f.id == feedbackId);

        if (_currentFeedback?.id == feedbackId) {
          _currentFeedback = null;
        }

        notifyListeners();

        if (kDebugMode) {
          print('Deleted feedback: $feedbackId');
        }

        return true;
      } else {
        setError('Failed to delete feedback');
        return false;
      }
    } catch (e) {
      setError('Failed to delete feedback: ${e.toString()}');
      if (kDebugMode) {
        print('Error deleting feedback: $e');
      }
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Mark feedback as helpful
  Future<bool> toggleHelpful({
    required String feedbackId,
    required String userId,
  }) async {
    try {
      final updatedFeedback = await _feedbackRepository.markAsHelpful(
        feedbackId: feedbackId,
        userId: userId,
      );

      if (updatedFeedback != null) {
        // Update in lists
        final index = _feedbackList.indexWhere((f) => f.id == feedbackId);
        if (index != -1) {
          _feedbackList[index] = updatedFeedback;
        }

        final programIndex = _programFeedback.indexWhere(
          (f) => f.id == feedbackId,
        );
        if (programIndex != -1) {
          _programFeedback[programIndex] = updatedFeedback;
        }

        if (_currentFeedback?.id == feedbackId) {
          _currentFeedback = updatedFeedback;
        }

        notifyListeners();

        if (kDebugMode) {
          print('Toggled helpful for feedback: $feedbackId');
        }

        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling helpful: $e');
      }
      return false;
    }
  }

  /// Get feedback by ID
  Future<FeedbackModel?> getFeedbackById(String feedbackId) async {
    try {
      setLoading(true);
      clearError();

      _currentFeedback = await _feedbackRepository.getFeedbackById(feedbackId);

      notifyListeners();

      return _currentFeedback;
    } catch (e) {
      setError('Failed to get feedback: ${e.toString()}');
      if (kDebugMode) {
        print('Error getting feedback: $e');
      }
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Clear current feedback
  void clearCurrentFeedback() {
    _currentFeedback = null;
    notifyListeners();
  }

  /// Refresh program feedback and statistics
  Future<void> refreshProgramFeedback(String programId) async {
    await loadProgramFeedback(programId);
  }
}
