import '../entities/program_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

/// Repository for program-related data operations
class ProgramRepository {
  final ApiService _apiService;
  final StorageService _storageService;

  ProgramRepository({
    required ApiService apiService,
    required StorageService storageService,
  }) : _apiService = apiService,
       _storageService = storageService;

  /// Get all programs with optional filtering
  Future<List<ProgramModel>> getPrograms({
    int page = 1,
    int limit = 10,
    String? category,
    String? search,
  }) async {
    try {
      final queryParameters = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (category != null) queryParameters['category'] = category;
      if (search != null) queryParameters['search'] = search;

      final response = await _apiService.get(
        '/programs',
        queryParameters: queryParameters,
      );

      if (response != null && response['success'] == true) {
        final programsData = response['data']['programs'] as List;
        return programsData.map((json) => ProgramModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to get programs: $e');
    }
  }

  /// Get program by ID
  Future<ProgramModel?> getProgramById(String programId) async {
    try {
      final response = await _apiService.get('/programs/$programId');
      if (response != null && response['success'] == true) {
        return ProgramModel.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get program: $e');
    }
  }

  /// Get featured programs
  Future<List<ProgramModel>> getFeaturedPrograms() async {
    try {
      final response = await _apiService.get('/programs?featured=true&limit=5');
      if (response != null && response['success'] == true) {
        final programsData = response['data']['programs'] as List;
        return programsData.map((json) => ProgramModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get featured programs: $e');
    }
  }

  /// Get enrolled programs for current user
  Future<List<ProgramModel>> getEnrolledPrograms() async {
    try {
      final response = await _apiService.get('/programs?enrolled=true');
      if (response != null && response['success'] == true) {
        final programsData = response['data']['programs'] as List;
        return programsData.map((json) => ProgramModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get enrolled programs: $e');
    }
  }

  /// Search programs
  Future<List<ProgramModel>> searchPrograms(String query) async {
    try {
      if (query.trim().isEmpty) return [];

      final response = await _apiService.get(
        '/programs',
        queryParameters: {'search': query, 'limit': '20'},
      );

      if (response != null && response['success'] == true) {
        final programsData = response['data']['programs'] as List;
        return programsData.map((json) => ProgramModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to search programs: $e');
    }
  }

  /// Get programs by category
  Future<List<ProgramModel>> getProgramsByCategory(String category) async {
    try {
      final response = await _apiService.get(
        '/programs',
        queryParameters: {'category': category, 'limit': '20'},
      );

      if (response != null && response['success'] == true) {
        final programsData = response['data']['programs'] as List;
        return programsData.map((json) => ProgramModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to get programs by category: $e');
    }
  }

  /// Get program progress for current user
  Future<double?> getProgramProgress(String programId) async {
    try {
      // Try to get from local storage first
      final cachedProgress = await _storageService.getDouble(
        'progress_$programId',
      );

      final response = await _apiService.get('/programs/$programId/progress');
      if (response != null && response['success'] == true) {
        final progress = (response['data']['progress'] as num?)?.toDouble();

        // Cache the progress locally
        if (progress != null) {
          await _storageService.saveDouble('progress_$programId', progress);
        }

        return progress;
      }

      // Return cached progress if API call fails
      return cachedProgress;
    } catch (e) {
      // Return cached progress on error
      return await _storageService.getDouble('progress_$programId');
    }
  }

  /// Update program progress
  Future<bool> updateProgramProgress(String programId, double progress) async {
    try {
      // Save locally first for immediate UI update
      await _storageService.saveDouble('progress_$programId', progress);

      final response = await _apiService.put('/programs/$programId/progress', {
        'progress': progress,
      });
      return response != null && response['success'] == true;
    } catch (e) {
      throw Exception('Failed to update program progress: $e');
    }
  }

  /// Create new program (admin/moderator only)
  Future<ProgramModel?> createProgram(Map<String, dynamic> programData) async {
    try {
      final response = await _apiService.post('/programs', programData);
      if (response != null && response['success'] == true) {
        return ProgramModel.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to create program: $e');
    }
  }

  /// Update program (admin/moderator only)
  Future<ProgramModel?> updateProgram(
    String programId,
    Map<String, dynamic> programData,
  ) async {
    try {
      final response = await _apiService.put(
        '/programs/$programId',
        programData,
      );
      if (response != null && response['success'] == true) {
        return ProgramModel.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to update program: $e');
    }
  }

  /// Delete program (admin only)
  Future<bool> deleteProgram(String programId) async {
    try {
      final response = await _apiService.delete('/programs/$programId');
      return response != null && response['success'] == true;
    } catch (e) {
      throw Exception('Failed to delete program: $e');
    }
  }
}
