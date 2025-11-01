// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:excelerate/main.dart';
import 'package:excelerate/models/services/storage_service.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    // Initialize storage service for testing
    final storageService = await StorageService.getInstance();

    // Build our app and trigger a frame.
    await tester.pumpWidget(ExcelerateApp(storageService: storageService));

    // Verify that the app launches without crashing
    await tester.pumpAndSettle();

    // This test just ensures the app can be created without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
