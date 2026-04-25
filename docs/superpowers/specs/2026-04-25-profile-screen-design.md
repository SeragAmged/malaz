# Profile Screen Implementation Specification

**Date:** 2026-04-25  
**Feature:** User Profile Screen with Edit & Logout Functionality  
**Status:** Ready for Implementation

---

## Overview

Create a user profile screen accessible from the bottom navigation bar (3rd tab) that displays the authenticated user's information and allows them to:
1. View their avatar, name, and email
2. Update their avatar using the same AvatarSelector widget from signup
3. Update their display name with validation
4. Logout with confirmation

---

## Architecture

### 1. Data Layer

#### AuthRepository (Abstract)
Add new method to the existing `AuthRepository` abstract class:

```dart
Future<Result<User, DomainError>> updateUserProfile({
  String? fullName,
  String? avatarUrl,
});
```

**Purpose:** Execute RPC call to backend to persist user profile changes.

**Parameters:**
- `fullName` - Updated user display name (optional if only avatar changed)
- `avatarUrl` - Updated avatar URL (optional if only name changed)

**Returns:** `Result<User, DomainError>` containing updated User object on success or error on failure.

### 2. Presentation Layer - State Management

#### AuthCubit (Extensions)
Add new method to existing `AuthCubit`:

```dart
Future<void> updateUserProfile({
  required String? fullName,
  required String? avatarUrl,
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

**Behavior:**
- Sets loading state
- Calls repository to update profile
- On success: updates user data in state and shows success indicator
- On failure: shows error message, preserves form data for retry
- Handles cubit disposal gracefully

#### AuthState (No Changes Needed)
Existing fields are sufficient:
- `user` - Contains email, fullName, avatarUrl, id, createdAt
- `avatarUrls` - List of available avatar URLs
- `selectedAvatarIndex` - Currently selected avatar
- `isLoading` - For button state
- `errorMessage` - For error display

### 3. Presentation Layer - UI

#### ProfilePage (New StatefulWidget)

**Responsibilities:**
- Display current user information (avatar, name, email)
- Manage local state for name editing and avatar selection
- Handle form validation and submission
- Handle logout confirmation and action

**Structure:**

```
Scaffold(
  ├── SafeArea
  │   └── SingleChildScrollView
  │       ├── Profile Display Section
  │       │   ├── Large Avatar (120dp circular)
  │       │   ├── Display Name
  │       │   └── Email
  │       ├── Edit Form Section
  │       │   ├── AvatarSelector (reused from signup)
  │       │   ├── Name TextField with validation
  │       │   ├── Save Button
  │       │   └── Logout Button
```

**State Variables:**
- `_nameController: TextEditingController` - For name editing
- `_formKey: GlobalKey<FormState>` - For form validation
- `_hasChanges: bool` - Track if form has unsaved changes

**Key Methods:**

1. **`_initializeForm()`** (in initState)
   - Load avatar URLs from AuthCubit
   - Populate name controller with current user's fullName
   - Reset selectedAvatarIndex to match current user's avatar

2. **`_checkIfChanged(): bool`**
   - Compare current form state to original user data
   - Return true if name changed OR selected avatar index doesn't match original
   - Used to enable/disable Save button

3. **`_handleSave()`**
   - Validate name using `Validators.validateDisplayName()`
   - Get selected avatar URL from state
   - Call `AuthCubit.updateUserProfile()`
   - Show success snackbar on success
   - Show error snackbar on failure

4. **`_handleLogout()`**
   - Show confirmation dialog
   - On confirm: Call `AuthCubit.signOut()`
   - Router handles redirect to signin (existing AuthRefreshListenable)

---

## UI Components Details

### Avatar Display Section
- **Purpose:** Show current user avatar prominently
- **Layout:**
  - Circular CachedNetworkImage (120dp diameter)
  - User fullName below (bold, large text)
  - User email below (secondary color, smaller text)
- **Styling:** Uses existing AppColors, app_text_styles
- **Error Handling:** Placeholder icon if avatar fails to load

### AvatarSelector Widget
- **Source:** Reuse existing `AvatarSelector` from signup
- **Configuration:**
  - Pass current `avatarUrls` from AuthState
  - Pass `selectedAvatarIndex` from AuthState
  - Pass `onAvatarSelected` callback to update AuthCubit state
- **Behavior:** Grid of 3 columns showing all available avatars with selection feedback

### Display Name TextField
- **Widget:** `AppTextField` (existing reusable widget)
- **Configuration:**
  - Label: "DISPLAY NAME"
  - Controller: `_nameController`
  - Validator: `Validators.validateDisplayName`
  - Prefix icon: Icons.person_outline
  - Enabled state: Disabled during loading
- **Validation Rules:**
  - Non-empty (required)
  - Minimum 3 characters
  - Uses existing `Validators.validateDisplayName()` method

### Save Button
- **Widget:** `AppLoadingButton` (existing reusable widget)
- **Label:** "SAVE CHANGES"
- **State Logic:**
  - Enabled: `_checkIfChanged() && !state.isLoading`
  - Show loading spinner during request
- **Action:** Call `_handleSave()` which validates and submits

### Logout Button
- **Widget:** Outlined or filled button with error color
- **Label:** "LOGOUT"
- **Style:** Error color (red), full width
- **Action:** Call `_handleLogout()` which shows confirmation dialog
- **Placement:** Bottom of form with padding above

---

## User Interactions

### Avatar Selection Flow
1. User scrolls to AvatarSelector section
2. User taps an avatar in the grid
3. `onAvatarSelected` callback fires → `AuthCubit.selectAvatar(index)`
4. Visual feedback shows selection (border/highlight)
5. Save button becomes enabled (if name is also valid or unchanged)

### Name Editing Flow
1. User taps name text field
2. User edits text in controller
3. Save button enables if `_checkIfChanged()` returns true
4. User taps Save button
5. Validation runs
6. On valid input: RPC call executes, loading spinner shows
7. On success: User data updates, snackbar shows "Profile updated successfully"
8. On failure: Snackbar shows error message with retry option

### Logout Flow
1. User taps Logout button
2. Confirmation dialog appears: "Are you sure you want to logout?"
3. On Cancel: Dialog closes, user stays on profile
4. On Confirm: `AuthCubit.signOut()` called
5. Loading state shows briefly
6. Router detects unauthenticated state → redirects to signin (existing behavior)

---

## Error Handling

### Validation Errors
- **Trigger:** User taps Save with invalid name
- **Display:** Inline error message under text field (from AppTextField validator)
- **Recovery:** User fixes input and taps Save again

### Network/RPC Errors
- **Trigger:** RPC call fails (network, server error, etc.)
- **Display:** Snackbar with error message
- **State:** Form state preserved, user can retry
- **Recovery:** User can tap Save again to retry

### Avatar Load Failures
- **Trigger:** Cached network image fails to load
- **Display:** Person icon placeholder (existing AvatarSelector behavior)
- **Impact:** Doesn't block profile display or editing

### Logout Errors
- **Trigger:** Sign out RPC fails
- **Display:** Snackbar with error message
- **State:** User remains on profile screen
- **Recovery:** User can dismiss error and retry logout

---

## Loading States

1. **Initial Load:** Page loads with current user data from AuthState (always available)
2. **Avatar Loading:** Spinner shown while avatar images fetch (existing AvatarSelector)
3. **Save Button:** Loading spinner shown during updateUserProfile RPC call
4. **Text Fields:** Disabled during loading to prevent double-submission
5. **Logout:** Brief loading state during signOut RPC call

---

## Success Criteria

- [ ] Profile page displays in bottom nav (3rd tab)
- [ ] Current user avatar, name, and email display correctly
- [ ] AvatarSelector reuses signup widget and works identically
- [ ] Name field shows current user's fullName
- [ ] Name validation uses `Validators.validateDisplayName()`
- [ ] Save button disabled until changes detected
- [ ] Save button shows loading state during RPC call
- [ ] Profile updates persisted via RPC call to backend
- [ ] User data in AuthState updates after successful save
- [ ] Success snackbar shows after profile update
- [ ] Error snackbar shows if update fails
- [ ] Logout button shows confirmation dialog
- [ ] Logout executes signOut() from AuthCubit
- [ ] Router redirects to signin after logout

---

## Dependencies & Integration Points

**Existing Components to Reuse:**
- `AvatarSelector` widget (from signup)
- `AppTextField` widget (from signup/auth forms)
- `AppLoadingButton` widget (from signup)
- `Validators.validateDisplayName()` method
- `AuthCubit` and `AuthState` (extend with updateUserProfile)
- `AuthRepository` (extend with updateUserProfile)
- `AuthRefreshListenable` (handles redirect after logout)

**New Components to Create:**
- `ProfilePage` (StatefulWidget)
- `updateUserProfile()` method in AuthCubit
- `updateUserProfile()` method in AuthRepository (abstract + impl)

**Router Changes:**
- Replace `TempScreen(title: 'Profile')` with `ProfilePage()`

---

## Notes

- Avatar selector interaction identical to signup to maintain UX consistency
- All validation uses existing Validators class methods
- Loading states follow existing patterns (AppLoadingButton, AuthCubit.isLoading)
- Error handling follows existing snackbar pattern from signup/signin flows
- Profile data always available in AuthState (synced on login)
- RPC calls use existing Result<T, DomainError> pattern
