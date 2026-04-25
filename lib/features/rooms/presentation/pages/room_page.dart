import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/core/di/providers.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/core/theme/extensions.dart';
import 'package:malaz/core/widgets/app_loading_button.dart';
import 'package:malaz/features/rooms/domain/entities/enums.dart';
import 'package:malaz/features/rooms/domain/entities/leaderboard_entry.dart';
import 'package:malaz/features/rooms/domain/entities/room_member_with_session.dart';
import 'package:malaz/features/rooms/presentation/cubit/timer/timer_cubit.dart';
import 'package:malaz/features/rooms/presentation/cubit/timer/timer_state.dart';
import 'package:malaz/features/rooms/presentation/cubit/room_members/room_members_cubit.dart';
import 'package:malaz/features/rooms/presentation/cubit/room_members/room_members_state.dart';
import 'package:malaz/features/rooms/presentation/widgets/room/active_residents_card.dart';
import 'package:malaz/features/rooms/presentation/widgets/room/avatar_with_status.dart';
import 'package:malaz/features/rooms/presentation/widgets/room/edit_card_body.dart';
import 'package:malaz/features/rooms/presentation/widgets/room/leaderboard_card.dart';
import 'package:malaz/features/rooms/presentation/widgets/room/rolling_digit.dart';
import 'package:malaz/features/rooms/presentation/widgets/room/rolling_timer_text.dart';
import 'package:malaz/features/rooms/presentation/widgets/room/timer_card.dart';
import 'package:malaz/features/rooms/presentation/widgets/room/outlined_action_button.dart';
import 'package:malaz/features/rooms/presentation/widgets/room/room_timer_card_shell.dart';
import 'package:malaz/features/rooms/presentation/widgets/rooms/rooms_card_avatar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({
    super.key,
    required this.roomId,
    required this.roomName,
    this.roomColor = AppColors.primaryColor,
  });

  final String roomId;
  final String roomName;
  final Color? roomColor;

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> with WidgetsBindingObserver {
  late TimerCubit _timerCubit;
  late RoomMembersCubit _roomMembersCubit;
  bool _isEditing = false;

  late int _draftFocusMinutes = 25;
  late int _draftBreakMinutes = 5;
  Color get _roomColor => widget.roomColor ?? AppColors.primaryColor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timerCubit = getIt<TimerCubit>(param1: widget.roomId);
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<TimerCubit>(create: (_) => _timerCubit),
        BlocProvider<RoomMembersCubit>(create: (_) => _roomMembersCubit),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                widget.roomName,
                style: AppTextStyles.appBarTitle20.copyWith(color: _roomColor),
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              // Error message if any
              BlocBuilder<TimerCubit, TimerState>(
                builder: (context, timerState) =>
                    timerState.errorMessage != null
                    ? Container(
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
                      )
                    : const SizedBox.shrink(),
              ),
              BlocBuilder<TimerCubit, TimerState>(
                builder: (context, timerState) {
                  return RoomTimerCardShell(
                    color: timerState.isFocusMode || _isEditing
                        ? _roomColor
                        : AppColors.warningColor,
                    isEditing: _isEditing,
                    timerContent: TimerCard(
                      color: _roomColor,
                      mode: timerState.mode,
                      timerDisplay: timerState.timerDisplay,
                      isRunning: timerState.isRunning,
                      isLoading: timerState.isLoading,
                      timerStatus: timerState.status,
                      onStartStop: timerState.isRunning
                          ? _timerCubit.pauseSession
                          : timerState.isPaused
                          ? _timerCubit.resumeSession
                          : _timerCubit.startSession,
                      onBreak: _timerCubit.flipMode,
                      onReset: _timerCubit.resetSession,
                      onEnd: () => _timerCubit.endSession(
                        reason: SessionEndReason.interrupted,
                      ),
                      onSettings: () => _openEdit(timerState),
                    ),
                    editContent: EditCardBody(
                      color: _roomColor,
                      draftFocusMinutes: _draftFocusMinutes,
                      draftBreakMinutes: _draftBreakMinutes,
                      onFocusChanged: (v) =>
                          setState(() => _draftFocusMinutes = v),
                      onBreakChanged: (v) =>
                          setState(() => _draftBreakMinutes = v),
                      onApply: _applyEdit,
                      onCancel: _cancelEdit,
                    ),
                  );
                },
              ),
              SizedBox(height: 24.h),
              BlocBuilder<RoomMembersCubit, RoomMembersState>(
                builder: (context, state) => ActiveResidentsCard(state),
              ),
              SizedBox(height: 24.h),
              BlocBuilder<RoomMembersCubit, RoomMembersState>(
                builder: (context, state) =>
                    LeaderboardCard(topLeaders: state.topLeaders),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserRow extends StatelessWidget {
  const UserRow({
    super.key,
    required this.member,
    required this.localNow,
    required this.isPaused,
  });

  final RoomMemberWithSession member;
  final DateTime localNow;
  final bool isPaused;

  String _formatSeconds(int seconds) {
    final hours = seconds ~/ 3600;
    final mins = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Color _statusColor(UserStatus status) {
    switch (status) {
      case UserStatus.online:
        return AppColors.primaryColor;
      case UserStatus.working:
        return const Color(0xFF18BB4B);
      case UserStatus.onBreak:
        return const Color(0xFFDC9624);
      case UserStatus.idle:
        return const Color(0xFF2C96E5);
      case UserStatus.offline:
        return AppColors.textTertiaryColor;
    }
  }

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

    if (member.sessionType == SessionType.focus &&
        member.startedAt != null &&
        !isPaused) {
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

  @override
  Widget build(BuildContext context) {
    final display = _computeDisplay();
    final opacity = member.status == UserStatus.offline ? 0.5 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Row(
        children: [
          AvatarWithStatus(
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
}
