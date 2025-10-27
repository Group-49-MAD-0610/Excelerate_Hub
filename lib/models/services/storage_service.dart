import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

/// Service for handling local storage operations
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _preferences;

  StorageService._();
  /// Save data to local storage
  Future<void> saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  /// Retrieve data from local storage
  Future<String?> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  /// Remove data
  Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
  /// Singleton instance
  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  /// Save authentication token
  Future<bool> saveToken(String token) async {
    try {
      return await _preferences!.setString(AppConstants.userTokenKey, token);
    } catch (e) {
      throw Exception('Failed to save token: $e');
    }
  }

  /// Get authentication token
  Future<String?> getToken() async {
    try {
      return _preferences!.getString(AppConstants.userTokenKey);
    } catch (e) {
      throw Exception('Failed to get token: $e');
    }
  }

  /// Remove authentication token
  Future<bool> removeToken() async {
    try {
      return await _preferences!.remove(AppConstants.userTokenKey);
    } catch (e) {
      throw Exception('Failed to remove token: $e');
    }
  }

  /// Save user data
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    try {
      final userDataString = json.encode(userData);
      return await _preferences!.setString(
        AppConstants.userDataKey,
        userDataString,
      );
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  /// Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final userDataString = _preferences!.getString(AppConstants.userDataKey);
      if (userDataString != null) {
        return json.decode(userDataString);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  /// Remove user data
  Future<bool> removeUserData() async {
    try {
      return await _preferences!.remove(AppConstants.userDataKey);
    } catch (e) {
      throw Exception('Failed to remove user data: $e');
    }
  }

  /// Save theme preference
  Future<bool> saveTheme(String theme) async {
    try {
      return await _preferences!.setString(AppConstants.themeKey, theme);
    } catch (e) {
      throw Exception('Failed to save theme: $e');
    }
  }

  /// Get theme preference
  Future<String?> getTheme() async {
    try {
      return _preferences!.getString(AppConstants.themeKey);
    } catch (e) {
      throw Exception('Failed to get theme: $e');
    }
  }

  /// Save language preference
  Future<bool> saveLanguage(String language) async {
    try {
      return await _preferences!.setString(AppConstants.languageKey, language);
    } catch (e) {
      throw Exception('Failed to save language: $e');
    }
  }

  /// Get language preference
  Future<String?> getLanguage() async {
    try {
      return _preferences!.getString(AppConstants.languageKey);
    } catch (e) {
      throw Exception('Failed to get language: $e');
    }
  }

  /// Save generic string value
  Future<bool> saveString(String key, String value) async {
    try {
      return await _preferences!.setString(key, value);
    } catch (e) {
      throw Exception('Failed to save string: $e');
    }
  }

  /// Get generic string value
  Future<String?> getString(String key) async {
    try {
      return _preferences!.getString(key);
    } catch (e) {
      throw Exception('Failed to get string: $e');
    }
  }

  /// Save generic int value
  Future<bool> saveInt(String key, int value) async {
    try {
      return await _preferences!.setInt(key, value);
    } catch (e) {
      throw Exception('Failed to save int: $e');
    }
  }

  /// Get generic int value
  Future<int?> getInt(String key) async {
    try {
      return _preferences!.getInt(key);
    } catch (e) {
      throw Exception('Failed to get int: $e');
    }
  }

  /// Save generic bool value
  Future<bool> saveBool(String key, bool value) async {
    try {
      return await _preferences!.setBool(key, value);
    } catch (e) {
      throw Exception('Failed to save bool: $e');
    }
  }

  /// Get generic bool value
  Future<bool?> getBool(String key) async {
    try {
      return _preferences!.getBool(key);
    } catch (e) {
      throw Exception('Failed to get bool: $e');
    }
  }

  /// Save generic double value
  Future<bool> saveDouble(String key, double value) async {
    try {
      return await _preferences!.setDouble(key, value);
    } catch (e) {
      throw Exception('Failed to save double: $e');
    }
  }

  /// Get generic double value
  Future<double?> getDouble(String key) async {
    try {
      return _preferences!.getDouble(key);
    } catch (e) {
      throw Exception('Failed to get double: $e');
    }
  }

  /// Save list of strings
  Future<bool> saveStringList(String key, List<String> value) async {
    try {
      return await _preferences!.setStringList(key, value);
    } catch (e) {
      throw Exception('Failed to save string list: $e');
    }
  }

  /// Get list of strings
  Future<List<String>?> getStringList(String key) async {
    try {
      return _preferences!.getStringList(key);
    } catch (e) {
      throw Exception('Failed to get string list: $e');
    }
  }

  /// Check if key exists
  Future<bool> containsKey(String key) async {
    try {
      return _preferences!.containsKey(key);
    } catch (e) {
      throw Exception('Failed to check key: $e');
    }
  }

  /// Remove specific key
  Future<bool> remove(String key) async {
    try {
      return await _preferences!.remove(key);
    } catch (e) {
      throw Exception('Failed to remove key: $e');
    }
  }

  /// Clear all stored data
  Future<bool> clearAll() async {
    try {
      return await _preferences!.clear();
    } catch (e) {
      throw Exception('Failed to clear all data: $e');
    }
  }

  /// Get all keys
  Set<String> getAllKeys() {
    return _preferences!.getKeys();
  }
}
