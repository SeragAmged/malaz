import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';

class AppLoadingButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color onBackgroundColor;
  final TextStyle? textStyle;
  final double? width;
  final double? height;

  const AppLoadingButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = AppColors.primaryColor,
    this.onBackgroundColor = AppColors.onPrimaryColor,
    this.textStyle,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56.h,
      child: FilledButton(
        style: FilledButton.styleFrom(backgroundColor: backgroundColor),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  valueColor: AlwaysStoppedAnimation<Color>(onBackgroundColor),
                ),
              )
            : Text(
                label,
                style:
                    textStyle ??
                    AppTextStyles.titleSmall.copyWith(
                      color: onBackgroundColor,
                      letterSpacing: 1.4,
                    ),
              ),
      ),
    );
  }
}
