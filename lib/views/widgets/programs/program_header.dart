import 'package:flutter/material.dart';
import '../../../models/entities/program_model.dart';
import '../../../core/constants/theme_constants.dart';

/// Widget to display program header information
class ProgramHeader extends StatelessWidget {
  final ProgramModel program;
  final VoidCallback? onEnrollPressed;
  final VoidCallback? onUnenrollPressed;
  final bool isLoading;

  const ProgramHeader({
    super.key,
    required this.program,
    this.onEnrollPressed,
    this.onUnenrollPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spacing16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Program Image
          if (program.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(
                ThemeConstants.borderRadiusMedium,
              ),
              child: Image.network(
                program.imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 64,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(
                  ThemeConstants.borderRadiusMedium,
                ),
              ),
              child: const Icon(Icons.school, size: 64, color: Colors.grey),
            ),

          const SizedBox(height: ThemeConstants.spacing16),

          // Program Title
          Text(
            program.title,
            style: const TextStyle(
              fontSize: ThemeConstants.headlineMediumFontSize,
              fontWeight: FontWeight.bold,
              fontFamily: ThemeConstants.primaryFontFamily,
            ),
          ),

          const SizedBox(height: ThemeConstants.spacing8),

          // Program Category and Level
          Row(
            children: [
              _buildChip(
                context,
                program.category,
                Icons.category,
                ThemeConstants.primaryColor,
              ),
              const SizedBox(width: ThemeConstants.spacing8),
              _buildChip(
                context,
                program.level,
                Icons.signal_cellular_alt,
                _getLevelColor(program.level),
              ),
            ],
          ),

          const SizedBox(height: ThemeConstants.spacing12),

          // Rating and Enrollment Info
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
                size: ThemeConstants.iconSizeSmall,
              ),
              const SizedBox(width: ThemeConstants.spacing4),
              Text(
                '${program.rating.toStringAsFixed(1)} (${program.reviewCount} reviews)',
                style: const TextStyle(
                  fontSize: ThemeConstants.bodySmallFontSize,
                  color: ThemeConstants.onSurfaceVariantColor,
                ),
              ),
              const Spacer(),
              Text(
                '${program.enrollmentCount} enrolled',
                style: const TextStyle(
                  fontSize: ThemeConstants.bodySmallFontSize,
                  color: ThemeConstants.onSurfaceVariantColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: ThemeConstants.spacing16),

          // Price and Duration
          Row(
            children: [
              Text(
                program.formattedPrice,
                style: TextStyle(
                  fontSize: ThemeConstants.headlineSmallFontSize,
                  fontWeight: FontWeight.bold,
                  color: program.isFree
                      ? Colors.green
                      : ThemeConstants.primaryColor,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: ThemeConstants.iconSizeSmall,
                    color: ThemeConstants.onSurfaceVariantColor,
                  ),
                  const SizedBox(width: ThemeConstants.spacing4),
                  Text(
                    program.duration,
                    style: const TextStyle(
                      fontSize: ThemeConstants.bodyMediumFontSize,
                      color: ThemeConstants.onSurfaceVariantColor,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: ThemeConstants.spacing16),

          // Progress bar (if enrolled)
          if (program.isEnrolled && program.progress != null) ...[
            Row(
              children: [
                Text(
                  'Progress: ${program.progressPercentage}',
                  style: const TextStyle(
                    fontSize: ThemeConstants.bodySmallFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: ThemeConstants.spacing8),
            LinearProgressIndicator(
              value: (program.progress ?? 0) / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                program.isCompleted
                    ? Colors.green
                    : ThemeConstants.primaryColor,
              ),
            ),
            const SizedBox(height: ThemeConstants.spacing16),
          ],

          // Enrollment Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : (program.isEnrolled ? onUnenrollPressed : onEnrollPressed),
              style: ElevatedButton.styleFrom(
                backgroundColor: program.isEnrolled
                    ? Colors.grey[600]
                    : ThemeConstants.primaryColor,
                padding: const EdgeInsets.symmetric(
                  vertical: ThemeConstants.spacing16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ThemeConstants.borderRadiusMedium,
                  ),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      program.isEnrolled ? 'Unenroll' : 'Enroll Now',
                      style: const TextStyle(
                        fontSize: ThemeConstants.bodyLargeFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.spacing12,
        vertical: ThemeConstants.spacing4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusSmall),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: ThemeConstants.iconSizeSmall, color: color),
          const SizedBox(width: ThemeConstants.spacing4),
          Text(
            label,
            style: TextStyle(
              fontSize: ThemeConstants.bodySmallFontSize,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return ThemeConstants.primaryColor;
    }
  }
}
