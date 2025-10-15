import 'package:flutter/material.dart';
import '../../../models/entities/program_model.dart';
import '../../../core/constants/theme_constants.dart';

/// Widget to display program curriculum
class ProgramCurriculum extends StatelessWidget {
  final List<CurriculumWeek> curriculum;

  const ProgramCurriculum({super.key, required this.curriculum});

  @override
  Widget build(BuildContext context) {
    if (curriculum.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(ThemeConstants.spacing16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: const Center(
          child: Text(
            'Curriculum details will be available soon',
            style: TextStyle(
              fontSize: ThemeConstants.bodyMediumFontSize,
              color: ThemeConstants.onSurfaceVariantColor,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spacing16),
            decoration: BoxDecoration(
              color: ThemeConstants.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(ThemeConstants.borderRadiusMedium),
                topRight: Radius.circular(ThemeConstants.borderRadiusMedium),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.list_alt,
                  color: ThemeConstants.primaryColor,
                  size: ThemeConstants.iconSizeMedium,
                ),
                const SizedBox(width: ThemeConstants.spacing8),
                Text(
                  'Course Curriculum',
                  style: TextStyle(
                    fontSize: ThemeConstants.bodyLargeFontSize,
                    fontWeight: FontWeight.bold,
                    color: ThemeConstants.primaryColor,
                  ),
                ),
                const Spacer(),
                Text(
                  '${curriculum.length} weeks',
                  style: TextStyle(
                    fontSize: ThemeConstants.bodySmallFontSize,
                    color: ThemeConstants.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Curriculum List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(ThemeConstants.spacing16),
            itemCount: curriculum.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: ThemeConstants.spacing12),
            itemBuilder: (context, index) {
              final week = curriculum[index];
              return _buildCurriculumWeek(context, week, index + 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCurriculumWeek(
    BuildContext context,
    CurriculumWeek week,
    int weekNumber,
  ) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spacing16),
      decoration: BoxDecoration(
        color: week.isCompleted
            ? Colors.green.withOpacity(0.1)
            : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusSmall),
        border: Border.all(
          color: week.isCompleted
              ? Colors.green.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Week Header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: week.isCompleted
                      ? Colors.green
                      : ThemeConstants.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: week.isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : Text(
                          weekNumber.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: ThemeConstants.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Week $weekNumber',
                      style: TextStyle(
                        fontSize: ThemeConstants.bodySmallFontSize,
                        color: ThemeConstants.onSurfaceVariantColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      week.title,
                      style: const TextStyle(
                        fontSize: ThemeConstants.bodyMediumFontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (week.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.spacing8,
                    vertical: ThemeConstants.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(
                      ThemeConstants.borderRadiusSmall,
                    ),
                  ),
                  child: const Text(
                    'Completed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          // Week Description
          if (week.description.isNotEmpty) ...[
            const SizedBox(height: ThemeConstants.spacing8),
            Text(
              week.description,
              style: const TextStyle(
                fontSize: ThemeConstants.bodySmallFontSize,
                color: ThemeConstants.onSurfaceVariantColor,
              ),
            ),
          ],

          // Topics
          if (week.topics.isNotEmpty) ...[
            const SizedBox(height: ThemeConstants.spacing12),
            Text(
              'Topics covered:',
              style: TextStyle(
                fontSize: ThemeConstants.bodySmallFontSize,
                fontWeight: FontWeight.w600,
                color: ThemeConstants.onSurfaceColor,
              ),
            ),
            const SizedBox(height: ThemeConstants.spacing8),
            Wrap(
              spacing: ThemeConstants.spacing8,
              runSpacing: ThemeConstants.spacing4,
              children: week.topics
                  .map((topic) => _buildTopicChip(topic))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTopicChip(String topic) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.spacing8,
        vertical: ThemeConstants.spacing4,
      ),
      decoration: BoxDecoration(
        color: ThemeConstants.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusSmall),
        border: Border.all(color: ThemeConstants.primaryColor.withOpacity(0.3)),
      ),
      child: Text(
        topic,
        style: TextStyle(
          fontSize: 12,
          color: ThemeConstants.primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
