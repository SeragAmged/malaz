import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

/// Avatar selection widget
class AvatarSelector extends StatelessWidget {
  final int selectedAvatarIndex;
  final ValueChanged<int> onAvatarSelected;
  final List<String> avatarUrls;

  const AvatarSelector({
    super.key,
    required this.onAvatarSelected,
    required this.selectedAvatarIndex,
    required this.avatarUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'Choose your avatar',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondaryColor,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16.h,
            crossAxisSpacing: 16.h,
            childAspectRatio: 1,
            mainAxisExtent: 80.w,
          ),
          itemCount: avatarUrls.length,
          itemBuilder: (context, index) {
            final avatarUrl = avatarUrls[index];
            final isSelected = selectedAvatarIndex == index;

            return GestureDetector(
              onTap: () => onAvatarSelected(index),
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.primaryColor.withValues(alpha: 0.2)
                      : AppColors.inputBackgroundColor,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: avatarUrl,
                  fit: BoxFit.scaleDown,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.surfaceContainerColor,
                    child: const Icon(Icons.person),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
