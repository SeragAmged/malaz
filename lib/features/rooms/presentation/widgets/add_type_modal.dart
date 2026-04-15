import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';

class AddTypeModal extends StatefulWidget {
  const AddTypeModal({super.key});

  @override
  State<AddTypeModal> createState() => _AddTypeModalState();
}

class _AddTypeModalState extends State<AddTypeModal> {
  final _typeNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _typeNameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _typeNameController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.borderColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text('Add Type', style: AppTextStyles.headlineSmall),
              SizedBox(height: 4.h),
              Text(
                'Set up your focus space',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiaryColor,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'TYPE NAME',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondaryColor,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _typeNameController,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Type name is required'
                        : null,
                decoration: const InputDecoration(hintText: 'e.g. Drawing 🎨'),
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.onPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    'CREATE TYPE',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.onPrimaryColor,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
