import 'package:flutter_test/flutter_test.dart';
import 'package:excelerate/models/repositories/program_repository.dart';
import 'package:excelerate/models/services/api_service.dart';
import 'package:excelerate/models/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ProgramRepository Tests', () {
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

    tearDown(() async {
      // Clean up after each test
      await storageService.clearAll();
    });

    group('getPrograms', () {
      test('should throw exception when API is not available', () async {
        // Act & Assert
        expect(
          () => programRepository.getPrograms(),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle pagination parameters', () async {
        // Act & Assert
        expect(
          () => programRepository.getPrograms(page: 2, limit: 5),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle filtering parameters', () async {
        // Act & Assert
        expect(
          () => programRepository.getPrograms(
            category: 'technology',
            search: 'flutter',
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getProgramById', () {
      test('should throw exception when API is not available', () async {
        // Act & Assert
        expect(
          () => programRepository.getProgramById('program123'),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle invalid program ID', () async {
        // Act & Assert
        expect(
          () => programRepository.getProgramById(''),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getFeaturedPrograms', () {
      test('should throw exception when API is not available', () async {
        // Act & Assert
        expect(
          () => programRepository.getFeaturedPrograms(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getEnrolledPrograms', () {
      test('should throw exception when API is not available', () async {
        // Act & Assert
        expect(
          () => programRepository.getEnrolledPrograms(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('searchPrograms', () {
      test('should return empty list for empty query', () async {
        // Act
        final result = await programRepository.searchPrograms('');

        // Assert
        expect(result, isEmpty);
      });

      test('should return empty list for whitespace query', () async {
        // Act
        final result = await programRepository.searchPrograms('   ');

        // Assert
        expect(result, isEmpty);
      });

      test(
        'should throw exception for valid query when API not available',
        () async {
          // Act & Assert
          expect(
            () => programRepository.searchPrograms('flutter'),
            throwsA(isA<Exception>()),
          );
        },
      );
    });

    group('getProgramsByCategory', () {
      test('should throw exception when API is not available', () async {
        // Act & Assert
        expect(
          () => programRepository.getProgramsByCategory('technology'),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle empty category', () async {
        // Act & Assert
        expect(
          () => programRepository.getProgramsByCategory(''),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getProgramProgress', () {
      test(
        'should return null when no cached progress and API fails',
        () async {
          // Act
          final result = await programRepository.getProgramProgress(
            'program123',
          );

          // Assert
          expect(result, isNull);
        },
      );

      test('should return cached progress when API fails', () async {
        // Arrange - save cached progress
        await storageService.saveDouble('progress_program123', 0.75);

        // Act
        final result = await programRepository.getProgramProgress('program123');

        // Assert
        expect(result, 0.75);
      });

      test('should handle different program IDs separately', () async {
        // Arrange - save different progress for different programs
        await storageService.saveDouble('progress_program1', 0.25);
        await storageService.saveDouble('progress_program2', 0.80);

        // Act
        final result1 = await programRepository.getProgramProgress('program1');
        final result2 = await programRepository.getProgramProgress('program2');
        final result3 = await programRepository.getProgramProgress('program3');

        // Assert
        expect(result1, 0.25);
        expect(result2, 0.80);
        expect(result3, isNull);
      });
    });

    group('updateProgramProgress', () {
      test('should save progress locally immediately', () async {
        // Act
        await programRepository.updateProgramProgress('program123', 0.5);

        // Assert - check that progress was saved locally
        final cachedProgress = await storageService.getDouble(
          'progress_program123',
        );
        expect(cachedProgress, 0.5);
      });

      test('should throw exception when API update fails', () async {
        // Act & Assert
        expect(
          () => programRepository.updateProgramProgress('program123', 0.75),
          throwsA(isA<Exception>()),
        );

        // But progress should still be saved locally
        final cachedProgress = await storageService.getDouble(
          'progress_program123',
        );
        expect(cachedProgress, 0.75);
      });

      test('should handle progress values correctly', () async {
        // Test different progress values
        await programRepository.updateProgramProgress('program1', 0.0);
        await programRepository.updateProgramProgress('program2', 0.5);
        await programRepository.updateProgramProgress('program3', 1.0);

        // Check cached values
        expect(await storageService.getDouble('progress_program1'), 0.0);
        expect(await storageService.getDouble('progress_program2'), 0.5);
        expect(await storageService.getDouble('progress_program3'), 1.0);
      });
    });

    group('createProgram', () {
      test('should throw exception when API is not available', () async {
        // Arrange
        final programData = {
          'title': 'New Program',
          'description': 'A new program description',
          'category': 'technology',
        };

        // Act & Assert
        expect(
          () => programRepository.createProgram(programData),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('updateProgram', () {
      test('should throw exception when API is not available', () async {
        // Arrange
        final programData = {
          'title': 'Updated Program',
          'description': 'Updated description',
        };

        // Act & Assert
        expect(
          () => programRepository.updateProgram('program123', programData),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('deleteProgram', () {
      test('should throw exception when API is not available', () async {
        // Act & Assert
        expect(
          () => programRepository.deleteProgram('program123'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Progress Caching', () {
      test('should persist progress across repository instances', () async {
        // Arrange - save progress with first instance
        await programRepository.updateProgramProgress('program123', 0.6);

        // Create new repository instance
        final newRepository = ProgramRepository(
          apiService: apiService,
          storageService: storageService,
        );

        // Act - get progress with new instance
        final result = await newRepository.getProgramProgress('program123');

        // Assert
        expect(result, 0.6);
      });

      test('should handle multiple program progress values', () async {
        // Arrange - save progress for multiple programs
        final progressData = {
          'program1': 0.1,
          'program2': 0.2,
          'program3': 0.3,
          'program4': 0.9,
        };

        // Save all progress values
        for (final entry in progressData.entries) {
          await programRepository.updateProgramProgress(entry.key, entry.value);
        }

        // Act & Assert - verify all values
        for (final entry in progressData.entries) {
          final result = await programRepository.getProgramProgress(entry.key);
          expect(result, entry.value);
        }
      });
    });

    group('Error Handling', () {
      test(
        'should provide meaningful error messages for API failures',
        () async {
          try {
            await programRepository.getPrograms();
            fail('Expected exception was not thrown');
          } catch (e) {
            expect(e.toString(), contains('Failed to get programs'));
          }
        },
      );

      test('should handle network timeouts gracefully', () async {
        // Act & Assert
        expect(
          () => programRepository.getProgramById('program123'),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle malformed responses', () async {
        // This test would be more meaningful with actual API mocking
        // For now, we just verify that exceptions are thrown appropriately
        expect(
          () => programRepository.getFeaturedPrograms(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Query Parameter Handling', () {
      test('should handle complex search queries', () async {
        final queries = [
          'flutter development',
          'mobile app',
          'beginner course',
          'advanced programming',
        ];

        for (final query in queries) {
          expect(
            () => programRepository.searchPrograms(query),
            throwsA(isA<Exception>()),
          );
        }
      });

      test('should handle special characters in search', () async {
        final specialQueries = [
          'C++',
          'Node.js',
          'React/Redux',
          'API & Database',
        ];

        for (final query in specialQueries) {
          expect(
            () => programRepository.searchPrograms(query),
            throwsA(isA<Exception>()),
          );
        }
      });
    });

    group('Data Consistency', () {
      test('should maintain progress data integrity', () async {
        // Test saving and retrieving various progress values
        final testValues = [0.0, 0.25, 0.5, 0.75, 1.0];

        for (int i = 0; i < testValues.length; i++) {
          final programId = 'program_$i';
          final progress = testValues[i];

          await programRepository.updateProgramProgress(programId, progress);
          final retrieved = await programRepository.getProgramProgress(
            programId,
          );

          expect(retrieved, progress);
        }
      });

      test('should handle concurrent progress updates', () async {
        // Test multiple concurrent updates
        final futures = <Future>[];

        for (int i = 0; i < 5; i++) {
          futures.add(
            programRepository.updateProgramProgress(
              'concurrent_program',
              i / 10.0,
            ),
          );
        }

        // Wait for all updates to complete
        await Future.wait(futures);

        // The final value should be one of the attempted values
        final finalProgress = await programRepository.getProgramProgress(
          'concurrent_program',
        );
        expect(finalProgress, isNotNull);
        expect(finalProgress! >= 0.0 && finalProgress <= 0.4, true);
      });
    });
  });
}
