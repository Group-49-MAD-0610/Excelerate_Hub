import '../models/entities/user_model.dart';
import '../models/services/auth_service.dart';
import 'base_controller.dart';

/// Controller for authentication operations
class AuthController extends BaseController {
  final AuthService _authService;
  UserModel? _currentUser;

  AuthController({required AuthService authService})
    : _authService = authService;

  /// Current authenticated user
  UserModel? get currentUser => _currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => _currentUser != null;

  /// Initialize auth state
  Future<void> initialize() async {
    await handleAsync(() async {
      _currentUser = await _authService.getCurrentUser();
      return _currentUser;
    });
  }

  /// Login user
  Future<bool> login({required String email, required String password}) async {
    final user = await handleAsync(() async {
      return await _authService.login(email: email, password: password);
    });

    if (user != null) {
      _currentUser = user;
      return true;
    }
    return false;
  }

  /// Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = await handleAsync(() async {
      return await _authService.register(
        name: name,
        email: email,
        password: password,
      );
    });

    if (user != null) {
      _currentUser = user;
      return true;
    }
    return false;
  }

  /// Logout user
  Future<bool> logout() async {
    final success = await handleAsync(() async {
      return await _authService.logout();
    });

    if (success == true) {
      _currentUser = null;
      return true;
    }
    return false;
  }

  /// Refresh current user data
  Future<void> refreshUser() async {
    await handleAsync(() async {
      _currentUser = await _authService.getCurrentUser();
      return _currentUser;
    });
  }

  /// Send forgot password request
  Future<bool> forgotPassword(String email) async {
    final success = await handleAsync(() async {
      return await _authService.forgotPassword(email);
    });

    return success == true;
  }

  /// Reset password
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final success = await handleAsync(() async {
      return await _authService.resetPassword(
        token: token,
        newPassword: newPassword,
      );
    });

    return success == true;
  }

  /// Validate current session
  Future<bool> validateSession() async {
    final isValid = await handleAsync(() async {
      return await _authService.validateSession();
    });

    if (isValid != true) {
      _currentUser = null;
    }

    return isValid == true;
  }
}
