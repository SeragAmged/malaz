import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';

class SessionSlider extends StatelessWidget {
  const SessionSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.ticks,
    required this.onChanged,
    required this.color,
  });

  final int value;
  final int min;
  final int max;
  final List<int> ticks;
  final ValueChanged<int> onChanged;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: AppColors.inputBackgroundColor,
            thumbColor: AppColors.textPrimaryColor,
            overlayColor: color.withAlpha(30),
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 14.r),
            trackHeight: 8.h,
            trackShape: const RoundedRectSliderTrackShape(),
          ),

          child: Slider(
            value: value.toDouble(),
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: max,
            label: '$value min',
            activeColor: color,
            thumbColor: AppColors.onBackgroundColor,
            onChanged: (v) => onChanged(v.round()),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ticks
                .map(
                  (t) => Text(
                    '$t',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondaryColor.withAlpha(100),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
