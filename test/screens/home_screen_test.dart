import 'package:excelerate/controllers/home_controller.dart';
import 'package:excelerate/views/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

Widget createHomeScreen() {
  return ChangeNotifierProvider<HomeController>(
    create: (_) => HomeController(),
    child: const MaterialApp(home: Scaffold(body: HomeContent())),
  );
}

void main() {
  group('Home Screen Widget Test', () {
    // NOTE: These tests are temporarily skipped to address a persistent
    // issue with mocking HttpClient for NetworkImage.

    testWidgets(
      'Shows loading indicator then settles correctly',
      (widgetTester) async {
        await widgetTester.pumpWidget(createHomeScreen());
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await widgetTester.pumpAndSettle();
        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
      skip: true,
      //Skipping because of Http mock issues
    );

    testWidgets(
      'Shows program lists when data is loaded',
      (widgetTester) async {
        await widgetTester.pumpWidget(createHomeScreen());
        await widgetTester.pumpAndSettle();
        expect(find.text("You've Achieved"), findsOneWidget);
        expect(find.text('Your Experiences'), findsOneWidget);
      },
      skip: true,
      //Skipping because of Http mock issues
    );
  });
}
