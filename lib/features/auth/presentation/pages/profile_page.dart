import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/core/util/validators.dart';
import 'package:malaz/core/widgets/app_loading_button.dart';
import 'package:malaz/core/widgets/app_text_field.dart';
import 'package:malaz/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:malaz/features/auth/presentation/cubit/auth_state.dart';
import 'package:malaz/features/auth/presentation/widgets/avatar_selector.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late GlobalKey<FormState> _formKey;
  late String _originalName;
  int _originalAvatarIndex = 0;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    final authCubit = context.read<AuthCubit>();
    final currentUser = authCubit.state.user;

    _originalName = currentUser?.fullName ?? '';
    _nameController = TextEditingController(text: _originalName);

    if (authCubit.state.avatarUrls.isEmpty) {
      authCubit.loadAvatarUrls();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool _checkIfChanged() {
    final authCubit = context.read<AuthCubit>();
    final currentName = _nameController.text;
    final currentAvatarIndex = authCubit.state.selectedAvatarIndex;

    return currentName != _originalName ||
        currentAvatarIndex != _originalAvatarIndex;
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final authCubit = context.read<AuthCubit>();
      final newName = _nameController.text;
      final newAvatarUrl = authCubit.state.avatarUrls.isNotEmpty
          ? authCubit.state.avatarUrls[authCubit.state.selectedAvatarIndex]
          : null;

      authCubit.updateUserProfile(fullName: newName, avatarUrl: newAvatarUrl);
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerColor,
        title: Text('Logout', style: Theme.of(context).textTheme.titleLarge),
        content: Text(
          'Are you sure you want to logout?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().signOut();
            },
            child: Text(
              'Logout',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.errorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.uiState == UiState.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: const Text('Profile updated successfully'),
                backgroundColor: AppColors.successColor,
              ),
            );
          // Reset form to new state
          _originalName = state.user?.fullName ?? '';
          _nameController.text = _originalName;
          if (state.avatarUrls.isNotEmpty && state.user?.avatarUrl != null) {
            final index = state.avatarUrls.indexOf(state.user!.avatarUrl!);
            if (index != -1) {
              _originalAvatarIndex = index;
            }
          }
          context.read<AuthCubit>().resetSuccess();
        }

        if (state.hasError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: AppColors.errorColor,
              ),
            );
          context.read<AuthCubit>().clearError();
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final user = state.user;
          if (user == null) {
            return const Scaffold(
              body: Center(child: Text('No user data available')),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Display Section
                      _buildProfileHeader(user),
                      SizedBox(height: 40.h),

                      // Edit Form Section
                      _buildEditForm(state),
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

  Widget _buildProfileHeader(dynamic user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar
        Container(
          width: 120.r,
          height: 120.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.inputBackgroundColor,
          ),
          child: ClipOval(
            child: user.avatarUrl != null
                ? CachedNetworkImage(
                    imageUrl: user.avatarUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.person,
                      size: 60,
                      color: AppColors.textTertiaryColor,
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 60,
                    color: AppColors.textTertiaryColor,
                  ),
          ),
        ),
        SizedBox(height: 16.h),

        // Name
        Text(
          user.fullName ?? 'User',
          style: AppTextStyles.headlineSmall,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),

        // Email
        Text(
          user.email,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondaryColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEditForm(AuthState state) {
    return Column(
      children: [
        // Avatar Selector
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            if (authState.isLoadingAvatars) {
              return SizedBox(
                height: 32.h,
                width: 32.w,
                child: CircularProgressIndicator(strokeWidth: 2.w),
              );
            }
            log(
              'Building AvatarSelector with ${authState.avatarUrls.length} avatars, selected index: ${authState.selectedAvatarIndex}',
            );
            return AvatarSelector(
              selectedAvatarIndex: authState.selectedAvatarIndex,
              avatarUrls: authState.avatarUrls,
              onAvatarSelected: context.read<AuthCubit>().selectAvatar,
            );
          },
        ),
        SizedBox(height: 24.h),

        // Name TextField
        AppTextField(
          label: 'DISPLAY NAME',
          hintText: 'Update your name',
          controller: _nameController,
          prefixIcon: Icons.person_outline,
          validator: Validators.validateDisplayName,
          enabled: !state.isLoading,
        ),
        SizedBox(height: 24.h),

        // Save Button
        AppLoadingButton(
          label: 'SAVE CHANGES',
          onPressed: (_checkIfChanged() && !state.isLoading)
              ? _handleSave
              : () {},
          isLoading: state.isLoading,
        ),
        SizedBox(height: 32.h),

        // Logout Button
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: state.isLoading ? null : _handleLogout,
            child: Text(
              'LOGOUT',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.errorColor.withOpacity(.8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
