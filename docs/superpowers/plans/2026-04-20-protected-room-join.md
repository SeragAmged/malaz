# Protected Room Join Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Enable password-protected room joining with a modal password entry flow for protected rooms and direct join for public rooms.

**Architecture:** Single join entry point in RoomCard checks `isProtected` to decide between direct join (null password) or modal flow. New JoinRoomModal widget collects password and calls Cubit. Cubit delegates to existing repository.joinRoom() method and emits state changes.

**Tech Stack:** Flutter, BLoC (Cubit), go_router, flutter_screenutil

---

### Task 1: Enhance RoomsState with join tracking

**Files:**
- Modify: `lib/features/rooms/presentation/cubit/rooms_state.dart`

- [ ] **Step 1: Add join status and error fields to RoomsState**

Add these fields after `leaveRoomError`:

```dart
final UiStatus joinStatus = UiStatus.initial;
final DomainError? joinError;
```

- [ ] **Step 2: Add join status getter methods**

Add these after `isLeaveFailure`:

```dart
bool get isJoining => joinStatus == UiStatus.loading;
bool get isJoinSuccess => joinStatus == UiStatus.success;
bool get isJoinFailure => joinStatus == UiStatus.failure;
```

- [ ] **Step 3: Update copyWith() method**

In `copyWith()`, add these parameters:

```dart
UiStatus? joinStatus,
DomainError? joinError,
bool clearJoinError = false,
```

Then update the return statement to include:

```dart
joinStatus: joinStatus ?? this.joinStatus,
joinError: clearJoinError ? null : (joinError ?? this.joinError),
```

- [ ] **Step 4: Commit**

```bash
git add lib/features/rooms/presentation/cubit/rooms_state.dart
git commit -m "feat(rooms): add join status tracking to RoomsState"
```

---

### Task 2: Add joinRoom() method to RoomsCubit

**Files:**
- Modify: `lib/features/rooms/presentation/cubit/rooms_cubit.dart`

- [ ] **Step 1: Add joinRoom() method**

Add after `leaveRoom()` method:

```dart
Future<void> joinRoom(String roomId, String? password) async {
  if (state.isJoining) return;
  emit(state.copyWith(joinStatus: UiStatus.loading));
  
  final result = await _repository.joinRoom(
    roomId: roomId,
    password: password,
  );
  
  result.fold(
    onSuccess: (_) => emit(state.copyWith(joinStatus: UiStatus.success)),
    onFailure: (error, _) => emit(
      state.copyWith(joinStatus: UiStatus.failure, joinError: error),
    ),
  );
}
```

- [ ] **Step 2: Add resetJoinStatus() method**

Add after `resetStatuses()`:

```dart
void resetJoinStatus() {
  emit(
    state.copyWith(
      joinStatus: UiStatus.initial,
      clearJoinError: true,
    ),
  );
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/features/rooms/presentation/cubit/rooms_cubit.dart
git commit -m "feat(rooms): add joinRoom() method to RoomsCubit"
```

---

### Task 3: Create JoinRoomModal widget

**Files:**
- Create: `lib/features/rooms/presentation/widgets/join_room_modal.dart`

- [ ] **Step 1: Create the widget file**

Create `lib/features/rooms/presentation/widgets/join_room_modal.dart` with the following content:

```dart
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
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/rooms/presentation/widgets/join_room_modal.dart
git commit -m "feat(rooms): create JoinRoomModal for password entry"
```

---

### Task 4: Modify RoomCard to handle join logic

**Files:**
- Modify: `lib/features/rooms/presentation/widgets/room_card.dart`

- [ ] **Step 1: Add import for JoinRoomModal**

Add at top of imports:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malaz/features/rooms/presentation/widgets/join_room_modal.dart';
import 'package:malaz/features/rooms/presentation/cubit/rooms_cubit.dart';
```

- [ ] **Step 2: Convert RoomCard to StatefulWidget**

Replace `class RoomCard extends StatelessWidget` with:

```dart
class RoomCard extends StatefulWidget {
  const RoomCard({super.key, required this.room});

  final Room room;

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
```

And at the end of the class, add the closing brace for the state class.

- [ ] **Step 3: Move all existing logic into _RoomCardState**

Move the getters (`_isLive`, `_accentColor`, `getContrastColor`) and the entire `build()` method into `_RoomCardState`.

- [ ] **Step 4: Add _handleJoinPress() method**

Add before `build()`:

```dart
void _handleJoinPress() {
  if (widget.room.isProtected) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<RoomsCubit>(),
        child: JoinRoomModal(
          roomId: widget.room.id,
          roomName: widget.room.name,
        ),
      ),
    );
  } else {
    context.read<RoomsCubit>().joinRoom(widget.room.id, null);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.go('${AppRouter.rooms}/${widget.room.id}');
      }
    });
  }
}
```

- [ ] **Step 5: Replace the onTap in InkWell**

Change the InkWell's `onTap` from:

```dart
onTap: () => context.go('${AppRouter.rooms}/${room.id}'),
```

to:

```dart
onTap: _handleJoinPress,
```

Also update references from `room.` to `widget.room.` in the build method where needed (color parsing, session check, member count, name, avatars, isProtected).

- [ ] **Step 6: Commit**

```bash
git add lib/features/rooms/presentation/widgets/room_card.dart
git commit -m "feat(rooms): add join flow with protected room password modal"
```

---
