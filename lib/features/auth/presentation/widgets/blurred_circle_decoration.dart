import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:malaz/core/theme/app_colors.dart';

/// A decorative blurred circle background element
class BlurredCircleDecoration extends StatelessWidget {
  final double width;
  final double height;

  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double blurSigma;
  final Color? color;
  final double colorAlpha;

  const BlurredCircleDecoration({
    super.key,
    required this.width,
    required this.height,

    this.blurSigma = 60.0,
    this.color,
    this.colorAlpha = 0.3,
    this.left,
    this.top,
    this.right,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,

      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (color ?? AppColors.primaryColor).withValues(
              alpha: colorAlpha,
            ),
          ),
        ),
      ),
    );
  }
}
