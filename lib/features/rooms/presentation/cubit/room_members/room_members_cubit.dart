import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/repositories/room_members_repository.dart';
import 'room_members_state.dart';

class RoomMembersCubit extends Cubit<RoomMembersState> {
  final String roomId;
  final RoomMembersRepository _repository;

  Timer? _ticker;
  RealtimeChannel? _realtimeChannel;

  RoomMembersCubit({
    required this.roomId,
    required RoomMembersRepository repository,
  }) : _repository = repository,
       super(const RoomMembersState());

  @override
  Future<void> close() async {
    _ticker?.cancel();
    if (_realtimeChannel != null) {
      await _repository.unsubscribeFromRoomChanges(_realtimeChannel!);
    }
    return super.close();
  }

  /// Initialize: fetch members and start realtime subscription
  Future<void> init() async {
    await _fetchMembers();
    _startRealtimeSubscription();
    _startTicker();
  }

  /// Fetch members with session data
  Future<void> _fetchMembers() async {
    if (!isClosed) {
      emit(state.copyWith(isLoading: true));
    }

    final result = await _repository.getMembers(roomId);

    if (isClosed) return;

    result.fold(
      onSuccess: (members) {
        // Check if any member has an active (running) session
        final hasActiveSession = members.any(
          (member) => member.sessionId != null && member.pausedAt == null,
        );

        // Track which members are paused
        final pausedMemberIds = members
            .where(
              (member) => member.sessionId != null && member.pausedAt != null,
            )
            .map((member) => member.userId)
            .toSet();

        emit(
          state.copyWith(
            members: members,
            isLoading: false,
            errorMessage: null,
            localNow: hasActiveSession ? DateTime.now() : null,
            pausedMemberIds: pausedMemberIds,
          ),
        );

        // Refresh leaderboard after member data is loaded
        unawaited(_refreshLeaderboard());
      },
      onFailure: (error, _) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: error.message ?? 'Failed to fetch members',
          ),
        );
      },
    );
  }

  /// Start realtime subscription to room_members and pomodoro_sessions
  void _startRealtimeSubscription() {
    _realtimeChannel = _repository.subscribeToRoomChanges(
      roomId,
      _onRealtimeEvent,
    );
  }

  /// Callback when a realtime event occurs
  void _onRealtimeEvent() {
    unawaited(_fetchMembers());
    unawaited(_refreshLeaderboard());
  }

  /// Start 1-second ticker to update localNow only for running sessions
  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isClosed) return;

      // Only emit if at least one member has an active (non-paused) session
      final hasActiveSession = state.members.any(
        (member) => member.sessionId != null && member.pausedAt == null,
      );

      if (hasActiveSession) {
        emit(state.copyWith(localNow: DateTime.now()));
      }
    });
  }

  /// Called when app goes to background
  Future<void> onPause() async {
    _ticker?.cancel();
    if (_realtimeChannel != null) {
      await _repository.unsubscribeFromRoomChanges(_realtimeChannel!);
      _realtimeChannel = null;
    }
  }

  /// Called when app resumes
  Future<void> onResume() async {
    await _fetchMembers();
    _startRealtimeSubscription();
    _startTicker();
  }

  /// Fetch and update leaderboard data
  Future<void> _refreshLeaderboard() async {
    final result = await _repository.getTopLeaders(roomId);

    if (isClosed) return;

    result.fold(
      onSuccess: (leaders) {
        emit(state.copyWith(topLeaders: leaders));
      },
      onFailure: (error, _) {
        // Keep existing leaderboard data on error, just log it
        // This matches the pattern of not blocking member display on error
      },
    );
  }
}
