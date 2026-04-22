import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/core/di/providers.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/core/widgets/app_loading_button.dart';
import 'package:malaz/core/widgets/blurred_circle_decoration.dart';
import 'package:malaz/features/rooms/presentation/cubit/timer_cubit.dart';
import 'package:malaz/features/rooms/presentation/cubit/timer_state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key, required this.roomId});

  final String roomId;

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen>
    with WidgetsBindingObserver {
  late TimerCubit _timerCubit;
  bool _isEditing = false;

  // Draft values used while slider is open
  late int _draftFocusMinutes = 25;
  late int _draftBreakMinutes = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timerCubit = getIt<TimerCubit>(param1: widget.roomId);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timerCubit.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _timerCubit.setOnline();
        break;
      case AppLifecycleState.paused:
        _timerCubit.setOffline();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
        // No action needed
        break;
    }
  }

  void _openEdit(TimerState timerState) {
    _draftFocusMinutes = timerState.focusDuration;
    _draftBreakMinutes = timerState.breakDuration;
    setState(() => _isEditing = true);
  }

  void _applyEdit() {
    _timerCubit.updateDurations(
      focusMinutes: _draftFocusMinutes,
      breakMinutes: _draftBreakMinutes,
    );
    setState(() => _isEditing = false);
  }

  void _cancelEdit() => setState(() => _isEditing = false);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TimerCubit>(
      create: (_) => _timerCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [Text('ZENGARDEN', style: AppTextStyles.appBarTitle20)],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<TimerCubit, TimerState>(
          builder: (context, timerState) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  // Error message if any
                  if (timerState.errorMessage != null)
                    Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: AppColors.errorColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        timerState.errorMessage!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.errorColor,
                        ),
                      ),
                    ),
                  _CardShell(
                    color: timerState.mode == SessionMode.focus
                        ? AppColors.primaryColor
                        : AppColors.warningColor,
                    isEditing: _isEditing,
                    timerContent: _TimerCard(
                      mode: timerState.mode,
                      timerDisplay: timerState.timerDisplay,
                      isRunning: timerState.isRunning,
                      isLoading: timerState.isLoading,
                      onStartStop: timerState.isRunning
                          ? () => context.read<TimerCubit>().pauseSession()
                          : timerState.isPaused
                              ? () =>
                                  context.read<TimerCubit>().resumeSession()
                              : () => context.read<TimerCubit>().startSession(),
                      onBreak: () =>
                          context.read<TimerCubit>().flipMode(),
                      onReset: () =>
                          context.read<TimerCubit>().resetSession(),
                      onEnd: () => context
                          .read<TimerCubit>()
                          .endSession(reason: 'interrupted'),
                      onSettings: () => _openEdit(timerState),
                    ),
                    editContent: _EditCardBody(
                      draftFocusMinutes: _draftFocusMinutes,
                      draftBreakMinutes: _draftBreakMinutes,
                      onFocusChanged: (v) =>
                          setState(() => _draftFocusMinutes = v),
                      onBreakChanged: (v) =>
                          setState(() => _draftBreakMinutes = v),
                      onApply: _applyEdit,
                      onCancel: _cancelEdit,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  const _ActiveResidentsCard(),
                  SizedBox(height: 24.h),
                  const _LeaderboardCard(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Card Shell (shared container that animates size) ─────────────────────────

class _CardShell extends StatelessWidget {
  const _CardShell({
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

// ─── Timer Card (normal mode) ─────────────────────────────────────────────────

class _TimerCard extends StatelessWidget {
  const _TimerCard({
    required this.mode,
    required this.timerDisplay,
    required this.isRunning,
    required this.isLoading,
    required this.onStartStop,
    required this.onBreak,
    required this.onReset,
    required this.onEnd,
    required this.onSettings,
  });

  final SessionMode mode;
  final String timerDisplay;
  final bool isRunning;
  final bool isLoading;
  final VoidCallback onStartStop;
  final VoidCallback onBreak;
  final VoidCallback onReset;
  final VoidCallback onEnd;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final isBreak = mode == SessionMode.breakTime;

    // Determine button label based on status
    String getButtonLabel() {
      if (isRunning) return 'Pause Session';
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
                color: isBreak
                    ? AppColors.warningColor
                    : AppColors.primaryColor,
              ),
            ),
          ),
          SizedBox(height: 32.h),
          _RollingTimerText(display: timerDisplay),
          SizedBox(height: 48.h),
          AppLoadingButton(
            isLoading: isLoading,
            onPressed: onStartStop,
            label: getButtonLabel(),
            backgroundColor: isBreak
                ? AppColors.warningColor
                : AppColors.primaryColor,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _OutlinedActionButton(
                  label: isBreak ? 'End Break' : 'Take Break',
                  onPressed: isLoading ? null : onBreak,
                ),
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: isRunning
                    ? AppLoadingButton(
                        label: "End",
                        height: null,
                        isLoading: isLoading,
                        onPressed: onEnd,
                        backgroundColor: AppColors.errorColor,
                        onBackgroundColor: AppColors.onErrorColor,
                      )
                    : _OutlinedActionButton(
                        label: 'Reset',
                        onPressed: isLoading ? null : onReset,
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

// ─── Edit Card (settings mode) ────────────────────────────────────────────────

class _EditCardBody extends StatefulWidget {
  const _EditCardBody({
    required this.draftFocusMinutes,
    required this.draftBreakMinutes,
    required this.onFocusChanged,
    required this.onBreakChanged,
    required this.onApply,
    required this.onCancel,
  });

  final int draftFocusMinutes;
  final int draftBreakMinutes;
  final ValueChanged<int> onFocusChanged;
  final ValueChanged<int> onBreakChanged;
  final VoidCallback onApply;
  final VoidCallback onCancel;

  @override
  State<_EditCardBody> createState() => _EditCardBodyState();
}

class _EditCardBodyState extends State<_EditCardBody> {
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
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 14.sp,
                        letterSpacing: 4.2,
                        color: AppColors.primaryColor,
                        fontFamily: AppTextStyles.spaceGrotesk,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _RollingTimerText(
                      display:
                          '${widget.draftFocusMinutes.toString().padLeft(2, '0')}:00',
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(height: 24.h),
                    _SessionSlider(
                      color: AppColors.primaryColor,
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
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 14.sp,
                        letterSpacing: 4.2,
                        color: AppColors.warningColor,
                        fontFamily: AppTextStyles.spaceGrotesk,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _RollingTimerText(
                      display:
                          '${widget.draftBreakMinutes.toString().padLeft(2, '0')}:00',
                      color: AppColors.warningColor,
                    ),
                    SizedBox(height: 24.h),
                    _SessionSlider(
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
                  : AppColors.primaryColor,
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
                child: _OutlinedActionButton(
                  label: 'Cancel',
                  onPressed: widget.onCancel,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 56.h,
                  child: FilledButton(
                    onPressed: widget.onApply,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.onPrimaryColor,
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      'Update',
                      style: TextStyle(
                        fontFamily: AppTextStyles.manrope,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.35,
                      ),
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

// ─── Rolling Timer Text ───────────────────────────────────────────────────────
// Each character rolls vertically (slot-machine style) when it changes.

class _RollingTimerText extends StatelessWidget {
  const _RollingTimerText({
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
                  : _RollingDigit(
                      digit: ch,
                      style: AppTextStyles.digitStyle.copyWith(color: color),
                    ),
            )
            .toList(),
      ),
    );
  }
}

class _RollingDigit extends StatefulWidget {
  const _RollingDigit({required this.digit, required this.style});

  final String digit;
  final TextStyle style;

  @override
  State<_RollingDigit> createState() => _RollingDigitState();
}

class _RollingDigitState extends State<_RollingDigit>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slideOut;
  late Animation<Offset> _slideIn;
  late Animation<double> _fadeOut;
  late Animation<double> _fadeIn;

  // The digit shown as the "from" side of the animation.
  String _from = '';
  bool _animating = false;

  @override
  void initState() {
    super.initState();
    _from = widget.digit;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _buildAnimations(1);
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        setState(() {
          _from = widget.digit; // always settle to whatever is current
          _animating = false;
        });
        _ctrl.reset();
      }
    });
  }

  void _buildAnimations(int dir) {
    _slideOut = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, -0.85 * dir),
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));

    _slideIn = Tween<Offset>(
      begin: Offset(0, 0.85 * dir),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    _fadeOut = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.35)));

    _fadeIn = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.35, 1)));
  }

  @override
  void didUpdateWidget(_RollingDigit old) {
    super.didUpdateWidget(old);
    // Only animate when the user lifts the slider (onChangeEnd),
    // not on every drag tick. The display already shows widget.digit live
    // via the non-animating branch; we trigger the roll only when the
    // digit actually differs from the settled _from value.
    if (widget.digit == _from || _animating) return;
    final fromV = int.tryParse(_from) ?? 0;
    final toV = int.tryParse(widget.digit) ?? 0;
    _buildAnimations(toV >= fromV ? 1 : -1);
    setState(() => _animating = true);
    _ctrl.forward(from: 0);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _charWidth(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, _) {
          if (!_animating) {
            return Text(widget.digit, style: widget.style);
          }
          return Stack(
            clipBehavior: Clip.none,
            children: [
              SlideTransition(
                position: _slideOut,
                child: FadeTransition(
                  opacity: _fadeOut,
                  child: Text(_from, style: widget.style),
                ),
              ),
              SlideTransition(
                position: _slideIn,
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: Text(widget.digit, style: widget.style),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Approximate monospaced width for a digit at this font size.
  double _charWidth() {
    final tp = TextPainter(
      text: TextSpan(text: '0', style: widget.style),
      textDirection: TextDirection.ltr,
    )..layout();
    return tp.width;
  }
}

// ─── Session Slider ───────────────────────────────────────────────────────────

class _SessionSlider extends StatelessWidget {
  const _SessionSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.ticks,
    required this.onChanged,
    this.onChangeEnd,
    required this.color,
  });

  final int value;
  final int min;
  final int max;
  final List<int> ticks;
  final ValueChanged<int> onChanged;
  final ValueChanged<int>? onChangeEnd;
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
            onChangeEnd: onChangeEnd != null
                ? (v) => onChangeEnd!(v.round())
                : null,
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
                    style: TextStyle(
                      fontFamily: AppTextStyles.manrope,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
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

// ─── Outlined Button ──────────────────────────────────────────────────────────

class _OutlinedActionButton extends StatelessWidget {
  const _OutlinedActionButton({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.borderColor),

        padding: EdgeInsets.symmetric(vertical: 13.h),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppTextStyles.manrope,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondaryColor,
        ),
      ),
    );
  }
}

// ─── Active Residents Card ────────────────────────────────────────────────────

class _ActiveResidentsCard extends StatelessWidget {
  const _ActiveResidentsCard();

  @override
  Widget build(BuildContext context) {
    final users = [
      _UserData(
        name: 'Alex Rivera',
        statusColor: const Color(0xFFDC9624),
        timer: '⏱️ 6:30:03',
        subLabel: '☕  -4:59',
      ),
      _UserData(
        name: 'Alex Rivera',
        statusColor: const Color(0xFF18BB4B),
        timer: '⏱️ 6:30:03',
      ),
      _UserData(
        name: 'Mia Chen',
        statusColor: const Color(0xFF2C96E5),
        subLabel: 'Idle',
        opacity: 0.8,
      ),
      _UserData(
        name: 'Jordan Smith',
        statusColor: AppColors.primaryColor,
        timer: 'Online',
      ),
      _UserData(
        name: 'Sam Taylor',
        statusColor: AppColors.textTertiaryColor,
        subLabel: 'Offline',
        opacity: 0.5,
      ),
    ];

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: AppColors.cardSurfaceColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACTIVE RESIDENTS',
            style: AppTextStyles.cardTagMedium.copyWith(
              fontSize: 12.sp,
              letterSpacing: 2.4,
              color: AppColors.textSecondaryColor,
              fontFamily: AppTextStyles.spaceGrotesk,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 24.h),
          ...users.map(
            (user) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _UserRow(data: user),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserData {
  const _UserData({
    required this.name,
    required this.statusColor,
    this.timer,
    this.subLabel,
    this.opacity = 1.0,
  });

  final String name;
  final Color statusColor;
  final String? timer;
  final String? subLabel;
  final double opacity;
}

class _UserRow extends StatelessWidget {
  const _UserRow({required this.data});

  final _UserData data;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: data.opacity,
      child: Row(
        children: [
          _AvatarWithStatus(statusColor: data.statusColor),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.name,
                style: AppTextStyles.titleSmall.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.textPrimaryColor,
                ),
              ),
              if (data.timer != null)
                Text(
                  ' ${data.timer}',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.primaryColor,
                    fontFamily: AppTextStyles.spaceGrotesk,
                    letterSpacing: 0,
                  ),
                ),
              if (data.subLabel != null)
                Text(
                  ' ${data.subLabel}',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.textSecondaryColor,
                    letterSpacing: 0,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarWithStatus extends StatelessWidget {
  const _AvatarWithStatus({required this.statusColor});

  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44.r,
      height: 44.r,
      child: Stack(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceColor,
            ),
            child: Icon(
              Icons.person,
              size: 20.r,
              color: AppColors.textTertiaryColor,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12.r,
              height: 12.r,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.cardSurfaceColor, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Leaderboard Card ────────────────────────────────────────────────────────

class _LeaderboardCard extends StatelessWidget {
  const _LeaderboardCard();

  @override
  Widget build(BuildContext context) {
    const leaders = [
      ('1. Alex R.', '6.5h'),
      ('2. Jordan S.', '5.2h'),
      ('3. Sarah L.', '4.8h'),
    ];

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DAILY LEADERS',
            style: AppTextStyles.cardTagMedium.copyWith(
              fontSize: 12.sp,
              letterSpacing: 2.4,
              color: AppColors.textSecondaryColor,
              fontFamily: AppTextStyles.spaceGrotesk,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 16.h),
          ...leaders.map(
            (entry) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.$1,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                  Text(
                    entry.$2,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF99CBFF),
                      fontFamily: AppTextStyles.manrope,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
