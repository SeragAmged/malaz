import 'dart:ui';

import 'package:malaz/core/theme/app_colors.dart';

extension Helpers on Color {
  Color get getContrastColor {
    return computeLuminance() > 0.5
        ? AppColors.onInverseSurfaceColor
        : AppColors.textPrimaryColor;
  }
}

extension StringHelpers on String {
  Color get toColor {
    try {
      final hex = replaceAll('#', '').padLeft(6, '0');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return AppColors.primaryColor;
    }
  }
}
