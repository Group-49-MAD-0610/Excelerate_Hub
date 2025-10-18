import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/home_controller.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../models/entities/program_model.dart';
import '../../widgets/specific/horizontal_program_card.dart';

/// Program list screen showing all available programs
class ProgramListScreen extends StatefulWidget {
  const ProgramListScreen({super.key});

  @override
  State<ProgramListScreen> createState() => _ProgramListScreenState();
}

class _ProgramListScreenState extends State<ProgramListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Reference the brand orange color from theme constants
    final brandOrangeColor = ThemeConstants.brandOrangeColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Programs', style: theme.textTheme.titleLarge),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: theme.colorScheme.onSurface),
            onPressed: () {
              // Implement filter functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Filter functionality coming soon!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  backgroundColor: brandOrangeColor,
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.spacing16,
                  vertical: ThemeConstants.spacing8,
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search programs...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        ThemeConstants.borderRadiusMedium,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              // Tab Bar
              TabBar(
                controller: _tabController,
                labelColor: brandOrangeColor, // Use brand orange for active tab
                unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: brandOrangeColor,
                labelStyle: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: theme.textTheme.labelLarge,
                tabs: const [
                  Tab(text: 'Enrolled'),
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Favorite'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Consumer<HomeController>(
        builder: (context, controller, _) {
          return TabBarView(
            controller: _tabController,
            children: [
              // Enrolled Programs Tab
              _buildProgramList(
                _filterPrograms(controller.experiences, _searchQuery),
                'You haven\'t enrolled in any programs yet.',
              ),

              // Upcoming Programs Tab
              _buildProgramList(
                _filterPrograms(controller.upcoming, _searchQuery),
                'No upcoming programs available.',
              ),

              // Favorite Programs Tab
              _buildProgramList(
                _filterPrograms(controller.favorites, _searchQuery),
                'You haven\'t added any programs to favorites.',
              ),
            ],
          );
        },
      ),
    );
  }

  List<ProgramModel> _filterPrograms(
    List<ProgramModel> programs,
    String query,
  ) {
    if (query.isEmpty) return programs;

    return programs.where((program) {
      return program.title.toLowerCase().contains(query.toLowerCase()) ||
          program.instructorName.toLowerCase().contains(query.toLowerCase()) ||
          program.category.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Widget _buildProgramList(List<ProgramModel> programs, String emptyMessage) {
    final theme = Theme.of(context);

    if (programs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: ThemeConstants.iconSizeXXLarge,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: ThemeConstants.spacing16),
            Text(
              emptyMessage,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(ThemeConstants.spacing16),
      itemCount: programs.length,
      itemBuilder: (context, index) {
        final program = programs[index];
        return HorizontalProgramCard(
          program: program,
          onTap: () => AppRoutes.toProgramDetail(context, program.id),
        );
      },
    );
  }
}
