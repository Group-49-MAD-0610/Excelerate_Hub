import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/program_controller.dart';
import 'models/repositories/program_repository.dart';
import 'models/services/api_service.dart';
import 'models/services/storage_service.dart';
import 'views/screens/programs/program_detail_screen.dart';
import 'core/themes/app_theme.dart';

/// Simple test app to directly showcase the Program Details Screen feature
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  final storageService = await StorageService.getInstance();

  runApp(ProgramDetailsTestApp(storageService: storageService));
}

class ProgramDetailsTestApp extends StatelessWidget {
  final StorageService storageService;

  const ProgramDetailsTestApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProgramController(
        programRepository: ProgramRepository(
          apiService: ApiService(storageService: storageService),
          storageService: storageService,
        ),
      ),
      child: MaterialApp(
        title: 'Program Details Feature Test',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const ProgramDetailsTestScreen(),
      ),
    );
  }
}

class ProgramDetailsTestScreen extends StatelessWidget {
  const ProgramDetailsTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Details Feature Test'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Program Details Screen Feature',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Test different program IDs to see how the screen handles various scenarios:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _TestButton(
              title: 'Valid Program ID',
              subtitle: 'Test with a sample program ID',
              onPressed: () => _navigateToProgram(context, 'program-123'),
            ),
            const SizedBox(height: 12),
            _TestButton(
              title: 'Another Program ID',
              subtitle: 'Test with different program ID',
              onPressed: () => _navigateToProgram(context, 'program-456'),
            ),
            const SizedBox(height: 12),
            _TestButton(
              title: 'Non-existent Program',
              subtitle: 'Test error handling',
              onPressed: () =>
                  _navigateToProgram(context, 'non-existent-program'),
            ),
            const SizedBox(height: 12),
            _TestButton(
              title: 'Empty Program ID',
              subtitle: 'Test with empty ID',
              onPressed: () => _navigateToProgram(context, ''),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToProgram(BuildContext context, String programId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProgramDetailScreen(programId: programId),
      ),
    );
  }
}

class _TestButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  const _TestButton({
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
