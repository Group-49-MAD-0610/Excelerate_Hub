import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../entities/feedback_model.dart';
import '../services/api_service.dart';

/// Repository for feedback-related data operations
class FeedbackRepository {
  // In-memory storage for feedback (simulating persistent storage)
  static List<FeedbackModel> _feedbackCache = [];
  static bool _cacheInitialized = false;

  // File name for feedback data storage
  static const String _feedbackFileName = 'feedback.json';

  FeedbackRepository({required ApiService apiService});

  /// Initialize feedback cache from JSON file or assets
  Future<void> _initializeCache() async {
    if (_cacheInitialized) return;

    try {
      if (kDebugMode) {
        print('🔄 Initializing feedback cache...');
      }

      // Try to load from persistent storage first
      await _loadFeedbackFromStorage();

      // If no data in persistent storage, load from assets as initial seed data
      if (_feedbackCache.isEmpty) {
        try {
          if (kDebugMode) {
            print('📦 No existing feedback data, loading from assets...');
          }
          final jsonString = await rootBundle.loadString(
            'assets/data/feedback.json',
          );
          if (jsonString.isNotEmpty) {
            final List<dynamic> jsonData = json.decode(jsonString);
            _feedbackCache = jsonData
                .map((e) => FeedbackModel.fromJson(e))
                .toList();

            // Save the initial data to persistent storage for future use
            await _saveFeedbackToStorage();

            if (kDebugMode) {
              print(
                '✅ Loaded ${_feedbackCache.length} feedback items from assets and saved to storage',
              );
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('⚠️  No asset feedback file or empty: $e');
            print('ℹ️  Starting with empty feedback list');
          }
        }
      }

      _cacheInitialized = true;

      if (kDebugMode) {
        print(
          '✅ Feedback cache initialized with ${_feedbackCache.length} items',
        );
      }
    } catch (e) {
      _feedbackCache = [];
      _cacheInitialized = true;

      if (kDebugMode) {
        print('❌ Failed to initialize feedback cache: $e');
      }
    }
  }

  /// Get all feedback with optional filtering
  Future<List<FeedbackModel>> getFeedback({
    int page = 1,
    int limit = 10,
    String? programId,
    String? userId,
  }) async {
    try {
      await _initializeCache();

      var filteredFeedback = List<FeedbackModel>.from(_feedbackCache);

      // Filter by programId if provided
      if (programId != null) {
        filteredFeedback = filteredFeedback
            .where((feedback) => feedback.programId == programId)
            .toList();
      }

      // Filter by userId if provided
      if (userId != null) {
        filteredFeedback = filteredFeedback
            .where((feedback) => feedback.userId == userId)
            .toList();
      }

      // Sort by creation date (newest first)
      filteredFeedback.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Apply pagination
      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;

      if (startIndex >= filteredFeedback.length) {
        return [];
      }

      return filteredFeedback.sublist(
        startIndex,
        endIndex > filteredFeedback.length ? filteredFeedback.length : endIndex,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get feedback: $e');
      }
      throw Exception('Failed to get feedback: $e');
    }
  }

  /// Get feedback by ID
  Future<FeedbackModel?> getFeedbackById(String feedbackId) async {
    try {
      await _initializeCache();

      return _feedbackCache.firstWhere(
        (feedback) => feedback.id == feedbackId,
        orElse: () => throw Exception('Feedback not found'),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get feedback by ID: $e');
      }
      return null;
    }
  }

  /// Get feedback for a specific program
  Future<List<FeedbackModel>> getFeedbackByProgramId(String programId) async {
    try {
      await _initializeCache();

      final programFeedback = _feedbackCache
          .where((feedback) => feedback.programId == programId)
          .toList();

      // Sort by creation date (newest first)
      programFeedback.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return programFeedback;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get program feedback: $e');
      }
      throw Exception('Failed to get program feedback: $e');
    }
  }

