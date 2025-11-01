import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:excelerate/models/services/storage_service.dart';

void main() {
  group('StorageService Tests', () {
    late StorageService storageService;

    setUpAll(() async {
      // Mock SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
      storageService = await StorageService.getInstance();
    });

    tearDown(() async {
      // Clean up after each test by removing stored data
      await storageService.removeToken();
      await storageService.removeUserData();
    });

    test('should save and retrieve auth token', () async {
      // Arrange
      const testToken = 'test_auth_token_123';

      // Act
      final saveResult = await storageService.saveToken(testToken);
      final retrievedToken = await storageService.getToken();

      // Assert
      expect(saveResult, true);
      expect(retrievedToken, testToken);
    });

    test('should return null when no token exists', () async {
      // Act
      final token = await storageService.getToken();

      // Assert
      expect(token, isNull);
    });

    test('should remove auth token', () async {
      // Arrange
      const testToken = 'test_token_to_remove';
      await storageService.saveToken(testToken);

      // Act
      final removeResult = await storageService.removeToken();
      final tokenAfterRemove = await storageService.getToken();

      // Assert
      expect(removeResult, true);
      expect(tokenAfterRemove, isNull);
    });

    test('should save and retrieve user data', () async {
      // Arrange
      const userData = {
        'id': '123',
        'name': 'John Doe',
        'email': 'john@example.com',
      };

      // Act
      final saveResult = await storageService.saveUserData(userData);
      final retrievedData = await storageService.getUserData();

      // Assert
      expect(saveResult, true);
      expect(retrievedData, userData);
    });

    test('should remove user data', () async {
      // Arrange
      const userData = {'id': '123', 'name': 'Test User'};
      await storageService.saveUserData(userData);

      // Act
      final removeResult = await storageService.removeUserData();
      final dataAfterRemove = await storageService.getUserData();

      // Assert
      expect(removeResult, true);
      expect(dataAfterRemove, isNull);
    });

    test('should save and retrieve theme preference', () async {
      // Arrange
      const theme = 'dark';

      // Act
      final saveResult = await storageService.saveTheme(theme);
      final retrievedTheme = await storageService.getTheme();

      // Assert
      expect(saveResult, true);
      expect(retrievedTheme, theme);
    });

    test('should save and retrieve language preference', () async {
      // Arrange
      const language = 'es';

      // Act
      final saveResult = await storageService.saveLanguage(language);
      final retrievedLanguage = await storageService.getLanguage();

      // Assert
      expect(saveResult, true);
      expect(retrievedLanguage, language);
    });

    test('should handle string key-value storage', () async {
      // Arrange
      const key = 'test_string_key';
      const value = 'test_string_value';

      // Act
      final saveResult = await storageService.saveString(key, value);
      final retrievedValue = await storageService.getString(key);

      // Assert
      expect(saveResult, true);
      expect(retrievedValue, value);
    });

    test('should handle integer key-value storage', () async {
      // Arrange
      const key = 'test_int_key';
      const value = 42;

      // Act
      final saveResult = await storageService.saveInt(key, value);
      final retrievedValue = await storageService.getInt(key);

      // Assert
      expect(saveResult, true);
      expect(retrievedValue, value);
    });

    test('should handle boolean key-value storage', () async {
      // Arrange
      const key = 'test_bool_key';
      const value = true;

      // Act
      final saveResult = await storageService.saveBool(key, value);
      final retrievedValue = await storageService.getBool(key);

      // Assert
      expect(saveResult, true);
      expect(retrievedValue, value);
    });

    test('should handle double key-value storage', () async {
      // Arrange
      const key = 'test_double_key';
      const value = 3.14159;

      // Act
      final saveResult = await storageService.saveDouble(key, value);
      final retrievedValue = await storageService.getDouble(key);

      // Assert
      expect(saveResult, true);
      expect(retrievedValue, value);
    });

    test('should handle string list storage', () async {
      // Arrange
      const key = 'test_list_key';
      const value = ['item1', 'item2', 'item3'];

      // Act
      final saveResult = await storageService.saveStringList(key, value);
      final retrievedValue = await storageService.getStringList(key);

      // Assert
      expect(saveResult, true);
      expect(retrievedValue, value);
    });

    test('should return null for non-existent keys', () async {
      // Act & Assert
      expect(await storageService.getString('non_existent_key'), isNull);
      expect(await storageService.getInt('non_existent_key'), isNull);
      expect(await storageService.getBool('non_existent_key'), isNull);
      expect(await storageService.getDouble('non_existent_key'), isNull);
      expect(await storageService.getStringList('non_existent_key'), isNull);
    });

    test('should persist data across service instances', () async {
      // Arrange
      const testData = 'persistent_data';
      await storageService.saveToken(testData);

      // Act - Create new instance
      final newStorageService = await StorageService.getInstance();
      final retrievedData = await newStorageService.getToken();

      // Assert
      expect(retrievedData, testData);
    });

    test('should validate storage service singleton pattern', () async {
      // Act
      final instance1 = await StorageService.getInstance();
      final instance2 = await StorageService.getInstance();

      // Assert
      expect(identical(instance1, instance2), true);
    });

    test('should handle complex user data structures', () async {
      // Arrange
      const complexUserData = {
        'id': '123',
        'name': 'John Doe',
        'email': 'john@example.com',
        'preferences': {
          'theme': 'dark',
          'notifications': true,
          'language': 'en',
        },
        'enrolledCourses': ['flutter-101', 'dart-advanced'],
        'lastLoginTime': '2024-01-01T00:00:00Z',
      };

      // Act
      final saveResult = await storageService.saveUserData(complexUserData);
      final retrievedData = await storageService.getUserData();

      // Assert
      expect(saveResult, true);
      expect(retrievedData, complexUserData);
      expect(retrievedData?['preferences']['theme'], 'dark');
      expect(retrievedData?['enrolledCourses'], contains('flutter-101'));
    });
  });
}
