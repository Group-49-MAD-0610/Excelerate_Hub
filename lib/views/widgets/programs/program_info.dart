import 'package:flutter/material.dart';
import '../../../core/constants/theme_constants.dart';

/// Widget to display program information like requirements and outcomes
class ProgramInfo extends StatelessWidget {
  final String description;
  final List<String> requirements;
  final List<String> outcomes;
  final List<String> tags;

  const ProgramInfo({
    super.key,
    required this.description,
    required this.requirements,
    required this.outcomes,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description Section
        _buildSection(
          context: context,
          title: 'About This Program',
          icon: Icons.info_outline,
          content: Text(
            description,
            style: const TextStyle(
              fontSize: ThemeConstants.bodyMediumFontSize,
              height: 1.5,
              color: ThemeConstants.onSurfaceColor,
            ),
          ),
        ),
        
        const SizedBox(height: ThemeConstants.spacing24),
        
        // Requirements Section
        if (requirements.isNotEmpty) ...[
          _buildSection(
            context: context,
            title: 'Prerequisites',
            icon: Icons.checklist,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: requirements.map((requirement) => 
                _buildListItem(requirement)
              ).toList(),
            ),
          ),
          const SizedBox(height: ThemeConstants.spacing24),
        ],
        
        // Outcomes Section
        if (outcomes.isNotEmpty) ...[
          _buildSection(
            context: context,
            title: 'Learning Outcomes',
            icon: Icons.emoji_events,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: outcomes.map((outcome) => 
                _buildListItem(outcome, icon: Icons.check_circle_outline)
              ).toList(),
            ),
          ),
          const SizedBox(height: ThemeConstants.spacing24),
        ],
        
        // Tags Section
        if (tags.isNotEmpty) ...[
          _buildSection(
            context: context,
            title: 'Skills You\'ll Learn',
            icon: Icons.label,
            content: Wrap(
              spacing: ThemeConstants.spacing8,
              runSpacing: ThemeConstants.spacing8,
              children: tags.map((tag) => _buildTagChip(tag)).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
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
                  icon,
                  color: ThemeConstants.primaryColor,
                  size: ThemeConstants.iconSizeMedium,
                ),
                const SizedBox(width: ThemeConstants.spacing8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ThemeConstants.bodyLargeFontSize,
                    fontWeight: FontWeight.bold,
                    color: ThemeConstants.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Section Content
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.spacing16),
            child: content,
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String text, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ThemeConstants.spacing8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon ?? Icons.arrow_right,
            size: ThemeConstants.iconSizeSmall,
            color: ThemeConstants.primaryColor,
          ),
          const SizedBox(width: ThemeConstants.spacing8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: ThemeConstants.bodyMediumFontSize,
                height: 1.4,
                color: ThemeConstants.onSurfaceColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.spacing12,
        vertical: ThemeConstants.spacing8,
      ),
      decoration: BoxDecoration(
        color: ThemeConstants.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusSmall),
        border: Border.all(
          color: ThemeConstants.secondaryColor.withOpacity(0.3),
        ),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: ThemeConstants.bodySmallFontSize,
          fontWeight: FontWeight.w600,
          color: ThemeConstants.secondaryColor,
        ),
      ),
    );
  }
}
