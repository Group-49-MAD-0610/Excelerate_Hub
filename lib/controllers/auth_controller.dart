import '../models/entities/user_model.dart';
import '../models/services/auth_service.dart';
import 'base_controller.dart';

/// Controller for authentication operations
/// This class manages the user state and acts as the middleman for the UI.
class AuthController extends BaseController {
  final AuthService _authService;
  UserModel? _currentUser;

  AuthController({required AuthService authService})
    : _authService = authService;

  /// Current authenticated user
  UserModel? get currentUser => _currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => _currentUser != null;

  /// Attempts to log the user in with email and password.
  Future<bool> login({required String email, required String password}) async {
    // Use handleAsync to show loading spinner and catch errors.
    final user = await handleAsync(() async {
      return await _authService.login(email: email, password: password);
    });

    if (user != null) {
      _currentUser = user; // Store the logged-in user
      return true;
    }
    return false;
  }

  /// Attempts to register a new user.
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
      _currentUser = user; // Store the new user
      return true;
    }
    return false;
  }

  /// Logs the current user out.
  Future<bool> logout() async {
    final success = await handleAsync(() async {
      return await _authService.logout();
    });

    if (success == true) {
      _currentUser = null; // Clear the user
      return true;
    }
    return false;
  }

  // Note: Other methods like initialize, refreshUser, etc., are assumed to be
  // implemented here as in the original project structure.
}
