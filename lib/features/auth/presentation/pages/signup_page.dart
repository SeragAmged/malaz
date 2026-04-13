import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/features/auth/presentation/validators.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_branding.dart';
import '../widgets/auth_loading_button.dart';
import '../widgets/auth_navigation_link.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/avatar_selector.dart';
import '../widgets/blurred_circle_decoration.dart';
import '../widgets/confirmation_view.dart';
import '../widgets/form_container.dart';

/// Sign up page
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _signUpSuccess = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().loadAvatarUrls();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthCubit>().state;
      context.read<AuthCubit>().signUp(
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        fullName: _displayNameController.text,
        avatarUrl: authState.avatarUrls.isNotEmpty
            ? authState.avatarUrls[authState.selectedAvatarIndex]
            : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
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

        // If signUp returns without error and user is still unauthenticated,
        // it means email confirmation is pending
        if (!state.isLoading &&
            state.errorMessage == null &&
            state.uiState == UiState.success &&
            state.authStatus == AuthStatus.unauthenticated) {
          if (_signUpSuccess) return;
          setState(() => _signUpSuccess = true);

          context.read<AuthCubit>().resetSuccess();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Stack(
            children: [
              BlurredCircleDecoration(
                width: 300.w,
                height: 300.h,
                bottom: -200.h,
                right: -80.w,
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 24.h,
                    ),
                    child: Form(
                      key: _formKey,
                      child: _signUpSuccess
                          ? _buildConfirmationView()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AuthBranding(
                                  headlineFirst: 'Start your ',
                                  headlineSecond: 'Journey',
                                ),
                                SizedBox(height: 40.h),
                                FormContainer(
                                  children: [
                                    AuthTextField(
                                      label: 'EMAIL ADDRESS',
                                      hintText: 'name@flowstate.com',
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      prefixIcon: Icons.email_outlined,
                                      validator: Validators.validateEmail,
                                    ),
                                    SizedBox(height: 20.h),
                                    AuthTextField(
                                      label: 'CREATE PASSWORD',
                                      hintText: '••••••••',
                                      controller: _passwordController,
                                      obscureText: true,
                                      prefixIcon: Icons.lock_outline,
                                      validator: Validators.passwordValidator,
                                    ),
                                    SizedBox(height: 20.h),
                                    AuthTextField(
                                      label: 'CONFIRM PASSWORD',
                                      hintText: '••••••••',
                                      controller: _confirmPasswordController,
                                      obscureText: true,
                                      prefixIcon: Icons.lock_outline,
                                      validator: (value) =>
                                          Validators.confirmPasswordValidator(
                                            value,
                                            _passwordController.text,
                                          ),
                                    ),
                                    SizedBox(height: 20.h),
                                    AuthTextField(
                                      label: 'DISPLAY NAME',
                                      hintText: 'How should we call you?',
                                      controller: _displayNameController,
                                      prefixIcon: Icons.person_outline,
                                      validator: Validators.validateDisplayName,
                                    ),
                                    SizedBox(height: 24.h),
                                    BlocBuilder<AuthCubit, AuthState>(
                                      builder: (context, authState) {
                                        if (authState.isLoadingAvatars) {
                                          return SizedBox(
                                            height: 32.h,
                                            width: 32.w,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.w,
                                            ),
                                          );
                                        }

                                        return AvatarSelector(
                                          selectedAvatarIndex:
                                              authState.selectedAvatarIndex,
                                          avatarUrls: authState.avatarUrls,
                                          onAvatarSelected: (avatarIndex) =>
                                              context
                                                  .read<AuthCubit>()
                                                  .selectAvatar(avatarIndex),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 32.h),
                                    BlocBuilder<AuthCubit, AuthState>(
                                      builder: (context, state) {
                                        return AuthLoadingButton(
                                          label: 'SIGN UP',
                                          onPressed: _handleSignUp,
                                          isLoading: state.isLoading,
                                        );
                                      },
                                    ),
                                    SizedBox(height: 24.h),
                                    AuthNavigationLink(
                                      labelText: 'Already have an account? ',
                                      linkText: 'Login',
                                      onLinkPressed: () => context.pop(),
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
        );
      },
    );
  }

  Widget _buildConfirmationView() {
    return ConfirmationView(
      icon: Icons.mark_email_read_outlined,
      title: 'Check Your Email',
      description:
          'We sent a confirmation link to\n${_emailController.text.trim()}\n\nPlease verify your email to continue.',
      buttonLabel: 'Back to Sign In',
      onButtonPressed: () => context.pop(),
    );
  }
}
