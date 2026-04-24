import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/widgets/blurred_circle_decoration.dart';

class RoomTimerCardShell extends StatelessWidget {
  const RoomTimerCardShell({super.key, 
    required this.isEditing,
    required this.timerContent,
    required this.editContent,
    required this.color,
  });

  final bool isEditing;
  final Widget timerContent;
  final Widget editContent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurfaceColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          BlurredCircleDecoration(
            color: color,
            width: 234.r,
            height: 234.r,
            top: -150.h,
            left: 0,
            right: 0,
            colorAlpha: 0.1,
          ),
          BlurredCircleDecoration(
            color: color,
            width: 234.r,
            height: 234.r,
            bottom: -150.h,
            left: 0,
            right: 0,
            colorAlpha: 0.1,
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            alignment: Alignment.center,
            child: isEditing
                ? SizedBox(
                    key: const ValueKey('edit'),
                    width: double.infinity,
                    child: editContent,
                  )
                : SizedBox(
                    key: const ValueKey('timer'),
                    width: double.infinity,
                    child: timerContent,
                  ),
          ),
        ],
      ),
    );
  }
}
