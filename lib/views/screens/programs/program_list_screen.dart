import 'package:flutter/material.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../models/entities/program_model.dart';
import '../../../core/routes/app_routes.dart';

/// Program list screen organized by user engagement status
///
/// Features:
/// - Programs organized by: Enrolled, Upcoming, Favorites
/// - Rewards section showing benefits and recognition
/// - Apply and Know More buttons for each program
/// - Search functionality for finding specific programs
/// - Modern card-based program display with enhanced information
class ProgramListScreen extends StatefulWidget {
  const ProgramListScreen({super.key});

  @override
  State<ProgramListScreen> createState() => _ProgramListScreenState();
}

class _ProgramListScreenState extends State<ProgramListScreen> {
  // State variables
  final TextEditingController _searchController = TextEditingController();
  String _selectedTab = 'Enrolled';
  bool _isLoading = false;
  bool _isSearchVisible = false;
  List<ProgramModel> _enrolledPrograms = [];
  List<ProgramModel> _upcomingPrograms = [];
  List<ProgramModel> _favoritePrograms = [];
  List<ProgramModel> _filteredPrograms = [];

  // Program categories for organization
  final List<String> _tabs = ['Enrolled', 'Upcoming', 'Favorites'];

  @override
  void initState() {
    super.initState();
    _loadPrograms();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.appBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar
          _buildAppBar(),

          // Search Bar (conditionally visible)
          if (_isSearchVisible)
            SliverToBoxAdapter(child: _buildSearchSection()),

          // Program Tabs (Enrolled, Upcoming, Favorites)
          SliverToBoxAdapter(child: _buildProgramTabs()),

          // Programs List
          _isLoading ? _buildLoadingSliver() : _buildProgramsList(),
        ],
      ),
    );
  }

  /// Builds the app bar with title and actions
  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: ThemeConstants.surfaceColor,
      foregroundColor: Colors.black87,
      elevation: 0,
      pinned: true,
      floating: false,
      automaticallyImplyLeading: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded),
        onPressed: () => Navigator.of(context).pop(),
        tooltip: 'Back',
      ),
      title: const Text(
        'Programs',
        style: TextStyle(
          fontSize: 24,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: _toggleSearch,
          tooltip: 'Search Programs',
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications coming soon!')),
            );
          },
          tooltip: 'Notifications',
        ),
        const SizedBox(width: ThemeConstants.spacing8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: ThemeConstants.outlineColor),
      ),
    );
  }

  /// Builds the search section
  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.spacing20),
      child: Container(
        decoration: BoxDecoration(
          color: ThemeConstants.surfaceColor,
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search programs...',
            hintStyle: TextStyle(
              color: ThemeConstants.onSurfaceVariantColor,
              fontFamily: 'Poppins',
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: ThemeConstants.onSurfaceVariantColor,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: _clearSearch,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.spacing16,
              vertical: ThemeConstants.spacing16,
            ),
          ),
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
        ),
      ),
    );
  }

  /// Builds the rewards section showcasing program benefits

  /// Builds program category tabs (Enrolled, Upcoming, Favorites)
  Widget _buildProgramTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ThemeConstants.spacing20,
        ThemeConstants.spacing20,
        ThemeConstants.spacing20,
        ThemeConstants.spacing20,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: ThemeConstants.surfaceColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: _tabs.map((tab) {
            final isSelected = tab == _selectedTab;
            return Expanded(
              child: GestureDetector(
                onTap: () => _onTabSelected(tab),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: ThemeConstants.spacing16,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ThemeConstants.accentColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      ThemeConstants.borderRadiusMedium,
                    ),
                  ),
                  child: Text(
                    tab,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : ThemeConstants.onSurfaceColor,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Builds the programs list based on selected tab
  Widget _buildProgramsList() {
    if (_filteredPrograms.isEmpty) {
      return _buildEmptyState();
    }

    return _buildListView();
  }

  /// Builds list view of programs
  Widget _buildListView() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.spacing20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: ThemeConstants.spacing16),
            child: _buildProgramListCard(_filteredPrograms[index]),
          ),
          childCount: _filteredPrograms.length,
        ),
      ),
    );
  }

  /// Builds a program card for list view with Apply and Know More buttons
  Widget _buildProgramListCard(ProgramModel program) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Program Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        ThemeConstants.primaryColor.withValues(alpha: 0.8),
                        ThemeConstants.secondaryColor.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 28,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: ThemeConstants.spacing16),

                // Program Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        program.title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        program.instructorName,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: ThemeConstants.spacing16),

            // Program Meta Info
            Row(
              children: [
                _buildMetaInfo(Icons.schedule_outlined, program.duration),
              ],
            ),

            const SizedBox(height: ThemeConstants.spacing16),

            // Program Benefits Section
            _buildProgramBenefits(),

            const SizedBox(height: ThemeConstants.spacing20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _applyToProgram(program),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeConstants.accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: ThemeConstants.spacing12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ThemeConstants.borderRadiusMedium,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: ThemeConstants.spacing12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _navigateToProgram(program),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: ThemeConstants.accentColor,
                      side: BorderSide(
                        color: ThemeConstants.accentColor,
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: ThemeConstants.spacing12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ThemeConstants.borderRadiusMedium,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Know More',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds meta information items (duration, enrollment, rating)
  Widget _buildMetaInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: ThemeConstants.onSurfaceVariantColor),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  /// Builds empty state when no programs found
  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: ThemeConstants.onSurfaceVariantColor,
            ),
            const SizedBox(height: ThemeConstants.spacing16),
            Text(
              'No programs found',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ThemeConstants.onSurfaceVariantColor,
              ),
            ),
            const SizedBox(height: ThemeConstants.spacing8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: ThemeConstants.onSurfaceVariantColor,
              ),
            ),
            const SizedBox(height: ThemeConstants.spacing24),
            ElevatedButton(
              onPressed: _clearFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeConstants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.spacing24,
                  vertical: ThemeConstants.spacing12,
                ),
              ),
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds loading state
  Widget _buildLoadingSliver() {
    return const SliverFillRemaining(
      child: Center(child: CircularProgressIndicator()),
    );
  }

  // Event Handlers
  // ═══════════════════════════════════════════════════════════════════════════════

  void _onSearchChanged() {
    _filterPrograms();
  }

  void _onTabSelected(String tab) {
    setState(() {
      _selectedTab = tab;
    });
    _filterPrograms();
  }

  void _clearSearch() {
    _searchController.clear();
    _filterPrograms();
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _selectedTab = 'Enrolled';
    });
    _filterPrograms();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchController.clear();
        _filterPrograms();
      }
    });
  }

  void _navigateToProgram(ProgramModel program) {
    AppRoutes.toProgramDetail(context, program.id);
  }

  void _applyToProgram(ProgramModel program) {
    // Show application confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied to ${program.title} successfully!'),
        backgroundColor: ThemeConstants.successColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Data Methods
  // ═══════════════════════════════════════════════════════════════════════════════

  Future<void> _loadPrograms() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call with dummy data
    await Future.delayed(const Duration(milliseconds: 800));

    final dummyPrograms = _generateDummyPrograms();

    if (mounted) {
      setState(() {
        // Organize programs by categories
        _enrolledPrograms = dummyPrograms.where((p) => p.isEnrolled).toList();
        _upcomingPrograms = dummyPrograms
            .where(
              (p) =>
                  !p.isEnrolled &&
                  p.createdAt.isAfter(
                    DateTime.now().subtract(const Duration(days: 7)),
                  ),
            )
            .toList();
        _favoritePrograms = dummyPrograms.take(3).toList(); // Mock favorites
        _isLoading = false;
      });
      _filterPrograms();
    }
  }

  void _filterPrograms() {
    final query = _searchController.text.toLowerCase();

    List<ProgramModel> sourceList;
    switch (_selectedTab) {
      case 'Enrolled':
        sourceList = _enrolledPrograms;
        break;
      case 'Upcoming':
        sourceList = _upcomingPrograms;
        break;
      case 'Favorites':
        sourceList = _favoritePrograms;
        break;
      default:
        sourceList = [];
    }

    final filtered = sourceList.where((program) {
      return query.isEmpty ||
          program.title.toLowerCase().contains(query) ||
          program.description.toLowerCase().contains(query) ||
          program.instructorName.toLowerCase().contains(query);
    }).toList();

    setState(() {
      _filteredPrograms = filtered;
    });
  }

  List<ProgramModel> _generateDummyPrograms() {
    final now = DateTime.now();
    return [
      // Enrolled Programs
      ProgramModel(
        id: 'prog-1',
        title: 'Machine Learning Fundamentals',
        description: 'Learn the basics of machine learning and AI',
        category: 'Technology',
        duration: '8 weeks',
        level: 'Beginner',
        instructorId: 'inst-1',
        instructorName: 'St. Louis University',
        enrollmentCount: 1250,
        rating: 4.8,
        reviewCount: 89,
        isEnrolled: true,
        progress: 65.0,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      ProgramModel(
        id: 'prog-2',
        title: 'Project Management Professional',
        description: 'Master project management methodologies',
        category: 'Business & Management',
        duration: '12 weeks',
        level: 'Intermediate',
        instructorId: 'inst-2',
        instructorName: 'Harvard Business School',
        enrollmentCount: 890,
        rating: 4.9,
        reviewCount: 156,
        isEnrolled: true,
        progress: 25.0,
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),

      // Upcoming Programs
      ProgramModel(
        id: 'prog-3',
        title: 'UI/UX Design Bootcamp',
        description: 'Create stunning user interfaces and experiences',
        category: 'Design',
        duration: '6 weeks',
        level: 'Beginner',
        instructorId: 'inst-3',
        instructorName: 'Design Academy',
        enrollmentCount: 567,
        rating: 4.7,
        reviewCount: 78,
        isEnrolled: false,
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      ProgramModel(
        id: 'prog-4',
        title: 'Data Science with Python',
        description: 'Analyze data and build predictive models',
        category: 'Data Science',
        duration: '10 weeks',
        level: 'Intermediate',
        instructorId: 'inst-4',
        instructorName: 'MIT OpenCourseWare',
        enrollmentCount: 1456,
        rating: 4.8,
        reviewCount: 203,
        isEnrolled: false,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      ProgramModel(
        id: 'prog-5',
        title: 'Digital Marketing Strategy',
        description: 'Master modern digital marketing techniques',
        category: 'Marketing',
        duration: '8 weeks',
        level: 'Beginner',
        instructorId: 'inst-5',
        instructorName: 'Google Digital Academy',
        enrollmentCount: 2103,
        rating: 4.6,
        reviewCount: 298,
        isEnrolled: false,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
      ),
      ProgramModel(
        id: 'prog-6',
        title: 'Advanced JavaScript Development',
        description: 'Build modern web applications with JavaScript',
        category: 'Technology',
        duration: '14 weeks',
        level: 'Advanced',
        instructorId: 'inst-6',
        instructorName: 'freeCodeCamp',
        enrollmentCount: 1789,
        rating: 4.9,
        reviewCount: 245,
        isEnrolled: false,
        createdAt: now.add(const Duration(days: 5)),
        updatedAt: now,
      ),
    ];
  }

  /// Builds program benefits section for each program card
  Widget _buildProgramBenefits() {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spacing12),
      decoration: BoxDecoration(
        color: ThemeConstants.surfaceVariantColor,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
        border: Border.all(color: ThemeConstants.outlineColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Benefits Title
          Row(
            children: [
              Icon(
                Icons.star_rounded,
                color: ThemeConstants.warningColor,
                size: ThemeConstants.iconSizeMedium,
              ),
              const SizedBox(width: ThemeConstants.spacing8),
              const Text(
                'Program Benefits',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: ThemeConstants.spacing12),

          // Benefits Grid
          Row(
            children: [
              Expanded(
                child: _buildBenefitItem(
                  'Certificate',
                  'Global Recognition',
                  Icons.workspace_premium_rounded,
                  ThemeConstants.primaryColor,
                ),
              ),
              const SizedBox(width: ThemeConstants.spacing8),
              Expanded(
                child: _buildBenefitItem(
                  'Scholarship',
                  '\$1,000',
                  Icons.card_giftcard_rounded,
                  ThemeConstants.successColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: ThemeConstants.spacing8),

          Row(
            children: [
              Expanded(
                child: _buildBenefitItem(
                  'Skills',
                  'Collaboration',
                  Icons.lightbulb_outline_rounded,
                  ThemeConstants.warningColor,
                ),
              ),
              const SizedBox(width: ThemeConstants.spacing8),
              Expanded(
                child: _buildBenefitItem(
                  'Duration',
                  'Flexible',
                  Icons.schedule_outlined,
                  ThemeConstants.infoColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds individual benefit item for program cards
  Widget _buildBenefitItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spacing8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusSmall),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          Text(
            description,
            style: const TextStyle(
              fontSize: 8,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
