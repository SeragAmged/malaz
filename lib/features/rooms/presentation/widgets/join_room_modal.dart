import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/core/router/app_router.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/core/util/validators.dart';
import 'package:malaz/core/widgets/app_loading_button.dart';
import 'package:malaz/core/widgets/app_text_field.dart';
import 'package:malaz/features/rooms/presentation/cubit/rooms_cubit.dart';
import 'package:malaz/features/rooms/presentation/cubit/rooms_state.dart';

class JoinRoomModal extends StatefulWidget {
  const JoinRoomModal({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  final String roomId;
  final String roomName;

  @override
  State<JoinRoomModal> createState() => _JoinRoomModalState();
}

class _JoinRoomModalState extends State<JoinRoomModal> {
  late final TextEditingController _passwordController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<RoomsCubit>().joinRoom(
      widget.roomId,
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomsCubit, RoomsState>(
      listener: (context, state) {
        if (state.isJoinSuccess) {
          context.read<RoomsCubit>().resetJoinStatus();
          Navigator.of(context).pop();
          context.go('${AppRouter.rooms}/${widget.roomId}');
        }

        if (state.isJoinFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.joinError?.message ?? 'Failed to join room.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onErrorColor,
                ),
              ),
              backgroundColor: AppColors.errorColor,
            ),
          );
          context.read<RoomsCubit>().resetJoinStatus();
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
                      Text('Enter Password', style: AppTextStyles.headlineSmall),
                      SizedBox(height: 4.h),
                      Text(
                        'This room is password protected',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiaryColor,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      AppTextField(
                        controller: _passwordController,
                        obscureText: true,
                        label: "PASSWORD",
                        enabled: !state.isJoining,
                        validator: Validators.validatePassword,
                        hintText: "Enter room password",
                      ),
                      SizedBox(height: 32.h),
                      AppLoadingButton(
                        label: 'JOIN',
                        onPressed: _submit,
                        isLoading: state.isJoining,
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
