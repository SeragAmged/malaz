import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/room_members_repository.dart';
import '../../data/models/room_member_with_session_model.dart';
import 'room_members_state.dart';

@injectable
class RoomMembersCubit extends Cubit<RoomMembersState> {
  final String roomId;
  final RoomMembersRepository _repository;

  Timer? _ticker;
  RealtimeChannel? _realtimeChannel;

  RoomMembersCubit({
    required this.roomId,
    required RoomMembersRepository repository,
  })  : _repository = repository,
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
        emit(
          state.copyWith(
            members: members
                .map((e) => RoomMemberWithSessionModel(
                      userId: e.userId,
                      fullName: e.fullName,
                      avatarUrl: e.avatarUrl,
                      status: e.status,
                      lastCheckinAt: e.lastCheckinAt,
                      completedFocusSeconds: e.completedFocusSeconds,
                      sessionId: e.sessionId,
                      sessionType: e.sessionType,
                      startedAt: e.startedAt,
                      plannedMinutes: e.plannedMinutes,
                      pausedAt: e.pausedAt,
                      totalPausedSeconds: e.totalPausedSeconds,
                    ))
                .toList(),
            isLoading: false,
            errorMessage: null,
          ),
        );
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
    _fetchMembers();
  }

  /// Start 1-second ticker to update localNow
  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isClosed) {
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
}
