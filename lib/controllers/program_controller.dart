import '../models/entities/program_model.dart';
import '../models/repositories/program_repository.dart';
import 'base_controller.dart';

/// Controller for program-related operations and state management
class ProgramController extends BaseController {
  final ProgramRepository _programRepository;

  ProgramController({required ProgramRepository programRepository})
    : _programRepository = programRepository;

  // State variables
  ProgramModel? _currentProgram;
  List<ProgramModel> _programs = [];
  List<ProgramModel> _featuredPrograms = [];
  List<ProgramModel> _enrolledPrograms = [];
  String? _searchQuery;

  // Getters
  ProgramModel? get currentProgram => _currentProgram;
  List<ProgramModel> get programs => _programs;
  List<ProgramModel> get featuredPrograms => _featuredPrograms;
  List<ProgramModel> get enrolledPrograms => _enrolledPrograms;
  String? get searchQuery => _searchQuery;

  /// Load a specific program by ID
  Future<bool> loadProgram(String programId) async {
    try {
      setLoading(true);
      clearError();

      final program = await _programRepository.getProgramById(programId);
      if (program != null) {
        _currentProgram = program;
        notifyListeners();
        return true;
      } else {
        setError('Program not found');
        return false;
      }
    } catch (e) {
      setError('Failed to load program: ${e.toString()}');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Load featured programs
  Future<void> loadFeaturedPrograms() async {
    try {
      setLoading(true);
      clearError();

      _featuredPrograms = await _programRepository.getFeaturedPrograms();
      notifyListeners();
    } catch (e) {
      setError('Failed to load featured programs: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  /// Load enrolled programs
  Future<void> loadEnrolledPrograms() async {
    try {
      setLoading(true);
      clearError();

      _enrolledPrograms = await _programRepository.getEnrolledPrograms();
      notifyListeners();
    } catch (e) {
      setError('Failed to load enrolled programs: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  /// Search programs
  Future<void> searchPrograms(String query) async {
    try {
      setLoading(true);
      clearError();
      _searchQuery = query;

      if (query.trim().isEmpty) {
        _programs = [];
      } else {
        _programs = await _programRepository.searchPrograms(query);
      }
      notifyListeners();
    } catch (e) {
      setError('Failed to search programs: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  /// Load programs with filters
  Future<void> loadPrograms({
    int page = 1,
    int limit = 10,
    String? category,
    String? search,
  }) async {
    try {
      setLoading(true);
      clearError();

      _programs = await _programRepository.getPrograms(
        page: page,
        limit: limit,
        category: category,
        search: search,
      );
      notifyListeners();
    } catch (e) {
      setError('Failed to load programs: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  /// Load programs by category
  Future<void> loadProgramsByCategory(String category) async {
    try {
      setLoading(true);
      clearError();

      _programs = await _programRepository.getProgramsByCategory(category);
      notifyListeners();
    } catch (e) {
      setError('Failed to load programs by category: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  /// Get program progress
  Future<double?> getProgramProgress(String programId) async {
    try {
      return await _programRepository.getProgramProgress(programId);
    } catch (e) {
      setError('Failed to get program progress: ${e.toString()}');
      return null;
    }
  }

  /// Update program progress
  Future<bool> updateProgramProgress(String programId, double progress) async {
    try {
      final success = await _programRepository.updateProgramProgress(
        programId,
        progress,
      );

      if (success && _currentProgram?.id == programId) {
        _currentProgram = _currentProgram!.copyWith(progress: progress);
        notifyListeners();
      }

      return success;
    } catch (e) {
      setError('Failed to update program progress: ${e.toString()}');
      return false;
    }
  }

  /// Enroll in program
  Future<bool> enrollInProgram(String programId) async {
    try {
      setLoading(true);
      clearError();

      // This would typically be handled by UserRepository
      // For now, we'll simulate enrollment by updating the current program
      if (_currentProgram?.id == programId) {
        _currentProgram = _currentProgram!.copyWith(isEnrolled: true);
        notifyListeners();
      }

      return true;
    } catch (e) {
      setError('Failed to enroll in program: ${e.toString()}');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Unenroll from program
  Future<bool> unenrollFromProgram(String programId) async {
    try {
      setLoading(true);
      clearError();

      // This would typically be handled by UserRepository
      // For now, we'll simulate unenrollment by updating the current program
      if (_currentProgram?.id == programId) {
        _currentProgram = _currentProgram!.copyWith(
          isEnrolled: false,
          progress: null,
        );
        notifyListeners();
      }

      return true;
    } catch (e) {
      setError('Failed to unenroll from program: ${e.toString()}');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Clear current program
  void clearCurrentProgram() {
    _currentProgram = null;
    notifyListeners();
  }

  /// Clear programs list
  void clearPrograms() {
    _programs = [];
    notifyListeners();
  }

  /// Clear search query
  void clearSearch() {
    _searchQuery = null;
    _programs = [];
    notifyListeners();
  }

  /// Refresh current program
  Future<void> refreshCurrentProgram() async {
    if (_currentProgram != null) {
      await loadProgram(_currentProgram!.id);
    }
  }

  @override
  void dispose() {
    _currentProgram = null;
    _programs = [];
    _featuredPrograms = [];
    _enrolledPrograms = [];
    _searchQuery = null;
    super.dispose();
  }
}
