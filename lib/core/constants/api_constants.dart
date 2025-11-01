/// API-related constants
class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://api.excelerate-hub.com/v1';
  static const String devBaseUrl = 'https://dev-api.excelerate-hub.com/v1';
  static const String localBaseUrl = 'http://localhost:3000/api/v1';

  // Authentication Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String logoutEndpoint = '/auth/logout';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String resetPasswordEndpoint = '/auth/reset-password';

  // User Endpoints
  static const String userProfileEndpoint = '/users/profile';
  static const String updateProfileEndpoint = '/users/profile';
  static const String changePasswordEndpoint = '/users/change-password';
  static const String uploadAvatarEndpoint = '/users/avatar';

  // Program Endpoints
  static const String programsEndpoint = '/programs';
  static const String programDetailEndpoint = '/programs'; // + /{id}
  static const String enrollProgramEndpoint = '/programs'; // + /{id}/enroll
  static const String unenrollProgramEndpoint = '/programs'; // + /{id}/unenroll
  static const String programProgressEndpoint = '/programs'; // + /{id}/progress

  // Feedback Endpoints
  static const String feedbackEndpoint = '/feedback';
  static const String programFeedbackEndpoint = '/programs'; // + /{id}/feedback
  static const String submitFeedbackEndpoint = '/programs'; // + /{id}/feedback
  static const String updateFeedbackEndpoint = '/feedback'; // + /{id}
  static const String deleteFeedbackEndpoint = '/feedback'; // + /{id}

  // Analytics Endpoints
  static const String dashboardStatsEndpoint = '/analytics/dashboard';
  static const String userStatsEndpoint = '/analytics/user';
  static const String programStatsEndpoint = '/analytics/programs';

  // Headers
  static const String contentTypeHeader = 'Content-Type';
  static const String authorizationHeader = 'Authorization';
  static const String acceptHeader = 'Accept';
  static const String userAgentHeader = 'User-Agent';

  // Content Types
  static const String jsonContentType = 'application/json';
  static const String formDataContentType = 'multipart/form-data';

  // Status Codes
  static const int successCode = 200;
  static const int createdCode = 201;
  static const int noContentCode = 204;
  static const int badRequestCode = 400;
  static const int unauthorizedCode = 401;
  static const int forbiddenCode = 403;
  static const int notFoundCode = 404;
  static const int validationErrorCode = 422;
  static const int tooManyRequestsCode = 429;
  static const int serverErrorCode = 500;
}
