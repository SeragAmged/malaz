import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/core/theme/extensions.dart';
import 'package:malaz/core/widgets/app_loading_button.dart';
import 'package:malaz/features/rooms/domain/entities/enums.dart';
import 'package:malaz/features/rooms/presentation/cubit/timer/timer_state.dart';
import 'package:malaz/features/rooms/presentation/widgets/room/rolling_timer_text.dart';
import 'package:malaz/features/rooms/presentation/pages/room_page.dart';
import 'package:malaz/features/rooms/presentation/widgets/room/outlined_action_button.dart';

class TimerCard extends StatelessWidget {
  const TimerCard({
    super.key,
    required this.mode,
    required this.timerDisplay,
    required this.isRunning,
    required this.isLoading,
    required this.onStartStop,
    required this.onBreak,
    required this.onReset,
    required this.onEnd,
    required this.onSettings,
    required this.timerStatus,
    this.color = AppColors.primaryColor,
  });

  final SessionType mode;
  final TimerStatus timerStatus;
  final String timerDisplay;
  final bool isRunning;
  final bool isLoading;
  final VoidCallback onStartStop;
  final VoidCallback onBreak;
  final VoidCallback onReset;
  final VoidCallback onEnd;
  final VoidCallback onSettings;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isBreak = mode == SessionType.breakTime;
    final isPaused = timerStatus == TimerStatus.paused;
    final isIdle = timerStatus == TimerStatus.idle;

    // Determine button label based on status
    String getButtonLabel() {
      if (isRunning) return 'Pause Session';
      if (isPaused) return 'Resume Session';
      return 'Start Session';
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 40.h),
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              isBreak ? 'BREAK TIME' : 'DEEP WORK',
              key: ValueKey(mode),
              style: AppTextStyles.appBarTitle14.copyWith(
                fontWeight: FontWeight.w400,
                color: isBreak ? AppColors.warningColor : color,
              ),
            ),
          ),
          SizedBox(height: 32.h),
          RollingTimerText(display: timerDisplay),
          SizedBox(height: 48.h),
          AppLoadingButton(
            isLoading: isLoading,
            onPressed: onStartStop,
            label: getButtonLabel(),
            backgroundColor: isBreak
                ? AppColors.warningColor
                : isIdle
                ? color
                : AppColors.primaryColor,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedActionButton(
                  label: isBreak ? 'End Break' : 'Take Break',
                  onPressed: isLoading ? null : onBreak,
                ),
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: isRunning
                    ? OutlinedActionButton(
                        label: "End",
                        onPressed: onEnd,
                        backgroundColor: AppColors.errorColor,
                        onBackgroundColor: AppColors.onErrorColor,
                      )
                    : OutlinedActionButton(
                        label: 'Reset',
                        onPressed: isLoading ? null : onReset,
                        // backgroundColor: color,
                        // onBackgroundColor: color.getContrastColor,
                      ),
              ),
              SizedBox(width: 7.w),
              Material(
                borderRadius: BorderRadius.circular(999.r),
                child: InkWell(
                  onTap: isLoading ? null : onSettings,
                  borderRadius: BorderRadius.circular(999.r),
                  child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: Icon(
                      Icons.settings_outlined,
                      size: 20.r,
                      color: AppColors.textSecondaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
