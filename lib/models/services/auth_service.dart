import '../entities/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../../core/constants/api_constants.dart';

/// Service for handling authentication operations
class AuthService {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthService({
    required ApiService apiService,
    required StorageService storageService,
  }) : _apiService = apiService,
       _storageService = storageService;

  /// Login user
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(ApiConstants.loginEndpoint, {
        'email': email,
        'password': password,
      });

      if (response != null && response['success'] == true) {
        final userData = response['data'];
        final user = UserModel.fromJson(userData['user']);
        final token = userData['token'] as String;

        // Save token and user data
        await _storageService.saveToken(token);
        await _storageService.saveUserData(userData['user']);

        return user;
      }

      return null;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Register new user
  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(ApiConstants.registerEndpoint, {
        'name': name,
        'email': email,
        'password': password,
        'confirmPassword': password,
      });

      if (response != null && response['success'] == true) {
        final userData = response['data'];
        final user = UserModel.fromJson(userData['user']);
        final token = userData['token'] as String;

        // Save token and user data
        await _storageService.saveToken(token);
        await _storageService.saveUserData(userData['user']);

        return user;
      }

      return null;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /// Logout user
  Future<bool> logout() async {
    try {
      // Try to logout from server
      await _apiService.post(ApiConstants.logoutEndpoint, {});

      // Clear local data regardless of server response
      await _storageService.removeToken();
      await _storageService.removeUserData();

      return true;
    } catch (e) {
      // Even if server logout fails, clear local data
      await _storageService.removeToken();
      await _storageService.removeUserData();
      return true;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final token = await _storageService.getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get current user from storage
  Future<UserModel?> getCurrentUser() async {
    try {
      final userData = await _storageService.getUserData();
      if (userData != null) {
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Refresh authentication token
  Future<bool> refreshToken() async {
    try {
      final response = await _apiService.post(
        ApiConstants.refreshTokenEndpoint,
        {},
      );

      if (response != null && response['success'] == true) {
        final token = response['data']['token'] as String;
        await _storageService.saveToken(token);
        return true;
      }

      return false;
    } catch (e) {
      throw Exception('Token refresh failed: $e');
    }
  }

  /// Send forgot password request
  Future<bool> forgotPassword(String email) async {
    try {
      final response = await _apiService.post(
        ApiConstants.forgotPasswordEndpoint,
        {'email': email},
      );

      return response != null && response['success'] == true;
    } catch (e) {
      throw Exception('Forgot password request failed: $e');
    }
  }

  /// Reset password with token
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.resetPasswordEndpoint,
        {
          'token': token,
          'password': newPassword,
          'confirmPassword': newPassword,
        },
      );

      return response != null && response['success'] == true;
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  /// Validate current session
  Future<bool> validateSession() async {
    try {
      final token = await _storageService.getToken();
      if (token == null) return false;

      // Try to fetch user profile to validate token
      final response = await _apiService.get(ApiConstants.userProfileEndpoint);
      return response != null && response['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
