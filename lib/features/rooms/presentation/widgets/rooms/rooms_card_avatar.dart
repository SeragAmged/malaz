import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';

class RoomsCardAvatar extends StatelessWidget {
  const RoomsCardAvatar({super.key, required this.url, required this.size});

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: ClipOval(
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Icon(
            Icons.person,
            size: 16.r,
            color: AppColors.textTertiaryColor,
          ),
        ),
      ),
    );
  }
}
