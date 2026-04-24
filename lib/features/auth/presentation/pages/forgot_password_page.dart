import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/core/router/app_router.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/core/util/validators.dart';
import 'package:malaz/features/auth/presentation/widgets/auth_header.dart';
import 'package:malaz/core/widgets/app_loading_button.dart';
import 'package:malaz/features/auth/presentation/widgets/auth_navigation_link.dart';
import 'package:malaz/core/widgets/blurred_circle_decoration.dart';
import 'package:malaz/features/auth/presentation/widgets/info_box.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

import '../../../../core/widgets/app_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendReset() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().sendPasswordReset(
      email: _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
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

          if (state.uiState == UiState.success) {
            setState(() => _sent = true);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    'Reset link sent to ${state.user?.email ?? 'your email'} check your inbox!',
                  ),
                  backgroundColor: AppColors.successColor,
                ),
              );
          }
        },
        child: Stack(
          children: [
            BlurredCircleDecoration(
              left: -120.w,
              top: -200.h,
              width: 234.w,
              height: 600.h,
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
                          title: 'Reset Password',
                          subtitle:
                              "Enter your email address and we'll send you a link to reset your password.",
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            children: [
                              SizedBox(height: 16.h),
                              AppTextField(
                                label: 'Email Address',
                                hintText: 'Enter your email address',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                prefixIcon: Icons.email_outlined,
                                validator: Validators.validateEmail,
                              ),
                              SizedBox(height: 24.h),
                              BlocBuilder<AuthCubit, AuthState>(
                                builder: (context, state) {
                                  return AppLoadingButton(
                                    label: 'Send Reset Link',
                                    isLoading: state.uiState == UiState.loading,
                                    onPressed: _onSendReset,
                                  );
                                },
                              ),
                              SizedBox(height: 24.h),
                              if (_sent) ...[
                                InfoBox(
                                  icon: Icons.info_outline,
                                  title: 'What happens next?',
                                  items: const [
                                    'Check your inbox for a reset email',
                                    'Click the link or copy the token',
                                    'Create your new password on the next screen',
                                  ],
                                ),
                                SizedBox(height: 24.h),
                                GestureDetector(
                                  onTap: () =>
                                      context.push(AppRouter.resetPassword),
                                  child: Text(
                                    'Already have a reset token?',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        AuthNavigationLink(
                          labelText: 'Remember your password? ',
                          linkText: 'Sign In',
                          onLinkPressed: () => context.pop(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
