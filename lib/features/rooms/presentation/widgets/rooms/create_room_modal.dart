
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/core/router/app_router.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/core/util/errors/domain_errors.dart';
import 'package:malaz/core/util/validators.dart';
import 'package:malaz/core/widgets/app_loading_button.dart';
import 'package:malaz/core/widgets/app_text_field.dart';
import 'package:malaz/features/rooms/presentation/cubit/rooms/rooms_cubit.dart';
import 'package:malaz/features/rooms/presentation/cubit/rooms/rooms_state.dart';
import 'package:malaz/features/rooms/presentation/widgets/rooms/add_type_modal.dart';
import 'package:malaz/features/rooms/presentation/widgets/rooms/leave_room_dialog.dart';
import 'package:malaz/features/rooms/presentation/widgets/rooms/room_type_chip.dart';

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
  final bool _obscurePassword = true;
  BuildContext? _leaveDialogContext;

  static const List<String> _colors = [
    '#4A90D9',
    '#2ECC71',
    '#9B59B6',
    '#E67E22',
    '#E74C3C',
    '#66D9CC',
  ];

  @override
  void initState() {
    _selectedType = _types.first;
    super.initState();
  }

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

  void _submit() {
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
      listener: (context, state)  {
        if (state.isLeaveSuccess) {
          if (_leaveDialogContext != null) {
            Navigator.of(_leaveDialogContext!).pop();
            _leaveDialogContext = null;
          }
          context.read<RoomsCubit>().resetStatuses();
        }

        if (state.isCreateSuccess) {
          Navigator.of(context).pop();
          context.go('${AppRouter.rooms}/${state.newRoomId}');
          context.read<RoomsCubit>().resetStatuses();
        }

        if (state.isCreateFailure) {
          if (state.createError is AlreadyInRoom) {
            showDialog(
              context: context,
              builder: (newContext) {
                _leaveDialogContext = newContext;
                return BlocProvider.value(
                  value: context.read<RoomsCubit>(),
                  child: LeaveRoomDialog(),
                );
              },
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.createError?.message ?? 'Failed to create room.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onErrorColor,
                  ),
                ),
                backgroundColor: AppColors.errorColor,
              ),
            );
          }
          context.read<RoomsCubit>().resetStatuses();
        }
      },
      child: BlocBuilder<RoomsCubit, RoomsState>(
        builder: (context, state) {
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
                      AppTextField(
                        label: "ROOM NAME",
                        controller: _nameController,
                        hintText: "e.g. Deep Work",
                        textInputAction: TextInputAction.next,
                        validator: (value) => Validators.validateEmpty(
                          value,
                          'Room name is required',
                        ),
                      ),
                      SizedBox(height: 20.h),
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
                          ..._types.map(
                            (type) => RoomTypeChip(
                              label: type,
                              isSelected: _selectedType == type,
                              onTap: state.isCreating
                                  ? null
                                  : () => setState(() => _selectedType = type),
                            ),
                          ),
                          RoomTypeChip(
                            label: '+ Custom',
                            isSelected: false,
                            onTap: state.isCreating ? null : _openAddTypeModal,
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
                              onTap: state.isCreating
                                  ? null
                                  : () => setState(() => _selectedColor = hex),
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
                            onChanged: state.isCreating
                                ? null
                                : (v) => setState(() => _isPrivate = v),
                            activeThumbColor: AppColors.primaryColor,
                            activeTrackColor: AppColors.primaryColor.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ],
                      ),

                      // Password (conditional)
                      if (_isPrivate) ...[
                        SizedBox(height: 20.h),
                        AppTextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          label: "PASSWORD",
                          enabled: !state.isCreating,
                          validator: Validators.validatePassword,
                          hintText: "******",
                        ),
                      ],

                      SizedBox(height: 32.h),

                      // Submit button
                      AppLoadingButton(
                        label: 'CREATE ROOM',
                        onPressed: _submit,
                        isLoading: state.isCreating,
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
