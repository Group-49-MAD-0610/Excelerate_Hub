// Import Firebase Auth
import 'package:firebase_auth/firebase_auth.dart';
import '../entities/user_model.dart';
import '../services/api_service.dart'; // Keep this import
import '../services/storage_service.dart'; // Keep this import
import '../../core/constants/api_constants.dart'; // Keep this import

/// Service for handling authentication operations using Firebase.
class AuthService {
  // We keep these dependencies for completeness and other non-auth API calls.
  final ApiService _apiService;
  final StorageService _storageService;
  // This is our new "engine" for authentication
  final FirebaseAuth _firebaseAuth;

  AuthService({
    required ApiService apiService,
    required StorageService storageService,
  }) : _apiService = apiService,
       _storageService = storageService,
       // Initialize the Firebase Auth instance
       _firebaseAuth = FirebaseAuth.instance;

  /// Helper to convert a Firebase User to our app's UserModel
  UserModel _userModelFromFirebase(User fbUser) {
    return UserModel(
      id: fbUser.uid, // Use the Firebase UID as our user ID
      name: fbUser.displayName ?? fbUser.email ?? 'No Name',
      email: fbUser.email ?? 'no-email@example.com',
      avatar: fbUser.photoURL,
      role: 'student', // Default role for new sign-ups
      createdAt: fbUser.metadata.creationTime ?? DateTime.now(),
      updatedAt: fbUser.metadata.lastSignInTime ?? DateTime.now(),
    );
  }

  /// Login user with Firebase
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Sign in with Firebase instead of our old API
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // 2. Convert the Firebase User to our app's UserModel
        final userModel = _userModelFromFirebase(credential.user!);

        // 3. Save our UserModel to local storage
        // Note: The token saving is now handled implicitly by Firebase
        await _storageService.saveUserData(userModel.toJson());

        return userModel;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      // Throw a clean exception message for the AuthController to handle
      throw Exception('Login failed: ${e.message}');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Register new user with Firebase
  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // 1. Create the user in Firebase Auth
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // 2. Update the new user's profile with their name
        await credential.user!.updateDisplayName(name);

        // 3. Convert the Firebase User (now with a name) to our UserModel
        final userModel = _userModelFromFirebase(credential.user!);

        // 4. Save our UserModel to local storage
        await _storageService.saveUserData(userModel.toJson());

        return userModel;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      // Throw a clean exception message for the AuthController to handle
      throw Exception('Registration failed: ${e.message}');
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /// Logout user from Firebase
  Future<bool> logout() async {
    try {
      // 1. Sign out from Firebase
      await _firebaseAuth.signOut();

      // 2. Clear our local data
      await _storageService.removeToken();
      await _storageService.removeUserData();

      return true;
    } catch (e) {
      // Even if sign out fails, clear local data
      await _storageService.removeToken();
      await _storageService.removeUserData();
      return true; // Still report success so the app logs out
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      // Check the current Firebase auth state
      return _firebaseAuth.currentUser != null;
    } catch (e) {
      return false;
    }
  }

  /// Get current user from storage or Firebase
  Future<UserModel?> getCurrentUser() async {
    try {
      // 1. Check for a live Firebase user first (most accurate)
      final fbUser = _firebaseAuth.currentUser;
      if (fbUser != null) {
        final userModel = _userModelFromFirebase(fbUser);
        await _storageService.saveUserData(userModel.toJson());
        return userModel;
      } else {
        // 2. If no live user, check if we have one saved in storage
        final userData = await _storageService.getUserData();
        if (userData != null) {
          return UserModel.fromJson(userData);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Send forgot password request via Firebase
  Future<bool> forgotPassword(String email) async {
    try {
      // Use Firebase's built-in password reset
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      throw Exception('Forgot password request failed: ${e.message}');
    } catch (e) {
      throw Exception('Forgot password request failed: $e');
    }
  }

  // --- The methods below are kept to avoid breaking existing code, even if not fully functional ---

  /// Refresh authentication token
  Future<bool> refreshToken() async {
    // Firebase handles this automatically. Assume success.
    return true;
  }

  /// Reset password with token
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    // This is not standard Firebase flow. Throw an error or return false.
    throw Exception(
      'Password reset via token is not supported. Use email link.',
    );
  }

  /// Validate current session
  Future<bool> validateSession() async {
    // We validate by checking if the Firebase user is logged in.
    return await isLoggedIn();
  }
}
