import 'package:flutter/material.dart';
import '../../../core/constants/theme_constants.dart';

/// Widget to display instructor information
class InstructorInfo extends StatelessWidget {
  final String instructorId;
  final String instructorName;
  final String? instructorAvatar;

  const InstructorInfo({
    super.key,
    required this.instructorId,
    required this.instructorName,
    this.instructorAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spacing16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.person,
                color: ThemeConstants.primaryColor,
                size: ThemeConstants.iconSizeMedium,
              ),
              const SizedBox(width: ThemeConstants.spacing8),
              Text(
                'Meet Your Instructor',
                style: TextStyle(
                  fontSize: ThemeConstants.bodyLargeFontSize,
                  fontWeight: FontWeight.bold,
                  color: ThemeConstants.primaryColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: ThemeConstants.spacing16),

          // Instructor Details
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 32,
                backgroundColor: ThemeConstants.primaryColor.withValues(alpha: 0.1),
                backgroundImage: instructorAvatar != null
                    ? NetworkImage(instructorAvatar!)
                    : null,
                child: instructorAvatar == null
                    ? Text(
                        _getInitials(instructorName),
                        style: TextStyle(
                          fontSize: ThemeConstants.bodyLargeFontSize,
                          fontWeight: FontWeight.bold,
                          color: ThemeConstants.primaryColor,
                        ),
                      )
                    : null,
              ),

              const SizedBox(width: ThemeConstants.spacing16),

              // Instructor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      instructorName,
                      style: const TextStyle(
                        fontSize: ThemeConstants.bodyLargeFontSize,
                        fontWeight: FontWeight.bold,
                        color: ThemeConstants.onSurfaceColor,
                      ),
                    ),
                    const SizedBox(height: ThemeConstants.spacing4),
                    Text(
                      'Course Instructor',
                      style: TextStyle(
                        fontSize: ThemeConstants.bodyMediumFontSize,
                        color: ThemeConstants.onSurfaceVariantColor,
                      ),
                    ),
                    const SizedBox(height: ThemeConstants.spacing8),

                    // Placeholder for instructor stats
                    Row(
                      children: [
                        _buildStatItem(Icons.school, '10+ Courses'),
                        const SizedBox(width: ThemeConstants.spacing16),
                        _buildStatItem(Icons.people, '5K+ Students'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: ThemeConstants.spacing16),

          // View Profile Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // TODO: Navigate to instructor profile
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Instructor profile coming soon!'),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: ThemeConstants.primaryColor,
                side: BorderSide(color: ThemeConstants.primaryColor),
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
                'View Instructor Profile',
                style: TextStyle(
                  fontSize: ThemeConstants.bodyMediumFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: ThemeConstants.iconSizeSmall,
          color: ThemeConstants.onSurfaceVariantColor,
        ),
        const SizedBox(width: ThemeConstants.spacing4),
        Text(
          text,
          style: TextStyle(
            fontSize: ThemeConstants.bodySmallFontSize,
            color: ThemeConstants.onSurfaceVariantColor,
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return 'I';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }
}
