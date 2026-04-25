# Profile Screen Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement a user profile screen with avatar/name editing, profile persistence via RPC, and logout functionality.

**Architecture:** Add `updateUserProfile()` to AuthRepository and AuthCubit, create ProfilePage to display user info and handle edits, integrate with existing AvatarSelector and form widgets, and replace TempScreen in router.

**Tech Stack:** Flutter, Dart, BLoC (Cubit), go_router, CachedNetworkImage, freezed, injectable

---

## File Structure

**Files to Create:**
- `lib/features/auth/presentation/pages/profile_page.dart` - Main profile screen widget

**Files to Modify:**
- `lib/features/auth/domain/repositories/auth_repository.dart` - Add abstract updateUserProfile method
- `lib/features/auth/data/repositories/auth_repository_impl.dart` - Implement updateUserProfile RPC call
- `lib/features/auth/presentation/cubit/auth_cubit.dart` - Add updateUserProfile method
- `lib/core/router/app_router.dart` - Replace TempScreen with ProfilePage

---

## Task 1: Add updateUserProfile to AuthRepository (Abstract)

**Files:**
- Modify: `lib/features/auth/domain/repositories/auth_repository.dart`

- [ ] **Step 1: Open auth_repository.dart and add method signature**

After the `resetPassword` method, add:

```dart
Future<Result<User, DomainError>> updateUserProfile({
  String? fullName,
  String? avatarUrl,
});
```

Complete file should look like:

```dart
import 'package:malaz/features/auth/domain/entities/auth_state_event.dart';

import '../../../../core/util/result.dart';
import '../../../../core/util/errors/domain_errors.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Result<void, DomainError>> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    String? fullName,
    String? avatarUrl,
  });

  Future<Result<User, DomainError>> signIn({
    required String email,
    required String password,
  });

  Future<Result<void, DomainError>> signOut();

  Future<Result<User?, DomainError>> getCurrentUser();

  Future<bool> isAuthenticated();

  Stream<AuthStateEvent> watchAuthState();

  Future<Result<void, DomainError>> sendPasswordReset({required String email});
  Future<Result<void, DomainError>> resetPassword({
    required String newPassword,
  });

  Future<Result<List<String>, DomainError>> loadAvatarUrls();

  Future<Result<User, DomainError>> updateUserProfile({
    String? fullName,
    String? avatarUrl,
  });
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/auth/domain/repositories/auth_repository.dart
git commit -m "feat(auth): add updateUserProfile abstract method to AuthRepository"
```

---

## Task 2: Implement updateUserProfile in AuthRepositoryImpl

**Files:**
- Modify: `lib/features/auth/data/repositories/auth_repository_impl.dart`

- [ ] **Step 1: Find and open auth_repository_impl.dart**

Run: `grep -n "class AuthRepositoryImpl" lib/features/auth/data/repositories/auth_repository_impl.dart`

- [ ] **Step 2: Add updateUserProfile implementation at the end of the class**

Before the closing brace, add:

```dart
@override
Future<Result<User, DomainError>> updateUserProfile({
  String? fullName,
  String? avatarUrl,
}) async {
  try {
    final response = await _supabaseClient.rpc(
      'update_user_profile',
      params: {
        'full_name': fullName,
        'avatar_url': avatarUrl,
      },
    ) as Map<String, dynamic>;

    final user = User(
      id: response['id'] ?? '',
      email: response['email'] ?? '',
      fullName: response['full_name'],
      avatarUrl: response['avatar_url'],
      createdAt: response['created_at'] != null
          ? DateTime.parse(response['created_at'])
          : DateTime.now(),
    );

    return Result.success(user);
  } on AuthException catch (e) {
    return Result.failure(
      AuthError(message: e.message),
      StackTrace.current,
    );
  } catch (e) {
    return Result.failure(
      UnknownError(message: e.toString()),
      StackTrace.current,
    );
  }
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/features/auth/data/repositories/auth_repository_impl.dart
git commit -m "feat(auth): implement updateUserProfile RPC call in AuthRepositoryImpl"
```

---

## Task 3: Add updateUserProfile method to AuthCubit

**Files:**
- Modify: `lib/features/auth/presentation/cubit/auth_cubit.dart`

- [ ] **Step 1: Open auth_cubit.dart**

- [ ] **Step 2: Add updateUserProfile method at the end of the class (before closing brace)**

```dart
Future<void> updateUserProfile({
  String? fullName,
  String? avatarUrl,
}) async {
  emit(state.copyWith(uiState: UiState.loading, user: state.user));

  final result = await _repository.updateUserProfile(
    fullName: fullName,
    avatarUrl: avatarUrl,
  );

  result.fold(
    onFailure: (error, _) {
      emit(state.copyWith(
        uiState: UiState.initial,
        errorMessage: error.message ?? 'Failed to update profile',
        user: state.user,
      ));
    },
    onSuccess: (updatedUser) {
      emit(state.copyWith(
        uiState: UiState.success,
        user: updatedUser,
        errorMessage: null,
      ));
      // Reset to initial after brief success state
      Future.delayed(const Duration(milliseconds: 500), () {
        if (isClosed) return;
        emit(state.copyWith(uiState: UiState.initial));
      });
    },
  );
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/features/auth/presentation/cubit/auth_cubit.dart
git commit -m "feat(auth): add updateUserProfile method to AuthCubit"
```

