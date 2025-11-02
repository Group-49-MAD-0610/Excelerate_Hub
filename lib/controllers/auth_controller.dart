import 'package:flutter/foundation.dart';
import '../models/entities/user_model.dart';
import '../models/services/auth_service.dart';
import 'base_controller.dart';

/// Controller for authentication-related operations and state management
class AuthController extends BaseController {
  final AuthService _authService;

  AuthController({required AuthService authService})
    : _authService = authService;

  // State variables
  UserModel? _currentUser;
  bool _isAuthenticated = false;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  /// Initialize authentication state
  /// Checks if there's a valid session on app start
  Future<void> initializeAuth() async {
    try {
      setLoading(true);
      clearError();

      final isValid = await _authService.validateSession();
      if (isValid) {
        _currentUser = await _authService.getCurrentUser();
        _isAuthenticated = _currentUser != null;
      } else {
        _currentUser = null;
        _isAuthenticated = false;
      }

      notifyListeners();
    } catch (e) {
      setError('Failed to initialize authentication: ${e.toString()}');
      _isAuthenticated = false;
    } finally {
      setLoading(false);
    }
  }

  /// Login with email and password
  Future<bool> login({required String email, required String password}) async {
    try {
      setLoading(true);
      clearError();

      // Validate inputs
      if (email.isEmpty) {
        setError('Email is required');
        return false;
      }

      if (password.isEmpty) {
        setError('Password is required');
        return false;
      }

      // Basic email validation
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        setError('Please enter a valid email address');
        return false;
      }

      // Attempt login
      final user = await _authService.login(email: email, password: password);

      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        notifyListeners();

        if (kDebugMode) {
          print('Login successful: ${user.name} (${user.email})');
        }

        return true;
      } else {
        setError('Invalid email or password');
        _isAuthenticated = false;
        return false;
      }
    } catch (e) {
      setError('Login failed: ${e.toString()}');
      _isAuthenticated = false;
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Register a new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      setLoading(true);
      clearError();

      // Validate inputs
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        setError('All fields are required');
        return false;
      }

      if (password != confirmPassword) {
        setError('Passwords do not match');
        return false;
      }

      if (password.length < 8) {
        setError('Password must be at least 8 characters long');
        return false;
      }

      // Basic email validation
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        setError('Please enter a valid email address');
        return false;
      }

      // Attempt registration
      final user = await _authService.register(
        name: name,
        email: email,
        password: password,
      );

      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        notifyListeners();

        if (kDebugMode) {
          print('Registration successful: ${user.name} (${user.email})');
        }

        return true;
      } else {
        setError('Registration failed');
        _isAuthenticated = false;
        return false;
      }
    } catch (e) {
      setError('Registration failed: ${e.toString()}');
      _isAuthenticated = false;
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Logout current user
  Future<bool> logout() async {
    try {
      setLoading(true);
      clearError();

      final success = await _authService.logout();

      if (success) {
        _currentUser = null;
        _isAuthenticated = false;
        notifyListeners();

        if (kDebugMode) {
          print('Logout successful');
        }

        return true;
      } else {
        setError('Logout failed');
        return false;
      }
    } catch (e) {
      setError('Logout failed: ${e.toString()}');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Request password reset
  Future<bool> forgotPassword(String email) async {
    try {
      setLoading(true);
      clearError();

      if (email.isEmpty) {
        setError('Email is required');
        return false;
      }

      // Basic email validation
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        setError('Please enter a valid email address');
        return false;
      }

      final success = await _authService.forgotPassword(email);

      if (success) {
        if (kDebugMode) {
          print('Password reset email sent to: $email');
        }
        return true;
      } else {
        setError('Email not found');
        return false;
      }
    } catch (e) {
      setError('Password reset failed: ${e.toString()}');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Reset password with token
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      setLoading(true);
      clearError();

      if (token.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
        setError('All fields are required');
        return false;
      }

      if (newPassword != confirmPassword) {
        setError('Passwords do not match');
        return false;
      }

      if (newPassword.length < 8) {
        setError('Password must be at least 8 characters long');
        return false;
      }

      final success = await _authService.resetPassword(
        token: token,
        newPassword: newPassword,
      );

      if (success) {
        if (kDebugMode) {
          print('Password reset successful');
        }
        return true;
      } else {
        setError('Password reset failed');
        return false;
      }
    } catch (e) {
      setError('Password reset failed: ${e.toString()}');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Validate current session
  Future<bool> validateSession() async {
    try {
      final isValid = await _authService.validateSession();

      if (!isValid) {
        _currentUser = null;
        _isAuthenticated = false;
        notifyListeners();
      }

      return isValid;
    } catch (e) {
      if (kDebugMode) {
        print('Session validation failed: ${e.toString()}');
      }
      _currentUser = null;
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      if (_currentUser != null) {
        return _currentUser;
      }

      _currentUser = await _authService.getCurrentUser();
      _isAuthenticated = _currentUser != null;
      notifyListeners();

      return _currentUser;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get current user: ${e.toString()}');
      }
      return null;
    }
  }
}
