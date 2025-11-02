import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../entities/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

/// Service for handling authentication operations
/// Uses local JSON file for authentication (prototype mode)
class AuthService {
  final ApiService _apiService;
  final StorageService _storageService;
  UserModel? _currentUser;

  AuthService({
    required ApiService apiService,
    required StorageService storageService,
  }) : _apiService = apiService,
       _storageService = storageService;

  /// Login user with local JSON authentication
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      // Load users from local JSON file
      final jsonStr = await rootBundle.loadString('assets/data/users.json');
      final List<dynamic> list = json.decode(jsonStr) as List<dynamic>;
      final users = list.cast<Map<String, dynamic>>();

      // Find user by email (case-insensitive)
      final match = users.firstWhere(
        (u) => (u['email'] as String).toLowerCase() == email.toLowerCase(),
        orElse: () => <String, dynamic>{},
      );

      if (match.isEmpty) return null;

      // Validate password
      if (match.containsKey('password')) {
        final expected = (match['password'] ?? '') as String;
        if (password != expected) return null;
      } else {
        if (password.isEmpty) return null;
      }

      // Create user model
      final user = UserModel.fromJson(match);
      _currentUser = user;

      // Generate a mock token and save user data
      final token =
          'mock_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}';
      await _storageService.saveToken(token);
      await _storageService.saveUserData(match);

      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Register new user (in-memory only for prototype)
  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Create in-memory user for prototype
      final now = DateTime.now().toUtc();
      final user = UserModel(
        id: 'user-${now.millisecondsSinceEpoch}',
        name: name,
        email: email,
        avatar: null,
        role: 'student',
        createdAt: now,
        updatedAt: now,
      );
      _currentUser = user;

      // Generate mock token and save user data
      final token = 'mock_token_${user.id}_${now.millisecondsSinceEpoch}';
      await _storageService.saveToken(token);
      await _storageService.saveUserData(user.toJson());

      return user;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /// Logout user
  Future<bool> logout() async {
    try {
      _currentUser = null;
      await _storageService.removeToken();
      await _storageService.removeUserData();
      return true;
    } catch (e) {
      // Clear current user even if storage fails
      _currentUser = null;
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

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      // Return cached user if available
      if (_currentUser != null) return _currentUser;

      // Try to load from storage
      final userData = await _storageService.getUserData();
      if (userData != null) {
        _currentUser = UserModel.fromJson(userData);
        return _currentUser;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Refresh authentication token (mock for prototype)
  Future<bool> refreshToken() async {
    try {
      final token = await _storageService.getToken();
      if (token != null) {
        // Token is still valid in prototype mode
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Send forgot password request (validates email exists)
  Future<bool> forgotPassword(String email) async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/users.json');
      final List<dynamic> list = json.decode(jsonStr) as List<dynamic>;
      final exists = list.cast<Map<String, dynamic>>().any(
        (u) => (u['email'] as String).toLowerCase() == email.toLowerCase(),
      );
      return exists;
    } catch (e) {
      return false;
    }
  }

  /// Reset password with token (mock for prototype)
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      // In prototype mode, always succeed
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Validate current session
  Future<bool> validateSession() async {
    try {
      final token = await _storageService.getToken();
      if (token == null) return false;

      // Check if we have user data
      final userData = await _storageService.getUserData();
      if (userData != null) {
        _currentUser = UserModel.fromJson(userData);
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
