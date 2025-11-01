import '../entities/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

/// Repository for user-related data operations
class UserRepository {
  final ApiService _apiService;
  final StorageService _storageService;

  UserRepository({
    required ApiService apiService,
    required StorageService storageService,
  }) : _apiService = apiService,
       _storageService = storageService;

  /// Get current user profile
  Future<UserModel?> getCurrentUser() async {
    try {
      // First try to get from local storage
      final userData = await _storageService.getUserData();
      if (userData != null) {
        return UserModel.fromJson(userData);
      }

      // If not found locally, fetch from API
      final response = await _apiService.get('/users/profile');
      if (response != null && response['success'] == true) {
        final user = UserModel.fromJson(response['data']);
        // Cache the user data
        await _storageService.saveUserData(response['data']);
        return user;
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  /// Update user profile
  Future<UserModel> updateProfile(Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.put('/users/profile', userData);
      if (response != null && response['success'] == true) {
        final user = UserModel.fromJson(response['data']);
        // Update cached data
        await _storageService.saveUserData(response['data']);
        return user;
      }
      throw Exception('Failed to update profile');
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Change user password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.put('/users/change-password', {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });
      return response != null && response['success'] == true;
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  /// Upload user avatar
  Future<String?> uploadAvatar(String imagePath) async {
    try {
      final response = await _apiService.uploadFile('/users/avatar', imagePath);
      if (response != null && response['success'] == true) {
        final avatarUrl = response['data']['avatarUrl'] as String?;

        // Update cached user data with new avatar
        final userData = await _storageService.getUserData();
        if (userData != null) {
          userData['avatar'] = avatarUrl;
          await _storageService.saveUserData(userData);
        }

        return avatarUrl;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to upload avatar: $e');
    }
  }

  /// Delete user account
  Future<bool> deleteAccount() async {
    try {
      final response = await _apiService.delete('/users/profile');
      if (response != null && response['success'] == true) {
        // Clear all local data
        await _storageService.clearAll();
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  /// Get user statistics
  Future<Map<String, dynamic>?> getUserStats() async {
    try {
      final response = await _apiService.get('/analytics/user');
      if (response != null && response['success'] == true) {
        return response['data'];
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user statistics: $e');
    }
  }

  /// Enroll in a program
  Future<bool> enrollInProgram(String programId) async {
    try {
      final response = await _apiService.post(
        '/programs/$programId/enroll',
        {},
      );
      if (response != null && response['success'] == true) {
        // Update cached user data
        final userData = await _storageService.getUserData();
        if (userData != null) {
          final enrolledPrograms = List<String>.from(
            userData['enrolledPrograms'] ?? [],
          );
          if (!enrolledPrograms.contains(programId)) {
            enrolledPrograms.add(programId);
            userData['enrolledPrograms'] = enrolledPrograms;
            await _storageService.saveUserData(userData);
          }
        }
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Failed to enroll in program: $e');
    }
  }

  /// Unenroll from a program
  Future<bool> unenrollFromProgram(String programId) async {
    try {
      final response = await _apiService.delete('/programs/$programId/enroll');
      if (response != null && response['success'] == true) {
        // Update cached user data
        final userData = await _storageService.getUserData();
        if (userData != null) {
          final enrolledPrograms = List<String>.from(
            userData['enrolledPrograms'] ?? [],
          );
          enrolledPrograms.remove(programId);
          userData['enrolledPrograms'] = enrolledPrograms;
          await _storageService.saveUserData(userData);
        }
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Failed to unenroll from program: $e');
    }
  }

  /// Clear cached user data
  Future<void> clearUserData() async {
    await _storageService.removeUserData();
  }
}
