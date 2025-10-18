import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routes/app_routes.dart';
import 'core/themes/app_theme.dart';
import 'controllers/auth_controller.dart';
import 'controllers/program_controller.dart';
import 'models/services/auth_service.dart';
import 'models/services/api_service.dart';
import 'models/services/storage_service.dart';
import 'models/repositories/program_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  final storageService = await StorageService.getInstance();

  runApp(ExcelerateApp(storageService: storageService));
}

class ExcelerateApp extends StatelessWidget {
  final StorageService storageService;

  const ExcelerateApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthController(
            authService: AuthService(
              apiService: ApiService(storageService: storageService),
              storageService: storageService,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProgramController(
            programRepository: ProgramRepository(
              apiService: ApiService(storageService: storageService),
              storageService: storageService,
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Excelerate Hub',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute:
            AppRoutes.splash, // Changed to splash to test feature directly
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
