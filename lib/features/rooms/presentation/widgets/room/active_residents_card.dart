import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/features/rooms/presentation/cubit/room_members/room_members_state.dart';
import 'package:malaz/features/rooms/presentation/pages/room_page.dart';

class ActiveResidentsCard extends StatelessWidget {
  const ActiveResidentsCard(this.state, {super.key});
  final RoomMembersState state;

  @override
  Widget build(BuildContext context) {
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
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.errorColor),
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
            style: AppTextStyles.bodySmall.copyWith(
              letterSpacing: 2.4,
              fontFamily: AppTextStyles.spaceGrotesk,
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
                child: UserRow(
                  member: member,
                  localNow: state.localNow ?? DateTime.now(),
                  isPaused: state.pausedMemberIds.contains(member.userId),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
