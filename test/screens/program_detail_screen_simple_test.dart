import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:excelerate/controllers/program_controller.dart';
import 'package:excelerate/models/program_model.dart';
import 'package:excelerate/repositories/program_repository.dart';
import 'package:excelerate/services/storage_service.dart';
import 'package:excelerate/views/screens/programs/program_detail_screen.dart';

import '../controllers/program_controller_test.mocks.dart';

void main() {
  group('ProgramDetailScreen Basic Tests', () {
    late MockProgramRepository programRepository;
    late StorageService storageService;
    late ProgramController programController;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      programRepository = MockProgramRepository();
      storageService = StorageService();
      await storageService.init();

      programController = ProgramController(programRepository: programRepository);
    });

    tearDown(() async {
      await storageService.clearAll();
    });

    Widget createTestWidget({required String programId}) {
      return MaterialApp(
        home: ChangeNotifierProvider<ProgramController>.value(
          value: programController,
          child: ProgramDetailScreen(programId: programId),
        ),
      );
    }

    testWidgets('should build without crashing', (WidgetTester tester) async {
      // Arrange
      const programId = 'test-program';

      // Act & Assert - Just verify it builds without throwing
      await tester.pumpWidget(createTestWidget(programId: programId));
      expect(find.byType(ProgramDetailScreen), findsOneWidget);
    });

    testWidgets('should show some content', (WidgetTester tester) async {
      // Arrange
      const programId = 'test-program';

      // Act
      await tester.pumpWidget(createTestWidget(programId: programId));
      await tester.pump(); // Process the addPostFrameCallback

      // Assert - Check for basic widget presence
      expect(find.byType(Consumer<ProgramController>), findsOneWidget);
    });

    testWidgets('should handle error state', (WidgetTester tester) async {
      // Arrange
      const programId = 'error-program';
      
      // Mock the repository to throw an error
      when(programRepository.getProgramById(programId))
          .thenThrow(Exception('Test error'));

      // Act
      await tester.pumpWidget(createTestWidget(programId: programId));
      await tester.pump(); // Initial frame
      await tester.pump(); // Process postFrameCallback
      await tester.pump(const Duration(seconds: 1)); // Allow async operation to complete

      // Assert - Should show error state
      expect(find.text('Failed to load program'), findsOneWidget);
    });

    testWidgets('should show successful program load', (WidgetTester tester) async {
      // Arrange
      const programId = 'success-program';
      final mockProgram = ProgramModel(
        id: programId,
        title: 'Test Program',
        description: 'Test Description',
        imageUrl: 'test.jpg',
        instructorName: 'Test Instructor',
        duration: '4 weeks',
        difficulty: 'Beginner',
        rating: 4.5,
        enrolledCount: 100,
        price: 99.99,
        category: 'Technology',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        skills: ['Skill 1', 'Skill 2'],
        curriculum: [],
        prerequisites: [],
        isActive: true,
      );

      when(programRepository.getProgramById(programId))
          .thenAnswer((_) async => mockProgram);

      // Act
      await tester.pumpWidget(createTestWidget(programId: programId));
      await tester.pump(); // Initial frame
      await tester.pump(); // Process postFrameCallback
      await tester.pump(const Duration(seconds: 1)); // Allow async operation to complete

      // Assert - Should show program content
      expect(find.text('Test Program'), findsOneWidget);
    });
  });
}
