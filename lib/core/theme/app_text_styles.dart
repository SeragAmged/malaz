import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

abstract class AppTextStyles {
  static const manrope = 'Manrope';
  static const spaceGrotesk = 'Space Grotesk';

  static double _fontSize(
    double base, {
    double minScale = 0.9,
    double maxScale = 1.15,
  }) {
    return base.sp.clamp(base * minScale, base * maxScale).toDouble();
  }

  static TextStyle _style({
    required double fontSize,
    required FontWeight fontWeight,
    required double height,
    required double letterSpacing,
    required Color color,
    required String fontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: _fontSize(fontSize),
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  static TextStyle get displayLarge => _style(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    height: 1.12,
    letterSpacing: -0.25,
    color: AppColors.textPrimaryColor,
    fontFamily: spaceGrotesk,
  );

  static TextStyle get displayMedium => _style(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 1.16,
    letterSpacing: 0,
    color: AppColors.textPrimaryColor,
    fontFamily: spaceGrotesk,
  );

  static TextStyle get displaySmall => _style(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.22,
    letterSpacing: 0,
    color: AppColors.textPrimaryColor,
    fontFamily: spaceGrotesk,
  );

  static TextStyle get headlineLarge => _style(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.8,
    color: AppColors.textPrimaryColor,
    fontFamily: spaceGrotesk,
  );

  static TextStyle get headlineMedium => _style(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.29,
    letterSpacing: 0,
    color: AppColors.textPrimaryColor,
    fontFamily: spaceGrotesk,
  );

  static TextStyle get headlineSmall => _style(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0,
    color: AppColors.textPrimaryColor,
    fontFamily: spaceGrotesk,
  );

  static TextStyle get titleLarge => _style(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 1.27,
    letterSpacing: 0,
    color: AppColors.textPrimaryColor,
    fontFamily: manrope,
  );

  static TextStyle get titleMedium => _style(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.15,
    color: AppColors.textPrimaryColor,
    fontFamily: spaceGrotesk,
  );

  static TextStyle get titleSmall => _style(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
    color: AppColors.textPrimaryColor,
    fontFamily: manrope,
  );

  static TextStyle get bodyLarge => _style(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.15,
    color: AppColors.textPrimaryColor,
    fontFamily: manrope,
  );

  static TextStyle get bodyMedium => _style(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
    color: AppColors.textPrimaryColor,
    fontFamily: manrope,
  );

  static TextStyle get bodySmall => _style(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
    color: AppColors.textSecondaryColor,
    fontFamily: manrope,
  );

  static TextStyle get labelLarge => _style(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
    color: AppColors.textPrimaryColor,
    fontFamily: manrope,
  );

  static TextStyle get labelMedium => _style(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0.5,
    color: AppColors.textPrimaryColor,
    fontFamily: manrope,
  );

  static TextStyle get labelSmall => _style(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.5,
    color: AppColors.textSecondaryColor,
    fontFamily: manrope,
  );
}
