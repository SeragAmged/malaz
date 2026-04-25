import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/features/rooms/presentation/widgets/rooms/rooms_card_avatar.dart';

class AvatarWithStatus extends StatelessWidget {
  const AvatarWithStatus({super.key, required this.statusColor, required this.avatarUrl});

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
