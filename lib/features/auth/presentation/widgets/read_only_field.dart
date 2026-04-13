import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';

/// Display read-only information with icon and formatting
class ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? borderRadius;

  const ReadOnlyField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.borderColor,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? AppColors.borderColor,
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
        color: backgroundColor,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.textTertiaryColor,
            size: 18.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelMedium,
                ),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
