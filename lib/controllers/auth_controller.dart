import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../models/entities/user_model.dart';

/// Local auth service that reads users from assets/data/users.json for login.
/// Note: assets/data/users.json must be declared in pubspec.yaml.
class AuthService {
  UserModel? _currentUser;

  Future<UserModel?> getCurrentUser() async => _currentUser;

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/users.json');
      final List<dynamic> list = json.decode(jsonStr) as List<dynamic>;
      final users = list.cast<Map<String, dynamic>>();

      final match = users.firstWhere(
        (u) => (u['email'] as String).toLowerCase() == email.toLowerCase(),
        orElse: () => null,
      );

      if (match == null) return null;

      // If JSON provides a password field, validate it. Otherwise accept any non-empty password.
      if (match.containsKey('password')) {
        final expected = (match['password'] ?? '') as String;
        if (password != expected) return null;
      } else {
        if (password.isEmpty) return null;
      }

      final user = UserModel.fromJson(match);
      _currentUser = user;
      return user;
    } catch (_) {
      return null;
    }
  }

  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Can't write back to assets; create an in-memory user for the prototype.
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
    return user;
  }

  Future<bool> logout() async {
    _currentUser = null;
    return true;
  }

  Future<bool> forgotPassword(String email) async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/users.json');
      final List<dynamic> list = json.decode(jsonStr) as List<dynamic>;
      final exists = list.cast<Map<String, dynamic>>().any(
            (u) => (u['email'] as String).toLowerCase() == email.toLowerCase(),
          );
      return exists;
    } catch (_) {
      return false;
    }
  }

  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    // No persistence in prototype — always succeed.
    return true;
  }

  Future<bool> validateSession() async {
    return _currentUser != null;
  }
}