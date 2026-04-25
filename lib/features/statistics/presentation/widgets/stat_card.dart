import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.subtitleColor,
    this.backgroundColor,
  });

  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color? subtitleColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.h,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardSurfaceColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontFamily: AppTextStyles.manrope,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: AppColors.textSecondaryColor,
                ),
              ),
              Icon(icon, size: 18.r, color: AppColors.textSecondaryColor),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: AppTextStyles.spaceGrotesk,
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  color: AppColors.textPrimaryColor,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: AppTextStyles.manrope,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: subtitleColor ?? AppColors.textSecondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
