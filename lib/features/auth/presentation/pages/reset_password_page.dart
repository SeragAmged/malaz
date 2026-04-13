import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/core/router/app_router.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/features/auth/presentation/validators.dart';
import 'package:malaz/features/auth/presentation/widgets/auth_loading_button.dart';
import 'package:malaz/features/auth/presentation/widgets/blurred_circle_decoration.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/info_box.dart';
import '../widgets/read_only_field.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final bool _obscurePassword = true;
  final bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onReset() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().resetPassword(
      newPassword: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.errorColor,
                ),
              );
            context.read<AuthCubit>().clearError();
          }

          if (state.isAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Password reset successful!'),
                backgroundColor: AppColors.successColor,
              ),
            );
            context.go(AppRouter.rooms);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              BlurredCircleDecoration(
                width: 300.w,
                height: 300.h,
                bottom: -200.h,
                left: -80.w,
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AuthHeader(
                            icon: Icon(
                              Icons.lock_reset_rounded,
                              size: 28.r,
                              color: AppColors.primaryColor,
                            ),
                            title: 'Create New Password',
                            subtitle:
                                'Choose a new password to secure your account.',
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Column(
                              children: [
                                SizedBox(height: 16.h),
                                ReadOnlyField(
                                  label: 'Email Address',
                                  value: state.user?.email ?? 'No email found',
                                  icon: Icons.email_outlined,
                                ),
                                SizedBox(height: 20.h),
                                AuthTextField(
                                  label: 'New Password',
                                  hintText: 'Enter new password',
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  textInputAction: TextInputAction.next,
                                  prefixIcon: Icons.lock_outline,

                                  validator: Validators.passwordValidator,
                                ),
                                SizedBox(height: 20.h),
                                AuthTextField(
                                  label: 'Confirm Password',
                                  hintText: 'Enter new password',
                                  controller: _confirmController,
                                  obscureText: _obscureConfirm,
                                  textInputAction: TextInputAction.done,
                                  prefixIcon: Icons.lock_outline,

                                  validator: (value) =>
                                      Validators.confirmPasswordValidator(
                                        value,
                                        _passwordController.text,
                                      ),
                                ),
                                SizedBox(height: 20.h),
                                const InfoBox(
                                  icon: Icons.lightbulb_outline,
                                  title: 'Password Tips',
                                  items: [
                                    'Use at least 8 characters',
                                    'Include numbers and special characters',
                                    'Mix uppercase and lowercase letters',
                                  ],
                                ),
                                SizedBox(height: 24.h),

                                AuthLoadingButton(
                                  label: "Reset Password",
                                  onPressed: _onReset,
                                  isLoading: state.uiState == UiState.loading,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
