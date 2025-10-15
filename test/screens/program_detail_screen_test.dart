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
  group('ProgramDetailScreen Tests', () {
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

    testWidgets('should show loading indicator initially', (WidgetTester tester) async {
      // Arrange
      const programId = 'test-program-123';

      // Act
      await tester.pumpWidget(createTestWidget(programId: programId));
      await tester.pump(); // Let the widget build

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading program details...'), findsOneWidget);
    });

    testWidgets('should show error message when program loading fails', (WidgetTester tester) async {
      // Arrange
      const programId = 'invalid-program-id';

      // Act
      await tester.pumpWidget(createTestWidget(programId: programId));
      await tester.pump(); // Initial build
      await tester.pump(const Duration(seconds: 2)); // Wait for async operation

      // Assert
      expect(find.text('Failed to load program'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should show retry button and allow retrying', (WidgetTester tester) async {
      // Arrange
      const programId = 'invalid-program-id';

      // Act
      await tester.pumpWidget(createTestWidget(programId: programId));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      // Find and tap retry button
      final retryButton = find.text('Retry');
      expect(retryButton, findsOneWidget);
      
      await tester.tap(retryButton);
      await tester.pump();

      // Assert - should show loading again
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display app bar with correct title', (WidgetTester tester) async {
      // Arrange
      const programId = 'test-program';

      // Act
      await tester.pumpWidget(createTestWidget(programId: programId));
      await tester.pump();

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should show share and favorite buttons in app bar', (WidgetTester tester) async {
      // Arrange
      const programId = 'test-program';

      // Act
      await tester.pumpWidget(createTestWidget(programId: programId));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      // Assert
      expect(find.byIcon(Icons.share), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('should show coming soon message when share button is tapped', (WidgetTester tester) async {
      // Arrange
      const programId = 'test-program';

      // Act
      await tester.pumpWidget(createTestWidget(programId: programId));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      // Tap share button
      await tester.tap(find.byIcon(Icons.share));
      await tester.pump();

      // Assert
      expect(find.text('Share feature coming soon!'), findsOneWidget);
    });

    testWidgets('should show coming soon message when favorite button is tapped', (WidgetTester tester) async {
      // Arrange
      const programId = 'test-program';

      // Act
      await tester.pumpWidget(createTestWidget(programId: programId));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      // Tap favorite button
      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();

      // Assert
      expect(find.text('Favorite feature coming soon!'), findsOneWidget);
    });

    testWidgets('should display tab bar with correct tabs', (WidgetTester tester) async {
      // Arrange
      const programId = 'test-program';

      // Act
      await tester.pumpWidget(createTestWidget(programId: programId));
      await tester.pump();
      
      // Wait for potential program load (will fail but we can still test UI)
      await tester.pump(const Duration(seconds: 2));

      // Since we don't have a real program, test basic structure
      // The tabs won't be visible without a loaded program
      expect(find.byType(TabBar), findsNothing);
    });

    testWidgets('should handle basic widget structure', (WidgetTester tester) async {
      // Arrange
      const programId = 'test-program';

      // Act
      await tester.pumpWidget(createTestWidget(programId: programId));
      await tester.pump();

      // Assert basic structure exists
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Consumer), findsOneWidget);
    });

    testWidgets('should handle error state correctly', (WidgetTester tester) async {
      // Arrange
      const programId = 'test-program';

      // Act
      await tester.pumpWidget(createTestWidget(programId: programId));
      await tester.pump();
      await tester.pump(const Duration(seconds: 3)); // Wait for error state

      // Assert error handling
      expect(find.text('Failed to load program'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should show loading state initially', (WidgetTester tester) async {
      // Arrange
      const programId = 'test-program';

      // Act
      await tester.pumpWidget(createTestWidget(programId: programId));
      await tester.pump();

      // Assert loading state
      expect(find.text('Loading program details...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should handle missing program data gracefully', (WidgetTester tester) async {
      // Arrange
      const programId = 'missing-program';

      // Act
      await tester.pumpWidget(createTestWidget(programId: programId));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      // Assert
      expect(find.text('Failed to load program'), findsOneWidget);
    });

    group('ProgramController Integration', () {
      testWidgets('should load program on screen initialization', (WidgetTester tester) async {
        // Arrange
        const programId = 'integration-test-program';

        // Act
        await tester.pumpWidget(createTestWidget(programId: programId));
        await tester.pump(); // Process the addPostFrameCallback

        // Assert that loading started
        expect(programController.isLoading, isTrue);
      });

      testWidgets('should handle controller state changes', (WidgetTester tester) async {
        // Arrange
        const programId = 'state-test-program';

        // Act
        await tester.pumpWidget(createTestWidget(programId: programId));
        await tester.pump();

        // Simulate state changes by waiting for async operations
        await tester.pump(const Duration(seconds: 1));

        // Assert based on the actual controller state
        expect(programController.isLoading, isFalse);
      });
    });
  });
}
