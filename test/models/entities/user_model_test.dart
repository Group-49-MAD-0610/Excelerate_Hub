import 'package:flutter_test/flutter_test.dart';
import 'package:excelerate/models/entities/user_model.dart';

void main() {
  group('UserModel Tests', () {
    test('should create UserModel from JSON', () {
      // Arrange
      final json = {
        'id': '123',
        'name': 'John Doe',
        'email': 'test@example.com',
        'avatar': 'https://example.com/image.jpg',
        'role': 'student',
        'createdAt': '2024-01-01T00:00:00Z',
        'updatedAt': '2024-01-01T00:00:00Z',
        'isActive': true,
        'phoneNumber': '+1234567890',
        'bio': 'Test bio',
        'enrolledPrograms': ['program1', 'program2'],
      };

      // Act
      final user = UserModel.fromJson(json);

      // Assert
      expect(user.id, '123');
      expect(user.name, 'John Doe');
      expect(user.email, 'test@example.com');
      expect(user.avatar, 'https://example.com/image.jpg');
      expect(user.role, 'student');
      expect(user.isActive, true);
      expect(user.phoneNumber, '+1234567890');
      expect(user.bio, 'Test bio');
      expect(user.enrolledPrograms, ['program1', 'program2']);
    });

    test('should convert UserModel to JSON', () {
      // Arrange
      final user = UserModel(
        id: '123',
        name: 'John Doe',
        email: 'test@example.com',
        avatar: 'https://example.com/image.jpg',
        role: 'student',
        createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
        updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
        isActive: true,
        phoneNumber: '+1234567890',
        bio: 'Test bio',
        enrolledPrograms: ['program1', 'program2'],
      );

      // Act
      final json = user.toJson();

      // Assert
      expect(json['id'], '123');
      expect(json['name'], 'John Doe');
      expect(json['email'], 'test@example.com');
      expect(json['avatar'], 'https://example.com/image.jpg');
      expect(json['role'], 'student');
      expect(json['isActive'], true);
      expect(json['phoneNumber'], '+1234567890');
      expect(json['bio'], 'Test bio');
      expect(json['enrolledPrograms'], ['program1', 'program2']);
    });

    test('should handle different user roles', () {
      // Test student role
      final studentJson = {
        'id': '1',
        'name': 'Test Student',
        'email': 'student@test.com',
        'role': 'student',
        'createdAt': '2024-01-01T00:00:00Z',
        'updatedAt': '2024-01-01T00:00:00Z',
      };
      final student = UserModel.fromJson(studentJson);
      expect(student.role, 'student');

      // Test instructor role
      final instructorJson = {
        'id': '2',
        'name': 'Test Instructor',
        'email': 'instructor@test.com',
        'role': 'instructor',
        'createdAt': '2024-01-01T00:00:00Z',
        'updatedAt': '2024-01-01T00:00:00Z',
      };
      final instructor = UserModel.fromJson(instructorJson);
      expect(instructor.role, 'instructor');

      // Test admin role
      final adminJson = {
        'id': '3',
        'name': 'Test Admin',
        'email': 'admin@test.com',
        'role': 'admin',
        'createdAt': '2024-01-01T00:00:00Z',
        'updatedAt': '2024-01-01T00:00:00Z',
      };
      final admin = UserModel.fromJson(adminJson);
      expect(admin.role, 'admin');
    });

    test('should handle missing optional fields', () {
      // Arrange
      final minimalJson = {
        'id': '123',
        'name': 'John Doe',
        'email': 'test@example.com',
        'createdAt': '2024-01-01T00:00:00Z',
        'updatedAt': '2024-01-01T00:00:00Z',
      };

      // Act
      final user = UserModel.fromJson(minimalJson);

      // Assert
      expect(user.id, '123');
      expect(user.name, 'John Doe');
      expect(user.email, 'test@example.com');
      expect(user.avatar, isNull);
      expect(user.role, 'student'); // Default role
      expect(user.isActive, true); // Default value
      expect(user.phoneNumber, isNull);
      expect(user.bio, isNull);
      expect(user.enrolledPrograms, isEmpty);
    });

    test('should handle user update scenarios', () {
      // Arrange
      final user = UserModel(
        id: '123',
        name: 'John Doe',
        email: 'old@example.com',
        role: 'student',
        createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
        updatedAt: DateTime.parse('2024-01-01T00:00:00Z'),
      );

      // Act
      final updatedUser = user.copyWith(
        email: 'new@example.com',
        name: 'Jane Doe',
        updatedAt: DateTime.parse('2024-01-02T00:00:00Z'),
      );

      // Assert
      expect(updatedUser.email, 'new@example.com');
      expect(updatedUser.name, 'Jane Doe');
      expect(updatedUser.id, '123'); // Unchanged
      expect(updatedUser.role, 'student'); // Unchanged
    });

    test('should validate required fields', () {
      // Test that required fields throw when missing
      expect(
        () => UserModel.fromJson({
          'name': 'John Doe',
          'email': 'test@example.com',
          // Missing 'id'
        }),
        throwsA(isA<TypeError>()),
      );

      expect(
        () => UserModel.fromJson({
          'id': '123',
          'email': 'test@example.com',
          // Missing 'name'
        }),
        throwsA(isA<TypeError>()),
      );
    });

    test('should handle enrolled programs list', () {
      // Test with programs
      final userWithPrograms = UserModel.fromJson({
        'id': '123',
        'name': 'John Doe',
        'email': 'test@example.com',
        'createdAt': '2024-01-01T00:00:00Z',
        'updatedAt': '2024-01-01T00:00:00Z',
        'enrolledPrograms': ['flutter-basics', 'advanced-dart', 'ui-design'],
      });

      expect(userWithPrograms.enrolledPrograms.length, 3);
      expect(userWithPrograms.enrolledPrograms, contains('flutter-basics'));
      expect(userWithPrograms.enrolledPrograms, contains('advanced-dart'));
      expect(userWithPrograms.enrolledPrograms, contains('ui-design'));

      // Test without programs
      final userWithoutPrograms = UserModel.fromJson({
        'id': '124',
        'name': 'Jane Doe',
        'email': 'jane@example.com',
        'createdAt': '2024-01-01T00:00:00Z',
        'updatedAt': '2024-01-01T00:00:00Z',
      });

      expect(userWithoutPrograms.enrolledPrograms, isEmpty);
    });
  });
}
