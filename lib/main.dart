// --- COMPLETE & CORRECT MAIN.DART ---
import 'package:excelerate/controllers/home_controller.dart';
import 'package:excelerate/controllers/program_controller.dart';
import 'package:excelerate/models/repositories/program_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Firebase Imports
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// Controller and Service Imports
import 'core/routes/app_routes.dart';
import 'core/themes/app_theme.dart';
import 'controllers/auth_controller.dart';
import 'controllers/feedback_controller.dart'; // <-- Added
import 'models/services/auth_service.dart';
import 'models/services/api_service.dart';
import 'models/services/storage_service.dart';

void main() async {
  // 1. Initialize Flutter and Firebase Core
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize storage service
  final storageService = await StorageService.getInstance();

  runApp(ExcelerateApp(storageService: storageService));
}

class ExcelerateApp extends StatelessWidget {
  final StorageService storageService;

  const ExcelerateApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    // Setup necessary services
    final apiService = ApiService(storageService: storageService);
    final programRepository = ProgramRepository(
      apiService: apiService,
      storageService: storageService,
    );

    return MultiProvider(
      providers: [
        // AUTH CONTROLLER (Firebase Login/Register)
        ChangeNotifierProvider(
          create: (_) => AuthController(
            authService: AuthService(
              // Uses Firebase logic
              apiService: apiService,
              storageService: storageService,
            ),
          ),
        ),
        // HOME CONTROLLER
        ChangeNotifierProvider(create: (_) => HomeController()),
        // PROGRAM CONTROLLER
        ChangeNotifierProvider(
          create: (_) =>
              ProgramController(programRepository: programRepository),
        ),
        // FEEDBACK CONTROLLER (Firestore Submission)
        ChangeNotifierProvider(create: (_) => FeedbackController()),
      ],
      child: MaterialApp(
        title: 'Excelerate Hub',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.login, // Start at login
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
