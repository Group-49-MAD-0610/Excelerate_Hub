import 'package:flutter/material.dart';
import '../../../core/constants/theme_constants.dart';

/// Custom button widget with consistent styling
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final ButtonType type;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.type = ButtonType.primary,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget button;

    switch (type) {
      case ButtonType.primary:
        button = _buildElevatedButton(context);
        break;
      case ButtonType.secondary:
        button = _buildOutlinedButton(context);
        break;
      case ButtonType.text:
        button = _buildTextButton(context);
        break;
    }

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        height: ThemeConstants.buttonHeightLarge,
        child: button,
      );
    }

    return button;
  }

  Widget _buildElevatedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? ThemeConstants.primaryColor,
        foregroundColor: foregroundColor ?? Colors.white,
        elevation: ThemeConstants.elevationNone,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacing24,
          vertical: ThemeConstants.spacing16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildOutlinedButton(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor ?? ThemeConstants.primaryColor,
        backgroundColor: backgroundColor ?? Colors.transparent,
        side: BorderSide(
          color: foregroundColor ?? ThemeConstants.primaryColor,
          width: 1.5,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacing24,
          vertical: ThemeConstants.spacing16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor ?? ThemeConstants.secondaryColor,
        backgroundColor: backgroundColor ?? Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacing20,
          vertical: ThemeConstants.spacing12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: ThemeConstants.iconSizeMedium),
          const SizedBox(width: ThemeConstants.spacing8),
          Text(
            text,
            style: const TextStyle(
              fontFamily: ThemeConstants.primaryFontFamily,
              fontSize: ThemeConstants.bodyMediumFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: const TextStyle(
        fontFamily: ThemeConstants.primaryFontFamily,
        fontSize: ThemeConstants.bodyMediumFontSize,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// Button types
enum ButtonType { primary, secondary, text }
