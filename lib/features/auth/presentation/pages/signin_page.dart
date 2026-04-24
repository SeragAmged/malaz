import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/core/router/app_router.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/core/util/validators.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_branding.dart';
import '../../../../core/widgets/app_loading_button.dart';
import '../widgets/auth_navigation_link.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/blurred_circle_decoration.dart';
import '../widgets/form_container.dart';

/// Login page
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onErrorColor,
                ),
              ),
              backgroundColor: AppColors.errorColor,
            ),
          );
          context.read<AuthCubit>().clearError();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            BlurredCircleDecoration(
              width: 234.w,
              height: 600.h,
              right: -120.w,
              top: -200.h,
              colorAlpha: 0.1,
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AuthBranding(
                          headlineFirst: 'Enter your ',
                          headlineSecond: 'Sanctuary',
                        ),
                        SizedBox(height: 40.h),
                        FormContainer(
                          children: [
                            AppTextField(
                              label: 'EMAIL ADDRESS',
                              hintText: 'name@flowstate.com',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email_outlined,
                              validator: Validators.validateEmail,
                            ),
                            SizedBox(height: 20.h),

                            AppTextField(
                              label: 'PASSWORD',
                              hintText: '••••••••',
                              controller: _passwordController,
                              obscureText: true,
                              prefixIcon: Icons.lock_outline,
                              validator: Validators.passwordValidator,
                            ),
                            SizedBox(height: 24.h),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () =>
                                    context.push(AppRouter.forgotPassword),
                                child: Text(
                                  'Forgot password?',
                                  style: AppTextStyles.titleSmall.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return AppLoadingButton(
                                  label: 'LOGIN',
                                  onPressed: _handleLogin,
                                  isLoading: state.isLoading,
                                );
                              },
                            ),
                            SizedBox(height: 24.h),
                            AuthNavigationLink(
                              labelText: "Don't have an account? ",
                              linkText: 'Sign Up',
                              onLinkPressed: () =>
                                  context.push(AppRouter.signUp),
                            ),
                          ],
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
