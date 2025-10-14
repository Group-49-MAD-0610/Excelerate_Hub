import 'package:flutter/material.dart';
import '../../../core/constants/theme_constants.dart';

/// Loading indicator widget with consistent styling
class LoadingIndicator extends StatelessWidget {
  final double? size;
  final Color? color;
  final String? message;

  const LoadingIndicator({super.key, this.size, this.color, this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size ?? 24,
          height: size ?? 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? ThemeConstants.primaryColor,
            ),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: ThemeConstants.spacing12),
          Text(
            message!,
            style: const TextStyle(
              fontFamily: ThemeConstants.primaryFontFamily,
              fontSize: ThemeConstants.bodySmallFontSize,
              color: ThemeConstants.onSurfaceVariantColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
