import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';

/// Success confirmation screen after signup/password reset
class ConfirmationView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback onButtonPressed;
  final double iconSize;
  final bool showButton;

  const ConfirmationView({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onButtonPressed,
    this.iconSize = 64.0,
    this.showButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize.r,
              color: AppColors.backgroundColor,
            ),
            SizedBox(height: 24.h),
            Text(
              title,
              style: AppTextStyles.displayLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              description,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (showButton) ...[
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: FilledButton(
                  onPressed: onButtonPressed,
                  child: Text(buttonLabel),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
