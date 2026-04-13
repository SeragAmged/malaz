import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';

/// Consistent app branding section with logo and headline
class AuthBranding extends StatelessWidget {
  final String appName;
  final String headlineFirst;
  final String headlineSecond;
  final TextStyle? appNameStyle;
  final TextStyle? headlineStyle;
  final double spacing;

  const AuthBranding({
    super.key,
    this.appName = 'MALAZ',
    required this.headlineFirst,
    required this.headlineSecond,
    this.appNameStyle,
    this.headlineStyle,
    this.spacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 24.h),
        Text(
          appName,
          style: appNameStyle ??
              AppTextStyles.titleLarge.copyWith(
                color: AppColors.primaryColor,
                letterSpacing: 4.2,
              ),
        ),
        SizedBox(height: spacing.h),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: headlineFirst,
                style: (headlineStyle ?? AppTextStyles.headlineLarge).copyWith(
                  height: 1.25,
                  letterSpacing: -0.80,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: headlineSecond,
                style: headlineStyle ?? AppTextStyles.headlineLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
