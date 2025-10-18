import 'package:flutter/material.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../models/entities/program_model.dart';

/// A horizontal card widget for displaying program information
/// Used primarily in program lists and search results
class HorizontalProgramCard extends StatelessWidget {
  final ProgramModel program;
  final VoidCallback? onTap;

  const HorizontalProgramCard({super.key, required this.program, this.onTap});

  /// Get color based on program level
  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return ThemeConstants.successColor;
      case 'intermediate':
        return ThemeConstants.warningColor;
      case 'advanced':
        return ThemeConstants.errorColor;
      default:
        return ThemeConstants.infoColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap ?? () => AppRoutes.toProgramDetail(context, program.id),
      borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: ThemeConstants.spacing8),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Program Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ThemeConstants.borderRadiusMedium),
                bottomLeft: Radius.circular(ThemeConstants.borderRadiusMedium),
              ),
              child: Container(
                width: 100,
                height: 100,
                color: theme.colorScheme.surfaceVariant,
                child: program.imageUrl != null
                    ? Image.network(
                        program.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : Center(
                        child: CircleAvatar(
                          backgroundColor: ThemeConstants.tertiaryColor
                              .withOpacity(0.3),
                          child: Text(
                            program.title.isNotEmpty
                                ? program.title[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              fontSize: 32,
                              fontFamily: ThemeConstants.primaryFontFamily,
                              color: ThemeConstants.tertiaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            // Program Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(ThemeConstants.spacing12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: ThemeConstants.spacing4),
                    Text(
                      program.instructorName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: ThemeConstants.spacing12),
                    // Program Metadata
                    Row(
                      children: [
                        // Duration
                        Icon(
                          Icons.schedule,
                          size: ThemeConstants.iconSizeSmall,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: ThemeConstants.spacing4),
                        Text(
                          program.duration,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: ThemeConstants.spacing12),
                        // Level
                        Icon(
                          Icons.stairs,
                          size: ThemeConstants.iconSizeSmall,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: ThemeConstants.spacing4),
                        Text(
                          program.level,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: _getLevelColor(program.level),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
