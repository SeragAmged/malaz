import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/features/rooms/domain/entities/leaderboard_entry.dart';

class LeaderboardCard extends StatelessWidget {
  const LeaderboardCard({super.key, required this.topLeaders});

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
            SizedBox(
              width: double.infinity,
              child: Text(
                'No focus sessions yet',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondaryColor,
                ),
              ),
            )
          else
            ...topLeaders.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final leader = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$index. ${leader.userName}',
                      style: AppTextStyles.bodyMedium,
                    ),
                    Text(
                      '${leader.totalFocusHours}h',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
