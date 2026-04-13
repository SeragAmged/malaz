import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Material 3 theme configuration for Malaz app
class AppTheme {
  static ThemeData get darkTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryColor,
      onPrimary: AppColors.onPrimaryColor,
      primaryContainer: AppColors.primaryContainerColor,
      onPrimaryContainer: AppColors.onPrimaryContainerColor,
      secondary: AppColors.secondaryColor,
      onSecondary: AppColors.onSecondaryColor,
      secondaryContainer: AppColors.secondaryContainerColor,
      onSecondaryContainer: AppColors.onSecondaryContainerColor,
      tertiary: AppColors.tertiaryColor,
      onTertiary: AppColors.onTertiaryColor,
      tertiaryContainer: AppColors.tertiaryContainerColor,
      onTertiaryContainer: AppColors.onTertiaryContainerColor,
      error: AppColors.errorColor,
      onError: AppColors.onErrorColor,
      errorContainer: AppColors.errorContainerColor,
      onErrorContainer: AppColors.onErrorContainerColor,
      surface: AppColors.surfaceColor,
      onSurface: AppColors.onBackgroundColor,
      surfaceContainerHighest: AppColors.surfaceContainerColor,
      onSurfaceVariant: AppColors.textSecondaryColor,
      outline: AppColors.borderColor,
      outlineVariant: AppColors.outlineVariantColor,
      shadow: AppColors.blackColor,
      scrim: AppColors.blackColor,
      inverseSurface: AppColors.inverseSurfaceColor,
      onInverseSurface: AppColors.onInverseSurfaceColor,
      inversePrimary: AppColors.inversePrimaryColor,
      surfaceTint: AppColors.primaryColor,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceContainerHighColor,
        foregroundColor: AppColors.textPrimaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerHighColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.onPrimaryColor,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          textStyle: AppTextStyles.titleMedium,
          minimumSize: Size(double.infinity, 48.h),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          textStyle: AppTextStyles.titleSmall,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimaryColor,
          side: const BorderSide(color: AppColors.borderColor),
          textStyle: AppTextStyles.titleSmall,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackgroundColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.errorColor, width: 2),
        ),
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textSecondaryColor,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.inputHintColor,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
    );
  }
}
