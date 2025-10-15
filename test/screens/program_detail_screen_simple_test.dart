import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:excelerate/controllers/program_controller.dart';
import 'package:excelerate/models/repositories/program_repository.dart';
import 'package:excelerate/models/services/api_service.dart';
import 'package:excelerate/models/services/storage_service.dart';
import 'package:excelerate/views/screens/programs/program_detail_screen.dart';

void main() {
  group('ProgramDetailScreen Basic Tests', () {
    late ProgramRepository programRepository;
    late StorageService storageService;
    late ApiService apiService;
    late ProgramController programController;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
    });

    setUp(() async {
      // Initialize services using the actual pattern from working tests
      storageService = await StorageService.getInstance();
      apiService = ApiService(storageService: storageService);
      programRepository = ProgramRepository(
        apiService: apiService,
        storageService: storageService,
      );
      programController = ProgramController(
        programRepository: programRepository,
      );
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

    testWidgets('should show Consumer widget', (WidgetTester tester) async {
      // Arrange
      const programId = 'test-program';

      // Act
      await tester.pumpWidget(createTestWidget(programId: programId));
      await tester.pump(); // Process the addPostFrameCallback

      // Assert - Check for basic widget presence
      expect(find.byType(Consumer<ProgramController>), findsOneWidget);
    });

    testWidgets('should handle initial state', (WidgetTester tester) async {
      // Arrange
      const programId = 'initial-test-program';

      // Act
      await tester.pumpWidget(createTestWidget(programId: programId));
      await tester.pump(); // Initial frame
      await tester.pump(); // Process postFrameCallback

      // Assert - Should show some kind of UI state
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });
  });
}
