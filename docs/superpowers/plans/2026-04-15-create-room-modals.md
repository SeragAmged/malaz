# Create Room Modals Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add two bottom-sheet modals — "Create Room" (FAB) and "Add Type" (nested from Create Room) — with full loading/success/failure state handling via the existing `RoomsCubit`.

**Architecture:** Each modal is a self-contained `StatefulWidget` shown via `showModalBottomSheet`. The "Add Type" modal stacks on top and returns its result via `Navigator.pop(context, value)`. State for the create operation lives in `RoomsState` via two new fields (`createStatus`, `createErrorMessage`); local form state lives inside each modal widget.

**Tech Stack:** Flutter, flutter_bloc, flutter_screenutil, existing `AppColors` / `AppTextStyles` / `RoomsRepository`

---

## File Map

| Action | Path | Responsibility |
|---|---|---|
| Modify | `lib/features/rooms/presentation/cubit/rooms_state.dart` | Add `CreateRoomStatus` enum + two new fields + updated `copyWith` |
| Modify | `lib/features/rooms/presentation/cubit/rooms_cubit.dart` | Add `createRoom(...)` method stub |
| Create | `lib/features/rooms/presentation/widgets/add_type_modal.dart` | "Add Type" bottom sheet |
| Create | `lib/features/rooms/presentation/widgets/create_room_modal.dart` | "Create Room" bottom sheet |
| Modify | `lib/features/rooms/presentation/pages/rooms_page.dart` | Wire FAB to show `CreateRoomModal` |

---

## Task 1: Extend RoomsState with create status fields

**Files:**
- Modify: `lib/features/rooms/presentation/cubit/rooms_state.dart`

- [ ] **Step 1: Add `CreateRoomStatus` enum and new fields to `RoomsState`**

Replace the entire file content with:

```dart
import '../../domain/entities/room.dart';

enum RoomsStatus { initial, loading, success, failure }

enum CreateRoomStatus { idle, creating, createSuccess, createFailure }

class RoomsState {
  const RoomsState({
    this.status = RoomsStatus.initial,
    this.rooms = const [],
    this.errorMessage,
    this.currentPage = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.createStatus = CreateRoomStatus.idle,
    this.createErrorMessage,
  });

  final RoomsStatus status;
  final List<Room> rooms;
  final String? errorMessage;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final CreateRoomStatus createStatus;
  final String? createErrorMessage;

  bool get isInitial => status == RoomsStatus.initial;
  bool get isLoading => status == RoomsStatus.loading;
  bool get isSuccess => status == RoomsStatus.success;
  bool get isFailure => status == RoomsStatus.failure;

  RoomsState copyWith({
    RoomsStatus? status,
    List<Room>? rooms,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    CreateRoomStatus? createStatus,
    String? createErrorMessage,
  }) {
    return RoomsState(
      status: status ?? this.status,
      rooms: rooms ?? this.rooms,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      createStatus: createStatus ?? this.createStatus,
      createErrorMessage: createErrorMessage ?? this.createErrorMessage,
    );
  }
}
```

- [ ] **Step 2: Verify the app still compiles**

```bash
flutter analyze lib/features/rooms/presentation/cubit/rooms_state.dart
```

Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add lib/features/rooms/presentation/cubit/rooms_state.dart
git commit -m "feat(rooms): add CreateRoomStatus to RoomsState"
```

---

## Task 2: Add `createRoom` stub to `RoomsCubit`

**Files:**
- Modify: `lib/features/rooms/presentation/cubit/rooms_cubit.dart`

- [ ] **Step 1: Add `createRoom` method to the cubit**

Open `lib/features/rooms/presentation/cubit/rooms_cubit.dart` and append the following method inside the `RoomsCubit` class (after `loadMoreRooms`):

```dart
Future<void> createRoom({
  required String name,
  required String type,
  required String color,
  required bool isPrivate,
  String? password,
}) async {
  // Reset to idle first so re-submissions after failure work correctly
  emit(state.copyWith(createStatus: CreateRoomStatus.idle));
  emit(state.copyWith(createStatus: CreateRoomStatus.creating));

  final result = await _repository.createRoom(
    name: name,
    type: type,
    theme: color,
    capacity: 10,
    password: password,
  );

  result.fold(
    onSuccess: (_) => emit(
      state.copyWith(createStatus: CreateRoomStatus.createSuccess),
    ),
    onFailure: (error, _) => emit(
      state.copyWith(
        createStatus: CreateRoomStatus.createFailure,
        createErrorMessage: error.message ?? 'Failed to create room.',
      ),
    ),
  );
}
```

Also add the import for `rooms_state.dart` if not already present — it is already imported via the relative import at the top of the file (`import 'rooms_state.dart';`). No new imports needed.

- [ ] **Step 2: Verify the app still compiles**

```bash
flutter analyze lib/features/rooms/presentation/cubit/rooms_cubit.dart
```

Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add lib/features/rooms/presentation/cubit/rooms_cubit.dart
git commit -m "feat(rooms): add createRoom stub to RoomsCubit"
```

