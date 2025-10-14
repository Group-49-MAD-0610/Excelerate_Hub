import 'package:flutter/material.dart';
import '../../../core/constants/theme_constants.dart';

/// Custom text field widget with consistent styling
class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      onTap: onTap,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      style: const TextStyle(
        fontFamily: ThemeConstants.primaryFontFamily,
        fontSize: ThemeConstants.bodyMediumFontSize,
        color: ThemeConstants.onSurfaceColor,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                size: ThemeConstants.iconSizeMedium,
                color: ThemeConstants.onSurfaceVariantColor,
              )
            : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: ThemeConstants.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
          borderSide: const BorderSide(
            color: ThemeConstants.outlineColor,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
          borderSide: const BorderSide(
            color: ThemeConstants.outlineColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
          borderSide: const BorderSide(
            color: ThemeConstants.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
          borderSide: const BorderSide(
            color: ThemeConstants.errorColor,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
          borderSide: const BorderSide(
            color: ThemeConstants.errorColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacing16,
          vertical: ThemeConstants.spacing16,
        ),
        labelStyle: const TextStyle(
          fontFamily: ThemeConstants.primaryFontFamily,
          fontSize: ThemeConstants.bodyMediumFontSize,
          color: ThemeConstants.onSurfaceVariantColor,
        ),
        hintStyle: const TextStyle(
          fontFamily: ThemeConstants.primaryFontFamily,
          fontSize: ThemeConstants.bodyMediumFontSize,
          color: ThemeConstants.onSurfaceVariantColor,
        ),
        errorStyle: const TextStyle(
          fontFamily: ThemeConstants.primaryFontFamily,
          fontSize: ThemeConstants.bodySmallFontSize,
          color: ThemeConstants.errorColor,
        ),
      ),
    );
  }
}
