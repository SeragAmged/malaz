import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/core/di/providers.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/core/widgets/app_loading_button.dart';
import 'package:malaz/features/rooms/domain/entities/enums.dart';
import 'package:malaz/features/rooms/domain/entities/leaderboard_entry.dart';
import 'package:malaz/features/rooms/domain/entities/room_member_with_session.dart';
import 'package:malaz/features/rooms/presentation/cubit/timer/timer_cubit.dart';
import 'package:malaz/features/rooms/presentation/cubit/timer/timer_state.dart';
import 'package:malaz/features/rooms/presentation/cubit/room_members/room_members_cubit.dart';
import 'package:malaz/features/rooms/presentation/cubit/room_members/room_members_state.dart';
import 'package:malaz/features/rooms/data/models/room_member_with_session_model.dart';
import 'package:malaz/features/rooms/presentation/widgets/room/outlined_action_button.dart';
import 'package:malaz/features/rooms/presentation/widgets/room/room_timer_card_shell.dart';
import 'package:malaz/features/rooms/presentation/widgets/rooms/rooms_card_avatar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key, required this.roomId});

  final String roomId;

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> with WidgetsBindingObserver {
  late TimerCubit _timerCubit;
  late RoomMembersCubit _roomMembersCubit;
  bool _isEditing = false;

  // Draft values used while slider is open
  late int _draftFocusMinutes = 25;
  late int _draftBreakMinutes = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timerCubit = getIt<TimerCubit>(param1: widget.roomId);
    // Attempt to recover any active session from the server
    _timerCubit.tryRecoverSession();
    _roomMembersCubit = getIt<RoomMembersCubit>(param1: widget.roomId);
    _roomMembersCubit.init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _roomMembersCubit.close();
    _timerCubit.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _timerCubit.setOnline();
        _roomMembersCubit.onResume();
        break;
      case AppLifecycleState.paused:
        _timerCubit.setOffline();
        _roomMembersCubit.onPause();
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
                  RoomTimerCardShell(
                    color: timerState.isFocusMode
                        ? AppColors.primaryColor
                        : AppColors.warningColor,
                    isEditing: _isEditing,
                    timerContent: _TimerCard(
                      mode: timerState.mode,
                      timerDisplay: timerState.timerDisplay,
                      isRunning: timerState.isRunning,
                      isLoading: timerState.isLoading,
                      timerStatus: timerState.status,
                      onStartStop: timerState.isRunning
                          ? () => context.read<TimerCubit>().pauseSession()
                          : timerState.isPaused
                          ? () => context.read<TimerCubit>().resumeSession()
                          : () => context.read<TimerCubit>().startSession(),
                      onBreak: () => context.read<TimerCubit>().flipMode(),
                      onReset: () => context.read<TimerCubit>().resetSession(),
                      onEnd: () => context.read<TimerCubit>().endSession(
                        reason: 'interrupted',
                      ),
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
                  BlocProvider.value(
                    value: _roomMembersCubit,
                    child: const _ActiveResidentsCard(),
                  ),
                  SizedBox(height: 24.h),
                  BlocBuilder<RoomMembersCubit, RoomMembersState>(
                    builder: (context, state) => _LeaderboardCard(topLeaders: state.topLeaders),
                  ),
                ],
              ),
            );
          },
        ),
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
    required this.timerStatus,
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
                : isIdle
                ? AppColors.primaryColor
                : AppColors.secondaryColor,
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
                child: OutlinedActionButton(
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

// ─── Active Residents Card ────────────────────────────────────────────────────

class _ActiveResidentsCard extends StatelessWidget {
  const _ActiveResidentsCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomMembersCubit, RoomMembersState>(
      builder: (context, state) {
        if (state.isLoading && state.members.isEmpty) {
          return Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: AppColors.cardSurfaceColor,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.errorMessage != null && state.members.isEmpty) {
          return Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: AppColors.cardSurfaceColor,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Text(
              'Error: ${state.errorMessage}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.errorColor,
              ),
            ),
          );
        }

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
              if (state.members.isEmpty)
                Text(
                  'No active members',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondaryColor,
                  ),
                )
              else
                ...state.members.map(
                  (member) => Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: _UserRow(
                      member: member,
                      localNow: state.localNow ?? DateTime.now(),
                      isPaused: state.pausedMemberIds.contains(member.userId),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _UserRow extends StatelessWidget {
  const _UserRow({
    required this.member,
    required this.localNow,
    required this.isPaused,
  });

  final RoomMemberWithSession member;
  final DateTime localNow;
  final bool isPaused;

  ({String? focusDisplay, String? subLabel}) _computeDisplay() {
    if (member.sessionId == null) {
      return (
        focusDisplay: null,
        subLabel: member.status.name.replaceFirst(
          member.status.name[0],
          member.status.name[0].toUpperCase(),
        ),
      );
    }

    if (member.sessionType == SessionType.focus && member.startedAt != null && !isPaused) {
      final elapsed =
          localNow.difference(member.startedAt!).inSeconds -
          (member.totalPausedSeconds ?? 0);
      final totalSeconds = member.completedFocusSeconds + elapsed;
      final display = _formatSeconds(totalSeconds);
      return (focusDisplay: '⏱️ $display', subLabel: null);
    }

    if (member.sessionType == SessionType.focus &&
        member.pausedAt != null &&
        member.startedAt != null) {
      final elapsed =
          member.pausedAt!.difference(member.startedAt!).inSeconds -
          (member.totalPausedSeconds ?? 0);
      final totalSeconds = member.completedFocusSeconds + elapsed;
      final display = _formatSeconds(totalSeconds);
      return (focusDisplay: '⏱️ $display', subLabel: '⏸ Paused');
    }

    if (member.sessionType == SessionType.breakTime &&
        member.startedAt != null &&
        member.plannedMinutes != null &&
        !isPaused) {
      final focusDisplay = _formatSeconds(member.completedFocusSeconds);
      final breakRemaining =
          (member.plannedMinutes! * 60) -
          (localNow.difference(member.startedAt!).inSeconds -
              (member.totalPausedSeconds ?? 0));
      final breakDisplay = breakRemaining > 0
          ? _formatSeconds(breakRemaining)
          : '00:00';
      return (
        focusDisplay: '⏱️ $focusDisplay',
        subLabel: '☕ break ends in $breakDisplay',
      );
    }

    // Paused break session
    if (member.sessionType == SessionType.breakTime &&
        member.startedAt != null &&
        member.plannedMinutes != null &&
        isPaused) {
      final focusDisplay = _formatSeconds(member.completedFocusSeconds);
      final pausedBreakRemaining =
          (member.plannedMinutes! * 60) -
          (member.pausedAt != null
              ? member.pausedAt!.difference(member.startedAt!).inSeconds -
                  (member.totalPausedSeconds ?? 0)
              : 0);
      final breakDisplay = pausedBreakRemaining > 0
          ? _formatSeconds(pausedBreakRemaining)
          : '00:00';
      return (
        focusDisplay: '⏱️ $focusDisplay',
        subLabel: '☕ break paused: $breakDisplay remaining',
      );
    }

    return (focusDisplay: null, subLabel: null);
  }

  String _formatSeconds(int seconds) {
    final hours = seconds ~/ 3600;
    final mins = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final display = _computeDisplay();
    final opacity = member.status == MemberStatus.offline ? 0.5 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Row(
        children: [
          _AvatarWithStatus(
            statusColor: _statusColor(member.status),
            avatarUrl: member.avatarUrl,
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.fullName,
                style: AppTextStyles.titleSmall.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.textPrimaryColor,
                ),
              ),
              if (display.focusDisplay != null)
                Text(
                  display.focusDisplay!,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.primaryColor,
                    fontFamily: AppTextStyles.spaceGrotesk,
                  ),
                ),
              if (display.subLabel != null)
                Text(
                  display.subLabel!,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.textSecondaryColor,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(MemberStatus status) {
    switch (status) {
      case MemberStatus.online:
        return AppColors.primaryColor;
      case MemberStatus.working:
        return const Color(0xFF18BB4B);
      case MemberStatus.onBreak:
        return const Color(0xFFDC9624);
      case MemberStatus.idle:
        return const Color(0xFF2C96E5);
      case MemberStatus.offline:
        return AppColors.textTertiaryColor;
    }
  }
}

class _AvatarWithStatus extends StatelessWidget {
  const _AvatarWithStatus({required this.statusColor, required this.avatarUrl});

  final Color statusColor;
  final String? avatarUrl;

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
            child: avatarUrl != null
                ? RoomsCardAvatar(url: avatarUrl!, size: 40.r)
                : Icon(
                    Icons.person,
                    size: 20.r,
                    color: AppColors.textSecondaryColor,
                  ),
          ),
          Positioned(
            right: 3.r,
            bottom: 3.r,
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
  const _LeaderboardCard({required this.topLeaders});

  final List<LeaderboardEntry> topLeaders;

  @override
  Widget build(BuildContext context) {
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
          if (topLeaders.isEmpty)
            Text(
              'No focus sessions yet',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondaryColor,
              ),
            )
          else
            ...topLeaders.asMap().entries.map(
              (entry) {
                final index = entry.key + 1;
                final leader = entry.value;
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$index. ${leader.userName}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                      Text(
                        '${leader.totalFocusHours}h',
                        style: AppTextStyles.titleSmall.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF99CBFF),
                          fontFamily: AppTextStyles.manrope,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
