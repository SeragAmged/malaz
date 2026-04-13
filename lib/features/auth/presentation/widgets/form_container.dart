import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';

/// Consistent container for form content with styling
class FormContainer extends StatelessWidget {
  final List<Widget> children;
  final double padding;
  final double borderRadius;
  final Color? backgroundColor;

  const FormContainer({
    super.key,
    required this.children,
    this.padding = 24.0,
    this.borderRadius = 28.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding.r),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceContainerHighColor,
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
