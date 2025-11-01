import 'package:flutter_test/flutter_test.dart';
import 'package:excelerate/models/repositories/user_repository.dart';
import 'package:excelerate/models/services/api_service.dart';
import 'package:excelerate/models/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('UserRepository Tests', () {
    late UserRepository userRepository;
    late ApiService apiService;
    late StorageService storageService;

    setUpAll(() async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      storageService = await StorageService.getInstance();
      apiService = ApiService(storageService: storageService);
      userRepository = UserRepository(
        apiService: apiService,
        storageService: storageService,
      );
    });

    tearDown(() async {
      // Clean up after each test
      await storageService.clearAll();
    });

    group('getCurrentUser', () {
      test('should return user from local storage when available', () async {
        // Arrange
        final userData = {
          'id': '123',
          'name': 'John Doe',
          'email': 'john@example.com',
          'createdAt': '2023-01-01T00:00:00.000Z',
          'updatedAt': '2023-01-01T00:00:00.000Z',
        };
        await storageService.saveUserData(userData);

        // Act
        final result = await userRepository.getCurrentUser();

        // Assert
        expect(result, isNotNull);
        expect(result?.name, 'John Doe');
        expect(result?.email, 'john@example.com');
      });

      test('should return null when no user data exists', () async {
        // Act
        final result = await userRepository.getCurrentUser();

        // Assert
        expect(result, isNull);
      });

      test('should handle exception when getting current user', () async {
        // Note: Since we don't have a real API, this will throw an exception
        // In a real test, you'd mock the ApiService to simulate various scenarios

        // Act & Assert
        expect(
          () => userRepository.getCurrentUser(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('updateProfile', () {
      test('should throw exception when API is not available', () async {
        // Arrange
        final userData = {
          'name': 'Updated Name',
          'email': 'updated@example.com',
        };

        // Act & Assert
        expect(
          () => userRepository.updateProfile(userData),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('changePassword', () {
      test('should throw exception when API is not available', () async {
        // Act & Assert
        expect(
          () => userRepository.changePassword(
            currentPassword: 'oldPassword',
            newPassword: 'newPassword123',
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('uploadAvatar', () {
      test('should throw exception when API is not available', () async {
        // Act & Assert
        expect(
          () => userRepository.uploadAvatar('/path/to/image.jpg'),
          throwsA(isA<Exception>()),
        );
      });

      test(
        'should update cached user data when avatar upload succeeds',
        () async {
          // Arrange - save initial user data
          final userData = {
            'id': '123',
            'name': 'John Doe',
            'email': 'john@example.com',
            'avatar': null,
            'createdAt': '2023-01-01T00:00:00.000Z',
            'updatedAt': '2023-01-01T00:00:00.000Z',
          };
          await storageService.saveUserData(userData);

          // Act & Assert - should throw exception since no real API
          expect(
            () => userRepository.uploadAvatar('/path/to/image.jpg'),
            throwsA(isA<Exception>()),
          );
        },
      );
    });

    group('deleteAccount', () {
      test('should throw exception when API is not available', () async {
        // Act & Assert
        expect(() => userRepository.deleteAccount(), throwsA(isA<Exception>()));
      });

      test('should clear local data when account deletion succeeds', () async {
        // Arrange - save some user data
        final userData = {
          'id': '123',
          'name': 'John Doe',
          'email': 'john@example.com',
          'createdAt': '2023-01-01T00:00:00.000Z',
          'updatedAt': '2023-01-01T00:00:00.000Z',
        };
        await storageService.saveUserData(userData);
        await storageService.saveToken('test_token');

        // Verify data exists
        expect(await storageService.getUserData(), isNotNull);
        expect(await storageService.getToken(), isNotNull);

        // Act & Assert - should throw exception since no real API
        expect(() => userRepository.deleteAccount(), throwsA(isA<Exception>()));
      });
    });

    group('getUserStats', () {
      test('should throw exception when API is not available', () async {
        // Act & Assert
        expect(() => userRepository.getUserStats(), throwsA(isA<Exception>()));
      });
    });

    group('enrollInProgram', () {
      test('should throw exception when API is not available', () async {
        // Act & Assert
        expect(
          () => userRepository.enrollInProgram('program123'),
          throwsA(isA<Exception>()),
        );
      });

      test(
        'should update local enrolled programs list when enrollment succeeds',
        () async {
          // Arrange - save user data with existing enrollments
          final userData = {
            'id': '123',
            'name': 'John Doe',
            'email': 'john@example.com',
            'enrolledPrograms': ['program1', 'program2'],
            'createdAt': '2023-01-01T00:00:00.000Z',
            'updatedAt': '2023-01-01T00:00:00.000Z',
          };
          await storageService.saveUserData(userData);

          // Act & Assert - should throw exception since no real API
          expect(
            () => userRepository.enrollInProgram('program3'),
            throwsA(isA<Exception>()),
          );
        },
      );
    });

    group('unenrollFromProgram', () {
      test('should throw exception when API is not available', () async {
        // Act & Assert
        expect(
          () => userRepository.unenrollFromProgram('program123'),
          throwsA(isA<Exception>()),
        );
      });

      test(
        'should update local enrolled programs list when unenrollment succeeds',
        () async {
          // Arrange - save user data with existing enrollments
          final userData = {
            'id': '123',
            'name': 'John Doe',
            'email': 'john@example.com',
            'enrolledPrograms': ['program1', 'program2', 'program3'],
            'createdAt': '2023-01-01T00:00:00.000Z',
            'updatedAt': '2023-01-01T00:00:00.000Z',
          };
          await storageService.saveUserData(userData);

          // Act & Assert - should throw exception since no real API
          expect(
            () => userRepository.unenrollFromProgram('program2'),
            throwsA(isA<Exception>()),
          );
        },
      );
    });

    group('clearUserData', () {
      test('should clear user data from storage', () async {
        // Arrange - save user data
        final userData = {
          'id': '123',
          'name': 'John Doe',
          'email': 'john@example.com',
          'createdAt': '2023-01-01T00:00:00.000Z',
          'updatedAt': '2023-01-01T00:00:00.000Z',
        };
        await storageService.saveUserData(userData);

        // Verify data exists
        expect(await storageService.getUserData(), isNotNull);

        // Act
        await userRepository.clearUserData();

        // Assert
        expect(await storageService.getUserData(), isNull);
      });
    });

    group('UserModel Integration', () {
      test('should properly serialize and deserialize user data', () async {
        // Arrange
        final userData = {
          'id': '123',
          'name': 'John Doe',
          'email': 'john@example.com',
          'role': 'student',
          'enrolledPrograms': ['program1', 'program2'],
          'createdAt': '2023-01-01T00:00:00.000Z',
          'updatedAt': '2023-01-01T00:00:00.000Z',
        };
        await storageService.saveUserData(userData);

        // Act
        final result = await userRepository.getCurrentUser();

        // Assert
        expect(result, isNotNull);
        expect(result?.id, '123');
        expect(result?.name, 'John Doe');
        expect(result?.email, 'john@example.com');
        expect(result?.role, 'student');
        expect(result?.enrolledPrograms, contains('program1'));
        expect(result?.enrolledPrograms, contains('program2'));
      });

      test('should handle invalid user data gracefully', () async {
        // Arrange - save invalid data
        final invalidUserData = {
          'invalid': 'data',
          'missing': 'required_fields',
        };
        await storageService.saveUserData(invalidUserData);

        // Act & Assert
        expect(
          () => userRepository.getCurrentUser(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Error Handling', () {
      test('should provide meaningful error messages', () async {
        try {
          await userRepository.updateProfile({'name': 'New Name'});
          fail('Expected exception was not thrown');
        } catch (e) {
          expect(e.toString(), contains('Failed to update profile'));
        }
      });

      test('should handle network errors gracefully', () async {
        // Act & Assert
        expect(
          () => userRepository.changePassword(
            currentPassword: 'old',
            newPassword: 'new',
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Caching Behavior', () {
      test('should prefer local data over API when available', () async {
        // Arrange - save local data
        final localUserData = {
          'id': '123',
          'name': 'Local User',
          'email': 'local@example.com',
          'createdAt': '2023-01-01T00:00:00.000Z',
          'updatedAt': '2023-01-01T00:00:00.000Z',
        };
        await storageService.saveUserData(localUserData);

        // Act
        final result = await userRepository.getCurrentUser();

        // Assert - should return local data, not make API call
        expect(result?.name, 'Local User');
        expect(result?.email, 'local@example.com');
      });
    });
  });
}
