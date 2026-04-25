import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/core/theme/extensions.dart';
import 'package:malaz/core/widgets/app_loading_button.dart';
import 'package:malaz/features/rooms/presentation/widgets/room/rolling_timer_text.dart';
import 'package:malaz/features/rooms/presentation/pages/room_page.dart';
import 'package:malaz/features/rooms/presentation/widgets/room/session_slider.dart';
import 'package:malaz/features/rooms/presentation/widgets/room/outlined_action_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class EditCardBody extends StatefulWidget {
  const EditCardBody({
    super.key,
    required this.draftFocusMinutes,
    required this.draftBreakMinutes,
    required this.onFocusChanged,
    required this.onBreakChanged,
    required this.onApply,
    required this.onCancel,
    this.color = AppColors.primaryColor,
  });

  final int draftFocusMinutes;
  final int draftBreakMinutes;
  final ValueChanged<int> onFocusChanged;
  final ValueChanged<int> onBreakChanged;
  final VoidCallback onApply;
  final VoidCallback onCancel;
  final Color color;

  @override
  State<EditCardBody> createState() => _EditCardBodyState();
}

class _EditCardBodyState extends State<EditCardBody> {
  final _controller = PageController();

  bool get _isBreakPage =>
      _controller.hasClients ? _controller.page?.round() == 1 : false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    setState(() {
      // Just trigger rebuild to update the active dot color; the page view
      // handles the actual page changes.
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 235.h,
            child: PageView(
              controller: _controller,
              children: [
                Column(
                  children: [
                    Text(
                      'FOCUS SESSION',
                      style: AppTextStyles.timerLabel.copyWith(
                        color: widget.color,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    RollingTimerText(
                      display:
                          '${widget.draftFocusMinutes.toString().padLeft(2, '0')}:00',
                      color: widget.color,
                    ),
                    SizedBox(height: 24.h),
                    SessionSlider(
                      color: widget.color,
                      value: widget.draftFocusMinutes,
                      min: 5,
                      max: 120,
                      ticks: const [5, 25, 50, 70, 90, 120],
                      onChanged: widget.onFocusChanged,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'BREAK SESSION',
                      style: AppTextStyles.timerLabel.copyWith(
                        color: AppColors.warningColor,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    RollingTimerText(
                      display:
                          '${widget.draftBreakMinutes.toString().padLeft(2, '0')}:00',
                      color: AppColors.warningColor,
                    ),
                    SizedBox(height: 24.h),
                    SessionSlider(
                      color: AppColors.warningColor,
                      value: widget.draftBreakMinutes,
                      min: 1,
                      max: 30,
                      ticks: const [1, 5, 10, 15, 30],
                      onChanged: widget.onBreakChanged,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SmoothPageIndicator(
            controller: _controller, // PageController
            count: 2,
            effect: WormEffect(
              activeDotColor: _isBreakPage
                  ? AppColors.warningColor
                  : widget.color,
            ), // your preferred effect

            onDotClicked: (index) {
              _controller.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
          ),
          SizedBox(height: 32.h),
          Row(
            children: [
              Expanded(
                child: OutlinedActionButton(
                  label: 'Cancel',
                  onPressed: widget.onCancel,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: AppLoadingButton(
                  onPressed: widget.onApply,
                  backgroundColor: widget.color,
                  onBackgroundColor: widget.color.getContrastColor,
                  label: 'Update',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