---

## Task 4: Create ProfilePage

**Files:**
- Create: `lib/features/auth/presentation/pages/profile_page.dart`

- [ ] **Step 1: Create the file with imports and class structure**

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
  late int _originalAvatarIndex;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    final authCubit = context.read<AuthCubit>();
    final currentUser = authCubit.state.user;
    
    _originalName = currentUser?.fullName ?? '';
    _nameController = TextEditingController(text: _originalName);
    
    // Load avatars if not already loaded
    if (authCubit.state.avatarUrls.isEmpty) {
      authCubit.loadAvatarUrls();
    } else {
      // Set the selected avatar to match the current user's avatar
      _setCurrentAvatarIndex();
    }
  }

  void _setCurrentAvatarIndex() {
    final authCubit = context.read<AuthCubit>();
    final currentUser = authCubit.state.user;
    final avatarUrls = authCubit.state.avatarUrls;
    
    if (currentUser?.avatarUrl != null && avatarUrls.isNotEmpty) {
      final index = avatarUrls.indexOf(currentUser!.avatarUrl!);
      if (index != -1) {
        _originalAvatarIndex = index;
        authCubit.selectAvatar(index);
      } else {
        _originalAvatarIndex = 0;
      }
    } else {
      _originalAvatarIndex = 0;
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
    
    return currentName != _originalName || currentAvatarIndex != _originalAvatarIndex;
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final authCubit = context.read<AuthCubit>();
      final newName = _nameController.text;
      final newAvatarUrl = authCubit.state.avatarUrls.isNotEmpty
          ? authCubit.state.avatarUrls[authCubit.state.selectedAvatarIndex]
          : null;

      authCubit.updateUserProfile(
        fullName: newName,
        avatarUrl: newAvatarUrl,
      );
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerColor,
        title: Text(
          'Logout',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().signOut();
            },
            child: Text(
              'Logout',
              style: TextStyle(color: AppColors.errorColor),
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
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 24.h,
                ),
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
          style: AppTextStyles.heading3Bold,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),

        // Email
        Text(
          user.email,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryColor,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEditForm(AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Avatar Selector
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
              selectedAvatarIndex: authState.selectedAvatarIndex,
              avatarUrls: authState.avatarUrls,
              onAvatarSelected: (avatarIndex) =>
                  context.read<AuthCubit>().selectAvatar(avatarIndex),
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
          onPressed: _checkIfChanged() ? _handleSave : null,
          isLoading: state.isLoading,
        ),
        SizedBox(height: 32.h),

        // Logout Button
        OutlinedButton(
          onPressed: state.isLoading ? null : _handleLogout,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: AppColors.errorColor,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 16.h),
          ),
          child: Text(
            'LOGOUT',
            style: TextStyle(
              color: AppColors.errorColor,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 2: Verify the file creates without syntax errors**

Run: `cd /home/serag/Code/Mobile/Flutter/Tasks/malaz && flutter analyze lib/features/auth/presentation/pages/profile_page.dart 2>&1 | head -30`

Expected: No critical syntax errors (warnings about unused imports are OK for now)

- [ ] **Step 3: Commit**

```bash
git add lib/features/auth/presentation/pages/profile_page.dart
git commit -m "feat(auth): create ProfilePage with edit and logout functionality"
```

---

## Task 5: Update Router to use ProfilePage

**Files:**
- Modify: `lib/core/router/app_router.dart`

- [ ] **Step 1: Add import for ProfilePage at the top**

After the existing imports, add:

```dart
import 'package:malaz/features/auth/presentation/pages/profile_page.dart';
```

- [ ] **Step 2: Find the profile route in the router**

Run: `grep -n "path: profile" lib/core/router/app_router.dart`

Expected output shows line number for profile route

- [ ] **Step 3: Replace TempScreen with ProfilePage**

Replace this line:
```dart
const NoTransitionPage(child: TempScreen(title: 'Profile')),
```

With:
```dart
const NoTransitionPage(child: ProfilePage()),
```

The complete profile branch should look like:
```dart
StatefulShellBranch(
  routes: [
    GoRoute(
      path: profile,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: ProfilePage()),
    ),
  ],
),
```

- [ ] **Step 4: Verify the router file compiles**

Run: `cd /home/serag/Code/Mobile/Flutter/Tasks/malaz && flutter analyze lib/core/router/app_router.dart 2>&1 | head -20`

Expected: No critical errors

- [ ] **Step 5: Commit**

```bash
git add lib/core/router/app_router.dart
git commit -m "feat(router): replace profile TempScreen with ProfilePage"
```

---

## Task 6: Test the Implementation

**Files:**
- Test: Profile navigation and functionality

- [ ] **Step 1: Build the app**

Run: `cd /home/serag/Code/Mobile/Flutter/Tasks/malaz && flutter pub get && flutter build apk --debug 2>&1 | tail -20`

Expected: Build succeeds with no errors

- [ ] **Step 2: Run the app on device/emulator**

Run: `cd /home/serag/Code/Mobile/Flutter/Tasks/malaz && flutter run`

Expected: App starts and is navigable

- [ ] **Step 3: Test profile page displays**

Manual steps:
1. Login with valid credentials
2. Tap the Profile icon (3rd tab) in bottom navigation
3. Verify profile page loads
4. Verify user avatar displays (120dp circle)
5. Verify user name displays
6. Verify user email displays

Expected: All three user fields display correctly

- [ ] **Step 4: Test avatar selection**

Manual steps:
1. On profile page, scroll to avatar selector section
2. Verify 3×N grid of avatars displays
3. Tap a different avatar than currently selected
4. Verify visual feedback (border/highlight) shows selection
5. Verify Save button becomes enabled

Expected: Avatar selection works, Save button enables

- [ ] **Step 5: Test name editing**

Manual steps:
1. Tap name text field
2. Change the name to something else (e.g., "New Name")
3. Verify Save button is enabled
4. Verify validation doesn't block (name length >= 3)

Expected: Name field editable, Save button enabled

- [ ] **Step 6: Test save with name only**

Manual steps:
1. Edit name to a different value
2. Don't change avatar
3. Tap Save button
4. Verify loading spinner shows in button
5. Wait for RPC call to complete
6. Verify success snackbar shows
7. Verify profile page refreshes with new name

Expected: Profile updates, snackbar shows success

- [ ] **Step 7: Test validation error (invalid name)**

Manual steps:
1. Clear name field (make empty)
2. Tap Save button
3. Verify inline error message shows under text field

Expected: Validation error displays, form not submitted

- [ ] **Step 8: Test logout confirmation dialog**

Manual steps:
1. Tap Logout button
2. Verify confirmation dialog appears with "Are you sure?" message
3. Tap Cancel
4. Verify dialog closes, still on profile page
5. Tap Logout button again
6. Tap Logout button in dialog
7. Verify user redirected to signin page

Expected: Logout flow works with confirmation

- [ ] **Step 9: Stop the test run**

Run: `flutter run` exit with `q`

---

## Task 7: Final Integration Test

**Files:**
- Integration test across login → profile → edit → logout

- [ ] **Step 1: Full user flow test**

Manual complete flow:
1. Start app (or login if necessary)
2. Navigate to profile tab
3. Edit avatar (select different one)
4. Edit name (change to valid name)
5. Tap Save
6. Verify both changes persisted (success snackbar)
7. Navigate away and back to profile tab
8. Verify changes are still there (pulled from AuthState)
9. Tap Logout
10. Confirm logout
11. Verify redirected to signin
12. Verify cannot access profile without login

Expected: Full flow works without errors

- [ ] **Step 2: Verify loading states during save**

Manual steps:
1. Edit profile (name and/or avatar)
2. Tap Save
3. Verify:
   - Save button shows loading spinner
   - Name field is disabled during request
   - Other interactive elements are disabled

Expected: Loading state properly disables form

- [ ] **Step 3: Verify error handling**

If you can trigger a network error (airplane mode, invalid server, etc.):
1. Edit profile
2. Toggle airplane mode ON
3. Tap Save
4. Verify error snackbar shows
5. Toggle airplane mode OFF
6. Tap Save again
7. Verify request succeeds

Expected: Error handling works, retry succeeds

- [ ] **Step 4: Commit final state**

```bash
git status
git log --oneline -10
```

Verify all profile-related commits are present. If any uncommitted changes:

```bash
git add .
git commit -m "test: verify profile screen implementation"
```

---

## Verification Checklist

- [ ] Profile page displays in bottom nav (3rd tab)
- [ ] Current user avatar, name, and email display correctly
- [ ] AvatarSelector widget works identically to signup
- [ ] Name field shows current user's fullName
- [ ] Name validation uses `Validators.validateDisplayName()`
- [ ] Save button disabled until changes detected
- [ ] Save button shows loading state during RPC call
- [ ] Profile updates persisted via RPC call
- [ ] User data in AuthState updates after successful save
- [ ] Success snackbar shows after profile update
- [ ] Error snackbar shows if update fails
- [ ] Logout button shows confirmation dialog
- [ ] Logout executes signOut() from AuthCubit
- [ ] Router redirects to signin after logout
- [ ] All 5 implementation commits created
