import 'package:flutter_test/flutter_test.dart';
import 'package:excelerate/controllers/home_controller.dart';

// This is a unit test for our HomeController.
void main() {
  // A 'group' helps organize tests related to the same class.
  group('HomeController Unit Test', () {
    // 'late' means we'll give this variable a value before we use it.
    late HomeController homeController;

    // 'setUp' is a special function that runs before each test.
    // This gives us a fresh instance of the controller for every test.
    setUp(() {
      homeController = HomeController();
    });

    test('Initial state is loading', () {
      // Assert: We expect the controller to be in a loading state right after it's created.
      expect(homeController.isLoading, isTrue);
    });

    test('Data is loaded successfully after initialization', () async {
      // Act: We need to wait for the Future inside the controller to finish.
      // We can do this by waiting for a very short duration.
      await Future.delayed(const Duration(seconds: 2));

      // Assert: After loading, we check that the data is no longer null or empty.
      expect(homeController.isLoading, isFalse);
      expect(homeController.user, isNotNull);
      expect(homeController.achievements, isNotNull);
      expect(homeController.experiences, isNotEmpty);
      expect(homeController.favorites, isNotEmpty);
      expect(homeController.upcoming, isNotEmpty);
      expect(homeController.error, isNull); // We also expect no errors.
    });
  });
}
