import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';

/// A filled button that displays a loading indicator while an action is in progress
class AuthLoadingButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final TextStyle? textStyle;
  final double? width;
  final double? height;

  const AuthLoadingButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
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
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.onPrimaryColor,
                  ),
                ),
              )
            : Text(
                label,
                style: textStyle ??
                    AppTextStyles.titleSmall.copyWith(
                      color: AppColors.onPrimaryColor,
                      letterSpacing: 1.4,
                    ),
              ),
      ),
    );
  }
}
