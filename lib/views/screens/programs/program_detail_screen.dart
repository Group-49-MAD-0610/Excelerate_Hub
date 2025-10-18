import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/home_controller.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../models/entities/program_model.dart';

/// Program detail screen showing specific program information
class ProgramDetailScreen extends StatefulWidget {
  final String programId;
  static const String routeName = '/program-detail';

  const ProgramDetailScreen({super.key, required this.programId});

  @override
  State<ProgramDetailScreen> createState() => _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends State<ProgramDetailScreen> {
  bool _isEnrolled = false;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, _) {
        // Find the program in any of the lists
        ProgramModel? program;

        try {
          program = controller.experiences.firstWhere(
            (p) => p.id == widget.programId,
            orElse: () => controller.upcoming.firstWhere(
              (p) => p.id == widget.programId,
              orElse: () => controller.favorites.firstWhere(
                (p) => p.id == widget.programId,
                orElse: () => throw Exception('Program not found'),
              ),
            ),
          );
        } catch (e) {
          final theme = Theme.of(context);

          return Scaffold(
            appBar: AppBar(
              title: Text('Program Details', style: theme.textTheme.titleLarge),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: ThemeConstants.iconSizeXXLarge,
                    color: ThemeConstants.errorColor,
                  ),
                  const SizedBox(height: ThemeConstants.spacing16),
                  Text('Program not found', style: theme.textTheme.titleLarge),
                  const SizedBox(height: ThemeConstants.spacing8),
                  Text(
                    'ID: ${widget.programId}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // App Bar with Program Image
              SliverAppBar(
                expandedHeight: 200.0,
                pinned: true,
                actions: [
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isFavorite
                                ? 'Added to favorites'
                                : 'Removed from favorites',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                          ),
                          backgroundColor: ThemeConstants.brandOrangeColor,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Share functionality coming soon!',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                          ),
                          backgroundColor: ThemeConstants.brandOrangeColor,
                        ),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: program.imageUrl != null
                      ? Image.network(
                          program.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                                child: Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: ThemeConstants.iconSizeXXLarge,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                        )
                      : Container(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          child: Center(
                            child: Icon(
                              Icons.school,
                              size: ThemeConstants.iconSizeXXLarge,
                              color: ThemeConstants.brandOrangeColor,
                            ),
                          ),
                        ),
                ),
              ),

              // Program Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Category
                      Text(
                        program.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: ThemeConstants.primaryFontFamily,
                            ),
                      ),
                      const SizedBox(height: ThemeConstants.spacing8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: ThemeConstants.spacing12,
                              vertical: ThemeConstants.spacing8 - 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                                // ignore: deprecated_member_use
                              ).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                ThemeConstants.borderRadiusLarge,
                              ),
                            ),
                            child: Text(
                              program.category,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          const SizedBox(width: ThemeConstants.spacing8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: ThemeConstants.spacing12,
                              vertical: ThemeConstants.spacing8 - 2,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeConstants.brandOrangeColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                ThemeConstants.borderRadiusLarge,
                              ),
                            ),
                            child: Text(
                              program.level,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: ThemeConstants.brandOrangeColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Instructor Information
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surfaceVariant,
                            backgroundImage: program.instructorAvatar != null
                                ? NetworkImage(program.instructorAvatar!)
                                : null,
                            child: program.instructorAvatar == null
                                ? Text(
                                    program.instructorName.isNotEmpty
                                        ? program.instructorName[0]
                                              .toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                      color: ThemeConstants.brandOrangeColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(width: ThemeConstants.spacing12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                program.instructorName,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Instructor',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.6),
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Key Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInfoItem(
                            Icons.schedule,
                            program.duration,
                            'Duration',
                          ),
                          _buildInfoItem(
                            Icons.people,
                            '${program.enrollmentCount}',
                            'Students',
                          ),
                          _buildInfoItem(
                            Icons.star,
                            program.rating.toString(),
                            'Rating',
                          ),
                        ],
                      ),

                      SizedBox(height: ThemeConstants.spacing24),
                      Divider(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withOpacity(0.3),
                      ),
                      SizedBox(height: ThemeConstants.spacing16),

                      // Description
                      Text(
                        'About This Course',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: ThemeConstants.primaryFontFamily,
                            ),
                      ),
                      SizedBox(height: ThemeConstants.spacing12),
                      Text(
                        program.description.isNotEmpty
                            ? program.description
                            : 'Dive into the world of intelligent systems that learn from data! This course introduces the core concepts of ML, from data preprocessing to model building and evaluation — helping you understand how machines make predictions, recognize patterns, and improve over time.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          height: 1.5,
                        ),
                      ),

                      SizedBox(height: ThemeConstants.spacing24),

                      // What You'll Learn
                      Text(
                        'What You\'ll Learn',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: ThemeConstants.primaryFontFamily,
                            ),
                      ),
                      SizedBox(height: ThemeConstants.spacing12),
                      Column(
                        children: [
                          ...program.outcomes.isNotEmpty
                              ? program.outcomes.map(
                                  (outcome) => _buildOutcomeItem(outcome),
                                )
                              : [
                                  _buildOutcomeItem(
                                    'Learn to preprocess and explore data effectively',
                                  ),
                                  _buildOutcomeItem(
                                    'Build and evaluate machine learning models',
                                  ),
                                  _buildOutcomeItem(
                                    'Apply ML algorithms to real-world problems',
                                  ),
                                  _buildOutcomeItem(
                                    'Understand model performance metrics',
                                  ),
                                ],
                        ],
                      ),

                      SizedBox(height: ThemeConstants.spacing24),
                      Divider(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withOpacity(0.3),
                      ),
                      SizedBox(height: ThemeConstants.spacing24),

                      // Course Curriculum Summary
                      Text(
                        'Course Curriculum',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: ThemeConstants.primaryFontFamily,
                            ),
                      ),
                      SizedBox(height: ThemeConstants.spacing16),

                      // Show curriculum if available, otherwise placeholder
                      if (program.curriculum.isNotEmpty)
                        ...program.curriculum.map(
                          (week) => _buildWeekItem(week),
                        )
                      else ...[
                        _buildWeekItem(
                          const CurriculumWeek(
                            week: 1,
                            title: 'Introduction to Machine Learning',
                            topics: [
                              'What is ML?',
                              'Types of ML',
                              'ML workflow',
                            ],
                          ),
                        ),
                        _buildWeekItem(
                          const CurriculumWeek(
                            week: 2,
                            title: 'Data Preprocessing',
                            topics: [
                              'Data cleaning',
                              'Feature engineering',
                              'Data visualization',
                            ],
                          ),
                        ),
                        _buildWeekItem(
                          const CurriculumWeek(
                            week: 3,
                            title: 'Supervised Learning',
                            topics: [
                              'Linear regression',
                              'Classification',
                              'Model evaluation',
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomSheet: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ThemeConstants.spacing16,
              vertical: ThemeConstants.spacing12,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.formattedPrice,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (program.isFree)
                      Text(
                        'Limited time offer',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: ThemeConstants.successColor,
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEnrolled = !_isEnrolled;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isEnrolled
                              ? 'Successfully enrolled in this program'
                              : 'Enrollment canceled',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                        backgroundColor: ThemeConstants.brandOrangeColor,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: ThemeConstants.spacing32,
                      vertical: ThemeConstants.spacing16,
                    ),
                    backgroundColor: ThemeConstants.brandOrangeColor,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: Text(
                    _isEnrolled ? 'Cancel Enrollment' : 'Enroll Now',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: ThemeConstants.brandOrangeColor),
        SizedBox(height: ThemeConstants.spacing8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ThemeConstants.spacing4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildOutcomeItem(String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ThemeConstants.spacing4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: ThemeConstants.brandOrangeColor,
            size: 20,
          ),
          SizedBox(width: ThemeConstants.spacing12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekItem(CurriculumWeek week) {
    final theme = Theme.of(context);
    final brandOrangeColor = ThemeConstants.brandOrangeColor;

    return Container(
      margin: EdgeInsets.only(bottom: ThemeConstants.spacing16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          'Week ${week.week}: ${week.title}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${week.topics.length} lessons',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: brandOrangeColor.withOpacity(0.1),
          child: Text(
            '${week.week}',
            style: TextStyle(
              color: brandOrangeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        trailing: Icon(
          week.isCompleted ? Icons.check_circle : Icons.keyboard_arrow_down,
          color: week.isCompleted
              ? ThemeConstants.successColor
              : theme.colorScheme.onSurface.withOpacity(0.5),
        ),
        childrenPadding: EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacing16,
          vertical: ThemeConstants.spacing8,
        ),
        children: [
          if (week.description.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: ThemeConstants.spacing12),
              child: Text(
                week.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          ...week.topics.map(
            (topic) => Padding(
              padding: EdgeInsets.symmetric(vertical: ThemeConstants.spacing4),
              child: Row(
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    size: 20,
                    color: brandOrangeColor.withOpacity(0.8),
                  ),
                  SizedBox(width: ThemeConstants.spacing12),
                  Expanded(
                    child: Text(
                      topic,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