---

## Task 3: Build the `AddTypeModal` widget

**Files:**
- Create: `lib/features/rooms/presentation/widgets/add_type_modal.dart`

- [ ] **Step 1: Create the file**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';

class AddTypeModal extends StatefulWidget {
  const AddTypeModal({super.key});

  @override
  State<AddTypeModal> createState() => _AddTypeModalState();
}

class _AddTypeModalState extends State<AddTypeModal> {
  final _typeNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _typeNameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _typeNameController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
        child: Form(
          key: _formKey,
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
              Text('Add Type', style: AppTextStyles.headlineSmall),
              SizedBox(height: 4.h),
              Text(
                'Set up your focus space',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiaryColor,
                ),
              ),
              SizedBox(height: 24.h),
              // Type Name label
              Text(
                'TYPE NAME',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondaryColor,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _typeNameController,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'Type name is required' : null,
                decoration: const InputDecoration(hintText: 'e.g. Drawing 🎨'),
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.onPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    'CREATE TYPE',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.onPrimaryColor,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Analyze the file**

```bash
flutter analyze lib/features/rooms/presentation/widgets/add_type_modal.dart
```

Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add lib/features/rooms/presentation/widgets/add_type_modal.dart
git commit -m "feat(rooms): add AddTypeModal bottom sheet widget"
```

---

## Task 4: Build the `CreateRoomModal` widget

**Files:**
- Create: `lib/features/rooms/presentation/widgets/create_room_modal.dart`

- [ ] **Step 1: Create the file**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/features/rooms/presentation/cubit/rooms_cubit.dart';
import 'package:malaz/features/rooms/presentation/cubit/rooms_state.dart';
import 'package:malaz/features/rooms/presentation/widgets/add_type_modal.dart';

class CreateRoomModal extends StatefulWidget {
  const CreateRoomModal({super.key});

  @override
  State<CreateRoomModal> createState() => _CreateRoomModalState();
}

class _CreateRoomModalState extends State<CreateRoomModal> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> _types = ['Study 📚', 'Coding 💻', 'Gym 💪'];
  String? _selectedType;
  String _selectedColor = '#4A90D9';
  bool _isPrivate = false;
  bool _obscurePassword = true;

  static const List<String> _colors = [
    '#4A90D9',
    '#2ECC71',
    '#9B59B6',
    '#E67E22',
    '#E74C3C',
    '#66D9CC',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Color _parseColor(String hex) {
    try {
      final cleaned = hex.replaceAll('#', '').padLeft(6, '0');
      return Color(int.parse('FF$cleaned', radix: 16));
    } catch (_) {
      return AppColors.primaryColor;
    }
  }

  Future<void> _openAddTypeModal() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTypeModal(),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _types.add(result);
        _selectedType = result;
      });
    }
  }

  void _submit(bool isCreating) {
    if (isCreating) return;
    if (!_formKey.currentState!.validate()) return;
    context.read<RoomsCubit>().createRoom(
      name: _nameController.text.trim(),
      type: _selectedType ?? _types.first,
      color: _selectedColor,
      isPrivate: _isPrivate,
      password: _isPrivate ? _passwordController.text : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomsCubit, RoomsState>(
      listener: (context, state) {
        if (state.createStatus == CreateRoomStatus.createSuccess) {
          Navigator.pop(context);
        } else if (state.createStatus == CreateRoomStatus.createFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.createErrorMessage ?? 'Failed to create room.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onErrorColor,
                ),
              ),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
      },
      child: BlocBuilder<RoomsCubit, RoomsState>(
        builder: (context, state) {
          final isCreating = state.createStatus == CreateRoomStatus.creating;
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
                      Text('Create Room', style: AppTextStyles.headlineSmall),
                      SizedBox(height: 4.h),
                      Text(
                        'Set up your focus space',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiaryColor,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Room Name
                      Text(
                        'ROOM NAME',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textSecondaryColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        enabled: !isCreating,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? 'Room name is required'
                                : null,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Deep Work',
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Type
                      Text(
                        'TYPE',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textSecondaryColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          ..._types.map((type) => _TypeChip(
                                label: type,
                                isSelected: _selectedType == type,
                                onTap: isCreating
                                    ? null
                                    : () => setState(() => _selectedType = type),
                              )),
                          _TypeChip(
                            label: '+ Custom',
                            isSelected: false,
                            onTap: isCreating ? null : _openAddTypeModal,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // Room Color
                      Text(
                        'ROOM COLOR',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textSecondaryColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: _colors.map((hex) {
                          final isSelected = _selectedColor == hex;
                          return Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: GestureDetector(
                              onTap: isCreating
                                  ? null
                                  : () =>
                                      setState(() => _selectedColor = hex),
                              child: Container(
                                width: 36.r,
                                height: 36.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _parseColor(hex),
                                  border: isSelected
                                      ? Border.all(
                                          color: Colors.white,
                                          width: 2.5,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20.h),

                      // Private Room toggle
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Private Room',
                                  style: AppTextStyles.titleSmall,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Only invited members can join',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textTertiaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isPrivate,
                            onChanged: isCreating
                                ? null
                                : (v) => setState(() => _isPrivate = v),
                            activeColor: AppColors.primaryColor,
                          ),
                        ],
                      ),

                      // Password (conditional)
                      if (_isPrivate) ...[
                        SizedBox(height: 20.h),
                        Text(
                          'PASSWORD',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.textSecondaryColor,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          enabled: !isCreating,
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? 'Password is required for private rooms'
                                  : null,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 20.r,
                                color: AppColors.textTertiaryColor,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                        ),
                      ],

                      SizedBox(height: 32.h),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: isCreating ? null : () => _submit(isCreating),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: AppColors.onPrimaryColor,
                            disabledBackgroundColor:
                                AppColors.primaryColor.withValues(alpha: 0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          child: isCreating
                              ? SizedBox(
                                  width: 22.r,
                                  height: 22.r,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColors.onPrimaryColor,
                                  ),
                                )
                              : Text(
                                  'CREATE ROOM',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.onPrimaryColor,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                        ),
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

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withValues(alpha: 0.15)
              : AppColors.inputBackgroundColor,
          borderRadius: BorderRadius.circular(999),
          border: isSelected
              ? Border.all(color: AppColors.primaryColor, width: 1.5)
              : Border.all(color: AppColors.borderColor, width: 1),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.textSecondaryColor,
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Analyze the file**

```bash
flutter analyze lib/features/rooms/presentation/widgets/create_room_modal.dart
```

Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add lib/features/rooms/presentation/widgets/create_room_modal.dart
git commit -m "feat(rooms): add CreateRoomModal bottom sheet widget"
```

---

## Task 5: Wire the FAB in `RoomsPage`

**Files:**
- Modify: `lib/features/rooms/presentation/pages/rooms_page.dart`

- [ ] **Step 1: Add the import for `CreateRoomModal` at the top of the file**

After the existing imports, add:

```dart
import 'package:malaz/features/rooms/presentation/widgets/create_room_modal.dart';
```

- [ ] **Step 2: Replace the FAB `onPressed` body**

Find this block in `rooms_page.dart`:

```dart
floatingActionButton: FloatingActionButton(
  onPressed: () {
    log("message");
  },
```

Replace with:

```dart
floatingActionButton: FloatingActionButton(
  onPressed: () {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<RoomsCubit>(),
        child: const CreateRoomModal(),
      ),
    );
  },
```

- [ ] **Step 3: Remove the unused `dart:developer` import** if `log` is no longer used anywhere else in the file. Check by scanning — if the only usage was inside `onPressed`, remove the line:

```dart
import 'dart:developer';
```

- [ ] **Step 4: Analyze**

```bash
flutter analyze lib/features/rooms/presentation/pages/rooms_page.dart
```

Expected: no errors.

- [ ] **Step 5: Run the app and manually verify**

```bash
flutter run
```

Verify:
1. Tapping the FAB opens the Create Room modal
2. Form validation works (empty name, empty password when private)
3. Tapping "+ Custom" opens the Add Type modal; submitting a name adds it as a selected chip in the parent modal
4. The CREATE ROOM button shows a spinner while `createStatus == creating`
5. On failure (repository is a stub so expect failure) a SnackBar appears with the error message
6. The modal closes on success

- [ ] **Step 6: Commit**

```bash
git add lib/features/rooms/presentation/pages/rooms_page.dart
git commit -m "feat(rooms): wire FAB to CreateRoomModal"
```
