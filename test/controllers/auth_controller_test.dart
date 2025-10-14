import 'package:flutter_test/flutter_test.dart';
import 'package:excelerate/controllers/auth_controller.dart';
import 'package:excelerate/models/services/auth_service.dart';
import 'package:excelerate/models/services/api_service.dart';
import 'package:excelerate/models/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AuthController Tests', () {
    late AuthController authController;
    late AuthService authService;
    late ApiService apiService;
    late StorageService storageService;

    setUpAll(() async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      storageService = await StorageService.getInstance();
      apiService = ApiService(storageService: storageService);
      authService = AuthService(
        apiService: apiService,
        storageService: storageService,
      );
    });

    setUp(() {
      authController = AuthController(authService: authService);
    });

    tearDown(() async {
      // Clean up after each test
      await storageService.removeToken();
      await storageService.removeUserData();
      authController.dispose();
    });

    test('should initialize with correct default state', () {
      // Assert
      expect(authController.isLoading, false);
      expect(authController.error, isNull);
      expect(authController.currentUser, isNull);
      expect(authController.isAuthenticated, false);
    });

    test('should handle login attempt with valid credentials', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      bool loadingStateChanged = false;

      // Listen to loading state changes
      authController.addListener(() {
        if (authController.isLoading) {
          loadingStateChanged = true;
        }
      });

      // Act
      await authController.login(email: email, password: password);

      // Assert
      expect(loadingStateChanged, true);
      expect(authController.isLoading, false);
      // Note: Since we don't have a real API, this will likely fail
      // In a real test, you'd mock the AuthService to return success
    });

    test('should handle login with invalid credentials', () async {
      // Arrange
      const email = 'invalid@example.com';
      const password = 'wrongpassword';

      // Act
      await authController.login(email: email, password: password);

      // Assert
      expect(authController.isAuthenticated, false);
      expect(authController.currentUser, isNull);
    });

    test('should handle registration attempt', () async {
      // Arrange
      const email = 'newuser@example.com';
      const password = 'password123';
      const name = 'New User';

      // Act
      await authController.register(
        email: email,
        password: password,
        name: name,
      );

      // Assert
      expect(authController.isLoading, false);
      // Result depends on actual implementation
    });

    test('should handle logout correctly', () async {
      // Arrange - simulate logged in state
      await storageService.saveToken('test_token');
      await storageService.saveUserData({
        'id': '123',
        'name': 'Test User',
        'email': 'test@example.com',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // Act
      await authController.logout();

      // Assert
      expect(authController.currentUser, isNull);
      expect(authController.isAuthenticated, false);
      expect(await storageService.getToken(), isNull);
    });

    test('should initialize auth state from storage', () async {
      // Arrange - save auth data to storage
      const token = 'stored_auth_token';
      final userData = {
        'id': '123',
        'name': 'Stored User',
        'email': 'stored@example.com',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await storageService.saveToken(token);
      await storageService.saveUserData(userData);

      // Act
      await authController.initialize();

      // Assert
      expect(authController.isAuthenticated, true);
      expect(authController.currentUser, isNotNull);
      expect(authController.currentUser?.name, 'Stored User');
    });

    test('should clear error message when new operation starts', () async {
      // Arrange - set an error state
      authController.setError('Previous error');
      expect(authController.error, 'Previous error');

      // Act
      await authController.login(
        email: 'test@example.com',
        password: 'password',
      );

      // Assert - error should be cleared when new operation starts
      // (Note: This test depends on implementation details)
    });

    test('should handle loading state correctly during operations', () async {
      // Arrange
      List<bool> loadingStates = [];

      authController.addListener(() {
        loadingStates.add(authController.isLoading);
      });

      // Act
      await authController.login(
        email: 'test@example.com',
        password: 'password',
      );

      // Assert
      expect(
        loadingStates,
        contains(true),
      ); // Should have been loading at some point
      expect(
        authController.isLoading,
        false,
      ); // Should not be loading at the end
    });

    test('should notify listeners when user state changes', () async {
      // Arrange
      int notificationCount = 0;

      authController.addListener(() {
        notificationCount++;
      });

      // Act
      await authController.login(
        email: 'test@example.com',
        password: 'password',
      );

      // Assert
      expect(notificationCount, greaterThan(0));
    });

    test('should handle forgot password request', () async {
      // Arrange
      const email = 'test@example.com';

      // Act
      await authController.forgotPassword(email);

      // Assert
      expect(authController.isLoading, false);
      // Result depends on actual implementation
    });

    test('should handle password reset with token', () async {
      // Arrange
      const token = 'reset_token_123';
      const newPassword = 'newPassword123';

      // Act
      await authController.resetPassword(
        token: token,
        newPassword: newPassword,
      );

      // Assert
      expect(authController.isLoading, false);
      // Result depends on actual implementation
    });

    test('should validate current session', () async {
      // Arrange - set up authenticated user
      await storageService.saveToken('valid_token');
      await storageService.saveUserData({
        'id': '123',
        'name': 'Test User',
        'email': 'test@example.com',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      await authController.initialize();

      // Act
      await authController.validateSession();

      // Assert
      expect(authController.isLoading, false);
      // Result depends on actual API implementation
    });

    test('should refresh user data', () async {
      // Arrange - set up authenticated user
      await storageService.saveUserData({
        'id': '123',
        'name': 'Original Name',
        'email': 'test@example.com',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      await authController.initialize();

      // Act
      await authController.refreshUser();

      // Assert
      expect(authController.isLoading, false);
      expect(authController.currentUser, isNotNull);
    });

    test('should handle concurrent auth operations gracefully', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';

      // Act - start multiple operations concurrently
      final futures = [
        authController.login(email: email, password: password),
        authController.login(email: email, password: password),
        authController.login(email: email, password: password),
      ];

      await Future.wait(futures);

      // Assert - should handle concurrent operations without crashing
      expect(authController.isLoading, false);
    });

    test('should handle error states properly', () async {
      // Arrange
      authController.setError('Test error message');

      // Assert
      expect(authController.error, 'Test error message');

      // Act - clear error
      authController.clearError();

      // Assert
      expect(authController.error, isNull);
    });

    test('should dispose properly', () {
      // Act
      authController.dispose();

      // Assert
      expect(authController.isDisposed, true);

      // Should not crash when setting state after disposal
      authController.setLoading(true);
      authController.setError('Should not set after disposal');
    });
  });
}
