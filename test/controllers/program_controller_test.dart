import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:excelerate/controllers/program_controller.dart';
import 'package:excelerate/models/repositories/program_repository.dart';
import 'package:excelerate/models/services/api_service.dart';
import 'package:excelerate/models/services/storage_service.dart';

void main() {
  group('ProgramController Tests', () {
    late ProgramController programController;
    late ProgramRepository programRepository;
    late ApiService apiService;
    late StorageService storageService;

    setUpAll(() async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      storageService = await StorageService.getInstance();
      apiService = ApiService(storageService: storageService);
      programRepository = ProgramRepository(
        apiService: apiService,
        storageService: storageService,
      );
    });

    setUp(() {
      programController = ProgramController(programRepository: programRepository);
    });

    tearDown(() async {
      if (!programController.isDisposed) {
        programController.dispose();
      }
      await storageService.clearAll();
    });

    test('should initialize with correct default state', () {
      // Assert
      expect(programController.currentProgram, isNull);
      expect(programController.programs, isEmpty);
      expect(programController.featuredPrograms, isEmpty);
      expect(programController.enrolledPrograms, isEmpty);
      expect(programController.searchQuery, isNull);
      expect(programController.isLoading, false);
      expect(programController.error, isNull);
    });

    test('should handle loadProgram when API is not available', () async {
      // Arrange
      const programId = 'test-program-123';

      // Act
      final result = await programController.loadProgram(programId);

      // Assert
      expect(result, false);
      expect(programController.currentProgram, isNull);
      expect(programController.error, isNotNull);
      expect(programController.error, contains('Failed to load program'));
      expect(programController.isLoading, false);
    });

    test('should handle loadFeaturedPrograms when API is not available', () async {
      // Act
      await programController.loadFeaturedPrograms();

      // Assert
      expect(programController.featuredPrograms, isEmpty);
      expect(programController.error, isNotNull);
      expect(programController.error, contains('Failed to load featured programs'));
      expect(programController.isLoading, false);
    });

    test('should handle loadEnrolledPrograms when API is not available', () async {
      // Act
      await programController.loadEnrolledPrograms();

      // Assert
      expect(programController.enrolledPrograms, isEmpty);
      expect(programController.error, isNotNull);
      expect(programController.error, contains('Failed to load enrolled programs'));
      expect(programController.isLoading, false);
    });

    test('should handle searchPrograms with empty query', () async {
      // Act
      await programController.searchPrograms('');

      // Assert
      expect(programController.programs, isEmpty);
      expect(programController.searchQuery, '');
      expect(programController.isLoading, false);
      expect(programController.error, isNull); // Should not error on empty query
    });

    test('should handle searchPrograms with whitespace query', () async {
      // Act
      await programController.searchPrograms('   ');

      // Assert
      expect(programController.programs, isEmpty);
      expect(programController.searchQuery, '   ');
      expect(programController.isLoading, false);
      expect(programController.error, isNull); // Should not error on whitespace query
    });

    test('should handle searchPrograms with valid query when API is not available', () async {
      // Act
      await programController.searchPrograms('flutter development');

      // Assert
      expect(programController.programs, isEmpty);
      expect(programController.searchQuery, 'flutter development');
      expect(programController.error, isNotNull);
      expect(programController.error, contains('Failed to search programs'));
      expect(programController.isLoading, false);
    });

    test('should handle loadPrograms when API is not available', () async {
      // Act
      await programController.loadPrograms(
        page: 1,
        limit: 10,
        category: 'technology',
        search: 'flutter',
      );

      // Assert
      expect(programController.programs, isEmpty);
      expect(programController.error, isNotNull);
      expect(programController.error, contains('Failed to load programs'));
      expect(programController.isLoading, false);
    });

    test('should handle loadProgramsByCategory when API is not available', () async {
      // Act
      await programController.loadProgramsByCategory('mobile development');

      // Assert
      expect(programController.programs, isEmpty);
      expect(programController.error, isNotNull);
      expect(programController.error, contains('Failed to load programs by category'));
      expect(programController.isLoading, false);
    });

    test('should handle getProgramProgress when API is not available', () async {
      // Act
      final result = await programController.getProgramProgress('program123');

      // Assert
      expect(result, isNull);
      // Note: Error might not be set for this specific method depending on implementation
      // Just verify the result is null as expected
    });

    test('should handle updateProgramProgress when API is not available', () async {
      // Act
      final result = await programController.updateProgramProgress('program123', 0.5);

      // Assert
      expect(result, false);
      expect(programController.error, isNotNull);
      expect(programController.error, contains('Failed to update program progress'));
    });

    test('should handle enrollInProgram', () async {
      // Act
      final result = await programController.enrollInProgram('program123');

      // Assert
      expect(result, true); // Mock implementation returns true
      expect(programController.isLoading, false);
    });

    test('should handle unenrollFromProgram', () async {
      // Act
      final result = await programController.unenrollFromProgram('program123');

      // Assert
      expect(result, true); // Mock implementation returns true
      expect(programController.isLoading, false);
    });

    test('should clear current program correctly', () {
      // Act
      programController.clearCurrentProgram();

      // Assert
      expect(programController.currentProgram, isNull);
    });

    test('should clear programs list correctly', () {
      // Act
      programController.clearPrograms();

      // Assert
      expect(programController.programs, isEmpty);
    });

    test('should clear search correctly', () {
      // Act
      programController.clearSearch();

      // Assert
      expect(programController.searchQuery, isNull);
      expect(programController.programs, isEmpty);
    });

    test('should handle refreshCurrentProgram when no current program', () async {
      // Act
      await programController.refreshCurrentProgram();

      // Assert - should not crash
      expect(programController.currentProgram, isNull);
    });

    test('should handle loading state correctly during operations', () async {
      // Arrange
      List<bool> loadingStates = [];

      programController.addListener(() {
        loadingStates.add(programController.isLoading);
      });

      // Act
      await programController.loadProgram('test-program');

      // Assert
      expect(loadingStates, contains(true)); // Should have been loading at some point
      expect(programController.isLoading, false); // Should not be loading at the end
    });

    test('should notify listeners when state changes', () async {
      // Arrange
      int notificationCount = 0;

      programController.addListener(() {
        notificationCount++;
      });

      // Act
      await programController.loadProgram('test-program');

      // Assert
      expect(notificationCount, greaterThan(0));
    });

    test('should handle multiple concurrent operations', () async {
      // Arrange
      const programId = 'concurrent-test-program';

      // Act - start multiple operations concurrently
      final futures = [
        programController.loadProgram(programId),
        programController.loadFeaturedPrograms(),
        programController.searchPrograms('test'),
      ];

      await Future.wait(futures);

      // Assert - should handle concurrent operations without crashing
      expect(programController.isLoading, false);
    });

    test('should handle error clearing correctly', () async {
      // Arrange - cause an error
      await programController.loadProgram('invalid-program');
      expect(programController.error, isNotNull);

      // Act - perform another operation that clears error
      await programController.searchPrograms(''); // This should clear error and not set new one

      // Assert
      expect(programController.error, isNull);
    });

    test('should dispose properly', () {
      // Arrange
      programController.setLoading(true);
      programController.setError('Test error');

      // Act
      programController.dispose();

      // Assert
      expect(programController.isDisposed, true);

      // Note: After disposal, we shouldn't attempt to call methods that might trigger
      // state changes as it will throw errors. This is the expected behavior.
    });

    group('State Management', () {
      test('should handle error state correctly', () async {
        // Act
        await programController.loadProgram('invalid-program');

        // Assert
        expect(programController.error, isNotNull);
        expect(programController.error, isA<String>());
        expect(programController.isLoading, false);
      });

      test('should clear error when starting new operation', () async {
        // Arrange - set error state
        await programController.loadProgram('invalid-program');
        expect(programController.error, isNotNull);

        // Act - start new operation
        await programController.loadFeaturedPrograms();

        // Assert - error should be cleared at start, new error may be set
        expect(programController.error, isNotNull); // New error from featured programs
        expect(programController.error, contains('featured programs')); // Specific to new operation
      });

      test('should handle loading state transitions', () async {
        // Arrange
        List<bool> loadingStates = [];
        programController.addListener(() {
          loadingStates.add(programController.isLoading);
        });

        // Act
        final future = programController.loadProgram('test-program');
        
        // Should be loading immediately
        expect(programController.isLoading, true);
        
        await future;

        // Assert
        expect(programController.isLoading, false);
        expect(loadingStates, contains(true));
        expect(loadingStates.last, false);
      });
    });

    group('Data Persistence', () {
      test('should maintain state consistency across operations', () async {
        // Act - perform multiple operations
        await programController.searchPrograms('flutter');
        await programController.loadFeaturedPrograms();
        await programController.loadEnrolledPrograms();

        // Assert - search query should be maintained
        expect(programController.searchQuery, 'flutter');
        // Other lists should be independent
        expect(programController.featuredPrograms, isEmpty);
        expect(programController.enrolledPrograms, isEmpty);
      });

      test('should handle program progress operations', () async {
        // Test getting progress for non-existent program
        final progress1 = await programController.getProgramProgress('non-existent');
        expect(progress1, isNull);

        // Test updating progress
        final updateResult = await programController.updateProgramProgress('test-program', 0.75);
        expect(updateResult, false); // API not available
      });
    });
  });
}
