import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';

class OutlinedActionButton extends StatelessWidget {
  const OutlinedActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.onBackgroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? onBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: backgroundColor == null
            ? const BorderSide(color: AppColors.borderColor)
            : null,
        backgroundColor: backgroundColor ?? Colors.transparent,

        padding: EdgeInsets.symmetric(vertical: 13.h),
      ),
      child: Text(
        label,
        style: AppTextStyles.titleMedium.copyWith(
          fontFamily: AppTextStyles.manrope,
          color: onBackgroundColor ?? AppColors.textSecondaryColor,
        ),
      ),
    );
  }
}
