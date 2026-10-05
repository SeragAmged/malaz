import 'package:flutter/material.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/features/rooms/presentation/widgets/room/rolling_digit.dart';

class RollingTimerText extends StatelessWidget {
  const RollingTimerText({
    super.key,
    required this.display,
    this.color = AppColors.textPrimaryColor,
  });

  final String display;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: display.characters
            .map(
              (ch) => ch == ':'
                  ? Text(
                      ':',
                      style: AppTextStyles.digitStyle.copyWith(color: color),
                    )
                  : RollingDigit(
                      digit: ch,
                      style: AppTextStyles.digitStyle.copyWith(color: color),
                    ),
            )
            .toList(),
      ),
    );
  }
}
