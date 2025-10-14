/// Application-wide constants
class AppConstants {
  // App Information
  static const String appName = 'Excelerate Hub';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'A comprehensive Flutter application for program management and user engagement';

  // Database
  static const String databaseName = 'excelerate_hub.db';
  static const int databaseVersion = 1;

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';

  // Network
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  // Cache Duration
  static const Duration cacheValidDuration = Duration(hours: 24);
  static const Duration shortCacheDuration = Duration(minutes: 30);

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentFormats = ['pdf', 'doc', 'docx'];
}
