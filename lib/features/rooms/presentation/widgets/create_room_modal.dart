import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/features/rooms/presentation/cubit/rooms_cubit.dart';
import 'package:malaz/features/rooms/presentation/cubit/rooms_state.dart';
import 'package:malaz/features/rooms/presentation/widgets/add_type_modal.dart';

class CreateRoomModal extends StatefulWidget {
  const CreateRoomModal({super.key});

  @override
  State<CreateRoomModal> createState() => _CreateRoomModalState();
}

class _CreateRoomModalState extends State<CreateRoomModal> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> _types = ['Study 📚', 'Coding 💻', 'Gym 💪'];
  String? _selectedType;
  String _selectedColor = '#4A90D9';
  bool _isPrivate = false;
  bool _obscurePassword = true;

  static const List<String> _colors = [
    '#4A90D9',
    '#2ECC71',
    '#9B59B6',
    '#E67E22',
    '#E74C3C',
    '#66D9CC',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Color _parseColor(String hex) {
    try {
      final cleaned = hex.replaceAll('#', '').padLeft(6, '0');
      return Color(int.parse('FF$cleaned', radix: 16));
    } catch (_) {
      return AppColors.primaryColor;
    }
  }

  Future<void> _openAddTypeModal() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTypeModal(),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _types.add(result);
        _selectedType = result;
      });
    }
  }

  void _submit(bool isCreating) {
    if (isCreating) return;
    if (!_formKey.currentState!.validate()) return;
    context.read<RoomsCubit>().createRoom(
      name: _nameController.text.trim(),
      type: _selectedType ?? _types.first,
      color: _selectedColor,
      isPrivate: _isPrivate,
      password: _isPrivate ? _passwordController.text : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomsCubit, RoomsState>(
      listener: (context, state) {
        if (state.createStatus == CreateRoomStatus.createSuccess) {
          Navigator.pop(context);
        } else if (state.createStatus == CreateRoomStatus.createFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.createErrorMessage ?? 'Failed to create room.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onErrorColor,
                ),
              ),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
      },
      child: BlocBuilder<RoomsCubit, RoomsState>(
        builder: (context, state) {
          final isCreating = state.createStatus == CreateRoomStatus.creating;
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
              ),
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
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
                      Text('Create Room', style: AppTextStyles.headlineSmall),
                      SizedBox(height: 4.h),
                      Text(
                        'Set up your focus space',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiaryColor,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Room Name
                      Text(
                        'ROOM NAME',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textSecondaryColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        enabled: !isCreating,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? 'Room name is required'
                                : null,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Deep Work',
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Type
                      Text(
                        'TYPE',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textSecondaryColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          ..._types.map((type) => _TypeChip(
                                label: type,
                                isSelected: _selectedType == type,
                                onTap: isCreating
                                    ? null
                                    : () =>
                                        setState(() => _selectedType = type),
                              )),
                          _TypeChip(
                            label: '+ Custom',
                            isSelected: false,
                            onTap: isCreating ? null : _openAddTypeModal,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // Room Color
                      Text(
                        'ROOM COLOR',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textSecondaryColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: _colors.map((hex) {
                          final isSelected = _selectedColor == hex;
                          return Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: GestureDetector(
                              onTap: isCreating
                                  ? null
                                  : () =>
                                      setState(() => _selectedColor = hex),
                              child: Container(
                                width: 36.r,
                                height: 36.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _parseColor(hex),
                                  border: isSelected
                                      ? Border.all(
                                          color: Colors.white,
                                          width: 2.5,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20.h),

                      // Private Room toggle
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Private Room',
                                  style: AppTextStyles.titleSmall,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Only invited members can join',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textTertiaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isPrivate,
                            onChanged: isCreating
                                ? null
                                : (v) => setState(() => _isPrivate = v),
                            activeThumbColor: AppColors.primaryColor,
                          activeTrackColor: AppColors.primaryColor.withValues(alpha: 0.5),
                          ),
                        ],
                      ),

                      // Password (conditional)
                      if (_isPrivate) ...[
                        SizedBox(height: 20.h),
                        Text(
                          'PASSWORD',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.textSecondaryColor,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          enabled: !isCreating,
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? 'Password is required for private rooms'
                                  : null,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 20.r,
                                color: AppColors.textTertiaryColor,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                        ),
                      ],

                      SizedBox(height: 32.h),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed:
                              isCreating ? null : () => _submit(isCreating),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: AppColors.onPrimaryColor,
                            disabledBackgroundColor:
                                AppColors.primaryColor.withValues(alpha: 0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          child: isCreating
                              ? SizedBox(
                                  width: 22.r,
                                  height: 22.r,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColors.onPrimaryColor,
                                  ),
                                )
                              : Text(
                                  'CREATE ROOM',
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
            ),
          );
        },
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withValues(alpha: 0.15)
              : AppColors.inputBackgroundColor,
          borderRadius: BorderRadius.circular(999),
          border: isSelected
              ? Border.all(color: AppColors.primaryColor, width: 1.5)
              : Border.all(color: AppColors.borderColor, width: 1),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.textSecondaryColor,
          ),
        ),
      ),
    );
  }
}
