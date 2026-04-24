import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/features/rooms/presentation/widgets/rooms/rooms_card_avatar.dart';

class AvatarStack extends StatelessWidget {
  const AvatarStack({super.key, required this.avatars});

  final List<String> avatars;

  @override
  Widget build(BuildContext context) {
    final size = 28.r;
    final overlap = 10.r;
    final display = avatars.take(3).toList();
    final extra = avatars.length - display.length;

    final totalWidth = display.isEmpty
        ? 0.0
        : display.length * (size - overlap) +
              overlap +
              (extra > 0 ? size - overlap : 0);

    return SizedBox(
      width: totalWidth,
      height: size,
      child: Stack(
        children: [
          for (int i = 0; i < display.length; i++)
            Positioned(
              left: i * (size - overlap),
              child: RoomsCardAvatar(url: display[i], size: size),
            ),
          if (extra > 0)
            Positioned(
              left: display.length * (size - overlap),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceColor,
                  border: Border.all(
                    color: AppColors.surfaceContainerColor,
                    width: 1.5.r,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+$extra',
                    style: AppTextStyles.labelSmall.copyWith(fontSize: 9.sp),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
