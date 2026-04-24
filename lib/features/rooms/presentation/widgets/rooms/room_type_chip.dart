import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';

class RoomTypeChip extends StatelessWidget {
  const RoomTypeChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withValues(alpha: 0.15)
              : AppColors.inputBackgroundColor,
          borderRadius: BorderRadius.circular(999),
          border: isSelected
              ? Border.all(color: AppColors.primaryColor, width: 1.5)
              : Border.all(color: AppColors.borderColor, width: 1),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.textSecondaryColor,
          ),
        ),
      ),
    );
  }
}