  /// Get feedback by a specific user
  Future<List<FeedbackModel>> getFeedbackByUserId(String userId) async {
    try {
      await _initializeCache();

      final userFeedback = _feedbackCache
          .where((feedback) => feedback.userId == userId)
          .toList();

      // Sort by creation date (newest first)
      userFeedback.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return userFeedback;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get user feedback: $e');
      }
      throw Exception('Failed to get user feedback: $e');
    }
  }

  /// Create new feedback
  Future<FeedbackModel?> createFeedback({
    required String userId,
    required String userName,
    String? userAvatar,
    required String programId,
    required String programTitle,
    required int rating,
    required String comment,
  }) async {
    try {
      await _initializeCache();

      // Validate rating
      if (rating < 1 || rating > 5) {
        throw Exception('Rating must be between 1 and 5');
      }

      // Create new feedback
      final now = DateTime.now().toUtc();
      final feedback = FeedbackModel(
        id: 'feedback-${now.millisecondsSinceEpoch}',
        userId: userId,
        userName: userName,
        userAvatar: userAvatar,
        programId: programId,
        programTitle: programTitle,
        rating: rating,
        comment: comment,
        createdAt: now,
        updatedAt: now,
        isActive: true,
        helpfulUsers: const [],
        helpfulCount: 0,
      );

      // Add to cache
      _feedbackCache.add(feedback);

      // Save to storage
      await _saveFeedbackToStorage();

      if (kDebugMode) {
        print('Created feedback: ${feedback.id}');
      }

      return feedback;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to create feedback: $e');
      }
      throw Exception('Failed to create feedback: $e');
    }
  }

  /// Update existing feedback
  Future<FeedbackModel?> updateFeedback({
    required String feedbackId,
    int? rating,
    String? comment,
  }) async {
    try {
      await _initializeCache();

      final index = _feedbackCache.indexWhere((f) => f.id == feedbackId);
      if (index == -1) {
        throw Exception('Feedback not found');
      }

      final oldFeedback = _feedbackCache[index];
      final updatedFeedback = oldFeedback.copyWith(
        rating: rating ?? oldFeedback.rating,
        comment: comment ?? oldFeedback.comment,
        updatedAt: DateTime.now().toUtc(),
      );

      _feedbackCache[index] = updatedFeedback;

      // Save to storage
      await _saveFeedbackToStorage();

      if (kDebugMode) {
        print('Updated feedback: $feedbackId');
      }

      return updatedFeedback;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to update feedback: $e');
      }
      throw Exception('Failed to update feedback: $e');
    }
  }

  /// Delete feedback
  Future<bool> deleteFeedback(String feedbackId) async {
    try {
      await _initializeCache();

      final index = _feedbackCache.indexWhere((f) => f.id == feedbackId);
      if (index == -1) {
        throw Exception('Feedback not found');
      }

      _feedbackCache.removeAt(index);

      // Save to storage
      await _saveFeedbackToStorage();

      if (kDebugMode) {
        print('Deleted feedback: $feedbackId');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to delete feedback: $e');
      }
      throw Exception('Failed to delete feedback: $e');
    }
  }

  /// Mark feedback as helpful
  Future<FeedbackModel?> markAsHelpful({
    required String feedbackId,
    required String userId,
  }) async {
    try {
      await _initializeCache();

      final index = _feedbackCache.indexWhere((f) => f.id == feedbackId);
      if (index == -1) {
        throw Exception('Feedback not found');
      }

      final oldFeedback = _feedbackCache[index];
      final helpfulUsers = List<String>.from(oldFeedback.helpfulUsers);

      // Toggle helpful status
      if (helpfulUsers.contains(userId)) {
        helpfulUsers.remove(userId);
      } else {
        helpfulUsers.add(userId);
      }

      final updatedFeedback = oldFeedback.copyWith(
        helpfulUsers: helpfulUsers,
        helpfulCount: helpfulUsers.length,
        updatedAt: DateTime.now().toUtc(),
      );

      _feedbackCache[index] = updatedFeedback;

      // Save to storage
      await _saveFeedbackToStorage();

      return updatedFeedback;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to mark feedback as helpful: $e');
      }
      throw Exception('Failed to mark feedback as helpful: $e');
    }
  }

  /// Get average rating for a program
  Future<double> getAverageRating(String programId) async {
    try {
      await _initializeCache();

      final programFeedback = _feedbackCache
          .where((feedback) => feedback.programId == programId)
          .toList();

      if (programFeedback.isEmpty) {
        return 0.0;
      }

      final totalRating = programFeedback.fold<int>(
        0,
        (sum, feedback) => sum + feedback.rating,
      );

      return totalRating / programFeedback.length;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get average rating: $e');
      }
      return 0.0;
    }
  }

  /// Get rating distribution for a program
  Future<Map<int, int>> getRatingDistribution(String programId) async {
    try {
      await _initializeCache();

      final distribution = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

      final programFeedback = _feedbackCache
          .where((feedback) => feedback.programId == programId)
          .toList();

      for (final feedback in programFeedback) {
        distribution[feedback.rating] =
            (distribution[feedback.rating] ?? 0) + 1;
      }

      return distribution;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get rating distribution: $e');
      }
      return {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    }
  }

  /// Get the path to the feedback JSON file in the app's documents directory
  Future<String> _getFeedbackFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_feedbackFileName';
  }

  /// Save feedback to JSON file in app documents directory
  Future<void> _saveFeedbackToStorage() async {
    try {
      final feedbackJson = _feedbackCache.map((f) => f.toJson()).toList();
      final jsonString = const JsonEncoder.withIndent(
        '  ',
      ).convert(feedbackJson);

      // Save to app documents directory (primary storage)
      final filePath = await _getFeedbackFilePath();
      final file = File(filePath);

      // Create parent directories if they don't exist
      await file.parent.create(recursive: true);

      // Write the JSON string to the file
      await file.writeAsString(jsonString);

      if (kDebugMode) {
        print('✅ Saved ${_feedbackCache.length} feedback items to $filePath');
        print('📍 File location: $filePath');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to save feedback to file: $e');
      }
      // Don't throw error, as this is a background operation
    }
  }

  /// Load feedback from JSON file in app documents directory
  Future<void> _loadFeedbackFromStorage() async {
    try {
      final filePath = await _getFeedbackFilePath();
      final file = File(filePath);

      if (kDebugMode) {
        print('🔍 Looking for feedback file at: $filePath');
      }

      // Check if file exists
      if (await file.exists()) {
        final jsonString = await file.readAsString();

        if (jsonString.isNotEmpty) {
          final List<dynamic> jsonData = json.decode(jsonString);
          _feedbackCache = jsonData
              .map((e) => FeedbackModel.fromJson(e))
              .toList();

          if (kDebugMode) {
            print(
              '✅ Loaded ${_feedbackCache.length} feedback items from persistent storage',
            );
          }
        }
      } else {
        if (kDebugMode) {
          print('ℹ️  Feedback file does not exist yet at: $filePath');
          print('ℹ️  Will be created when first feedback is submitted');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to load feedback from file: $e');
      }
      // Continue with empty cache
    }
  }
}
