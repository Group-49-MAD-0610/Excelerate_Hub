import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/program_controller.dart';
import '../../../models/entities/program_model.dart';
import '../../../core/constants/theme_constants.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/programs/program_header.dart';
import '../../widgets/programs/program_info.dart';
import '../../widgets/programs/program_curriculum.dart';
import '../../widgets/programs/instructor_info.dart';

/// Program detail screen showing specific program information
class ProgramDetailScreen extends StatefulWidget {
  final String programId;

  const ProgramDetailScreen({super.key, required this.programId});

  @override
  State<ProgramDetailScreen> createState() => _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends State<ProgramDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isEnrollmentLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load program details when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgramController>().loadProgram(widget.programId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<ProgramController>(
        builder: (context, programController, child) {
          if (programController.isLoading &&
              programController.currentProgram == null) {
            return const Scaffold(
              body: Center(
                child: LoadingIndicator(message: 'Loading program details...'),
              ),
            );
          }

          if (programController.error != null &&
              programController.currentProgram == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Program Details'),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: ThemeConstants.spacing16),
                    Text(
                      'Failed to load program',
                      style: TextStyle(
                        fontSize: ThemeConstants.bodyLargeFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: ThemeConstants.spacing8),
                    Text(
                      programController.error ?? 'Unknown error occurred',
                      style: TextStyle(
                        fontSize: ThemeConstants.bodyMediumFontSize,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: ThemeConstants.spacing24),
                    ElevatedButton(
                      onPressed: () {
                        programController.loadProgram(widget.programId);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final program = programController.currentProgram;
          if (program == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Program Details'),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
              ),
              body: const Center(child: Text('Program not found')),
            );
          }

          return _buildProgramDetails(context, program, programController);
        },
      ),
    );
  }

  Widget _buildProgramDetails(
    BuildContext context,
    ProgramModel program,
    ProgramController programController,
  ) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
            elevation: 0,
            title: Text(
              program.title,
              style: const TextStyle(
                fontSize: ThemeConstants.bodyLargeFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // TODO: Implement share functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share feature coming soon!')),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  // TODO: Implement favorite functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Favorite feature coming soon!'),
                    ),
                  );
                },
              ),
            ],
          ),
        ];
      },
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ThemeConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Program Header
            ProgramHeader(
              program: program,
              isLoading: _isEnrollmentLoading,
              onEnrollPressed: () => _handleEnrollment(context, program, true),
              onUnenrollPressed: () =>
                  _handleEnrollment(context, program, false),
            ),

            const SizedBox(height: ThemeConstants.spacing24),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(
                  ThemeConstants.borderRadiusMedium,
                ),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: ThemeConstants.primaryColor,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: ThemeConstants.primaryColor,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Curriculum'),
                  Tab(text: 'Instructor'),
                ],
              ),
            ),

            const SizedBox(height: ThemeConstants.spacing16),

            // Tab Content
            SizedBox(
              height: 600, // Fixed height for tab content
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Overview Tab
                  SingleChildScrollView(
                    child: ProgramInfo(
                      description: program.description,
                      requirements: program.requirements,
                      outcomes: program.outcomes,
                      tags: program.tags,
                    ),
                  ),

                  // Curriculum Tab
                  SingleChildScrollView(
                    child: ProgramCurriculum(curriculum: program.curriculum),
                  ),

                  // Instructor Tab
                  SingleChildScrollView(
                    child: InstructorInfo(
                      instructorId: program.instructorId,
                      instructorName: program.instructorName,
                      instructorAvatar: program.instructorAvatar,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleEnrollment(
    BuildContext context,
    ProgramModel program,
    bool isEnrolling,
  ) async {
    setState(() {
      _isEnrollmentLoading = true;
    });

    try {
      final programController = context.read<ProgramController>();
      bool success;

      if (isEnrolling) {
        success = await programController.enrollInProgram(program.id);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully enrolled in ${program.title}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        success = await programController.unenrollFromProgram(program.id);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully unenrolled from ${program.title}'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to ${isEnrolling ? 'enroll in' : 'unenroll from'} program',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isEnrollmentLoading = false;
        });
      }
    }
  }
}
