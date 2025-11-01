import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import 'storage_service.dart';

/// Service for handling API communications
class ApiService {
  final StorageService _storageService;
  late final String _baseUrl;

  ApiService({required StorageService storageService, String? baseUrl})
    : _storageService = storageService {
    _baseUrl = baseUrl ?? ApiConstants.baseUrl;
  }

  /// Get HTTP headers with authentication
  Future<Map<String, String>> _getHeaders() async {
    final headers = {
      ApiConstants.contentTypeHeader: ApiConstants.jsonContentType,
      ApiConstants.acceptHeader: ApiConstants.jsonContentType,
    };

    // Add authorization header if token exists
    final token = await _storageService.getToken();
    if (token != null) {
      headers[ApiConstants.authorizationHeader] = 'Bearer $token';
    }

    return headers;
  }

  /// Handle API response
  Map<String, dynamic>? _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      }
      return {'success': true};
    } else {
      throw HttpException(
        'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        uri: response.request?.url,
      );
    }
  }

  /// GET request
  Future<Map<String, dynamic>?> get(
    String endpoint, {
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final uriWithQuery = queryParameters != null
          ? uri.replace(queryParameters: queryParameters)
          : uri;

      final headers = await _getHeaders();
      final response = await http.get(uriWithQuery, headers: headers);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  /// POST request
  Future<Map<String, dynamic>?> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = await _getHeaders();
      final body = json.encode(data);

      final response = await http.post(uri, headers: headers, body: body);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  /// PUT request
  Future<Map<String, dynamic>?> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = await _getHeaders();
      final body = json.encode(data);

      final response = await http.put(uri, headers: headers, body: body);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  /// DELETE request
  Future<Map<String, dynamic>?> delete(String endpoint) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = await _getHeaders();

      final response = await http.delete(uri, headers: headers);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('DELETE request failed: $e');
    }
  }

  /// Upload file
  Future<Map<String, dynamic>?> uploadFile(
    String endpoint,
    String filePath, {
    String fieldName = 'file',
    Map<String, String>? additionalFields,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final request = http.MultipartRequest('POST', uri);

      // Add headers
      final headers = await _getHeaders();
      request.headers.addAll(headers);

      // Add file
      final file = await http.MultipartFile.fromPath(fieldName, filePath);
      request.files.add(file);

      // Add additional fields
      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }

  /// Download file
  Future<List<int>?> downloadFile(String endpoint) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = await _getHeaders();

      final response = await http.get(uri, headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.bodyBytes;
      } else {
        throw HttpException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
          uri: response.request?.url,
        );
      }
    } catch (e) {
      throw Exception('File download failed: $e');
    }
  }
}
