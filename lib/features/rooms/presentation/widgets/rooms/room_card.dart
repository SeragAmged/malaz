import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/core/theme/extensions.dart';
import 'package:malaz/features/rooms/domain/entities/enums.dart';
import 'package:malaz/features/rooms/domain/entities/room.dart';
import 'package:malaz/features/rooms/presentation/cubit/rooms/rooms_cubit.dart';
import 'package:malaz/features/rooms/presentation/cubit/rooms/rooms_state.dart';
import 'package:malaz/features/rooms/presentation/widgets/rooms/avatar_stack.dart';
import 'package:malaz/features/rooms/presentation/widgets/rooms/join_room_modal.dart';

class RoomCard extends StatefulWidget {
  const RoomCard({super.key, required this.room});

  final Room room;

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  bool get _isLive =>
      widget.room.sessionType == SessionType.focus &&
      widget.room.sessionStartedAt != null &&
      widget.room.pausedAt == null;

  Color get _accentColor => widget.room.color.toColor;

  void _handleJoinPress() {
    if (widget.room.isProtected && !widget.room.isMember) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => BlocProvider.value(
          value: context.read<RoomsCubit>(),
          child: JoinRoomModal(
            roomId: widget.room.id,
            roomName: widget.room.name,
          ),
        ),
      );
    } else {
      context.read<RoomsCubit>().joinRoom(widget.room.id, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurfaceColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _accentColor,
                      ),
                    ),
                    SizedBox(width: 3.5.w),
                    Expanded(
                      child: Text(
                        widget.room.type.toUpperCase(),
                        style: AppTextStyles.cardTagMedium.copyWith(
                          color: _accentColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: ShapeDecoration(
                        shape: RoundedSuperellipseBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        color: AppColors.inputBackgroundColor,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.people_alt,
                            size: 13.r,
                            color: _accentColor,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${widget.room.activeMembers} active',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textPrimaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.room.name,
                        style: AppTextStyles.headlineSmall,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 64.h),
                Row(
                  children: [
                    AvatarStack(avatars: widget.room.membersAvatars),
                    const Spacer(),
                    BlocBuilder<RoomsCubit, RoomsState>(
                      builder: (context, state) {
                        return InkWell(
                          onTap: _handleJoinPress,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: accent,
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                            child: Row(
                              children: [
                                if (state.isJoining &&
                                    state.joinedRoomId == widget.room.id)
                                  SizedBox(
                                    width: 16.r,
                                    height: 16.r,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: _accentColor.getContrastColor,
                                    ),
                                  )
                                else
                                  Text(
                                    widget.room.isMember ? 'Go Back' : 'Join',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: _accentColor.getContrastColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                if (widget.room.isProtected)
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.w),
                                    child: Icon(
                                      Icons.lock_rounded,
                                      size: 16.r,
                                      color: _accentColor.getContrastColor,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
