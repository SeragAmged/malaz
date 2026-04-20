# Protected Room Join Flow

**Date:** 2026-04-20  
**Feature:** Password-protected room joining with modal password entry

## Overview

When a user clicks the "Join" button on a room card:

- If the room is **not protected** → navigate directly to the room detail page
- If the room **is protected** → show a bottom sheet modal for password entry, then join on submission

## User Flow

1. User views room card with join button
2. User taps "Join" button
3. **Decision point:** Check `room.isProtected`
   - **Not protected:** Call `RoomsCubit.joinRoom(roomId, null)` → navigate to room detail page on success
   - **Protected:** Show password bottom sheet modal
4. **If modal shown:**
   - User enters password in text field (masked input)
   - User taps "Join" button
   - Call `RoomsCubit.joinRoom(roomId, password)`
   - On success → navigate to room detail page
   - On failure → show error snackbar, stay on modal (user can retry or dismiss by tapping outside)

## Component Architecture

### 1. RoomCard (Modified)

- Replace inline navigation with `_handleJoinPress()`
- Check `room.isProtected` and decide:
  - If protected: Call `_showJoinPasswordModal()`
  - If not protected: Call `RoomsCubit.joinRoom(roomId, null)` directly

### 2. JoinRoomModal (New Widget)

A stateful bottom sheet widget matching the visual style of `CreateRoomModal`:

- **Input:** room ID (required), room name (for display)
- **UI Elements:**
  - Drag handle (consistent with CreateRoomModal)
  - Title: "Enter Password"
  - Subtitle: "This room is password protected"
  - Password text field (masked, validators.validatePassword)
  - "Join" button (loading state when joining)
- **Behavior:**
  - Listen to `RoomsCubit` state for join status
  - On success: pop modal, navigate to room detail
  - On failure: show error snackbar, remain on modal
  - Modal dismissible by tapping outside (standard bottom sheet behavior)

### 3. RoomsCubit (Enhanced)

**New method:**

```dart
Future<void> joinRoom(String roomId, String password) async {
  // Guard against concurrent joins
  emit(state.copyWith(joinStatus: UiStatus.loading));

  final result = await _repository.joinRoom(
    roomId: roomId,
    password: password,
  );

  result.fold(
    onSuccess: (_) => emit(state.copyWith(joinStatus: UiStatus.success)),
    onFailure: (error, _) => emit(
      state.copyWith(
        joinStatus: UiStatus.failure,
        joinError: error,
      ),
    ),
  );
}

void resetJoinStatus() {
  emit(state.copyWith(
    joinStatus: UiStatus.initial,
    clearJoinError: true,
  ));
}
```

### 4. RoomsState (Enhanced)

Add fields:

```dart
final UiStatus joinStatus = UiStatus.initial;
final DomainError? joinError;

bool get isJoining => joinStatus == UiStatus.loading;
bool get isJoinSuccess => joinStatus == UiStatus.success;
bool get isJoinFailure => joinStatus == UiStatus.failure;

// In copyWith():
UiStatus? joinStatus,
DomainError? joinError,
bool clearJoinError = false,
```

## Error Handling

- Invalid password → show error snackbar ("Invalid password")
- Network error → show error snackbar with error message
- Other errors → show generic snackbar ("Failed to join room")
- User can retry or dismiss modal to try again

## Styling & Consistency

- Bottom sheet background, padding, and radius match `CreateRoomModal`
- Password field uses `AppTextField` with `obscureText: true`
- "Join" button uses `AppLoadingButton` for loading state
- Error messages use app's standard `SnackBar` with error colors
- Follow existing color and text style constants

## Testing Checklist

- [ ] Protected room → shows modal on join tap
- [ ] Unprotected room → navigates directly on join tap
- [ ] Modal password entry → joins room on valid password
- [ ] Modal invalid password → shows error snackbar
- [ ] Modal network error → shows error snackbar
- [ ] Modal dismiss by outside tap → closes cleanly
- [ ] Modal UI matches CreateRoomModal style
