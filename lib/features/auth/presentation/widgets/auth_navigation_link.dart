import 'package:flutter/material.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';

/// Consistent navigation link for auth screen transitions
class AuthNavigationLink extends StatelessWidget {
  final String labelText;
  final String linkText;
  final VoidCallback onLinkPressed;
  final TextStyle? labelStyle;
  final TextStyle? linkStyle;

  const AuthNavigationLink({
    super.key,
    required this.labelText,
    required this.linkText,
    required this.onLinkPressed,
    this.labelStyle,
    this.linkStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          labelText,
          style: labelStyle ??
              AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryColor,
              ),
        ),
        TextButton(
          onPressed: onLinkPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: Text(
            linkText,
            style: linkStyle ??
                AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }
}
