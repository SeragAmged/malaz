# Create Room Modals — Design Spec

**Date:** 2026-04-15
**Status:** Approved

---

## Overview

Two bottom sheet modals for the Rooms feature:

1. **Create Room Modal** — opened by the FAB (+) on `RoomsPage`. Lets the user name a room, select/add a type, pick a color, toggle privacy, and optionally set a password.
2. **Add Type Modal** — opened from within the Create Room Modal when the user taps "+ Custom". Lets the user define a new room type that is added to the type list in the parent modal.

---

## Approach

`showModalBottomSheet` with one self-contained `StatefulWidget` per modal. Stacking bottom sheets is the standard Flutter pattern for this sub-form flow. Each modal manages its own local state. The "Add Type" modal returns its result via `Navigator.pop(context, value)`.

---

## Files

### New
- `lib/features/rooms/presentation/widgets/create_room_modal.dart`
- `lib/features/rooms/presentation/widgets/add_type_modal.dart`

### Modified
- `lib/features/rooms/presentation/pages/rooms_page.dart` — wire FAB `onPressed` to `showModalBottomSheet(CreateRoomModal)`
- `lib/features/rooms/presentation/cubit/rooms_cubit.dart` — add `createRoom(...)` stub method
- `lib/features/rooms/presentation/cubit/rooms_state.dart` — add `createStatus` + `createErrorMessage` fields

---

## Create Room Modal

### Visual style
- Dark bottom sheet, `backgroundColor: AppColors.surfaceContainerColor`
- `borderRadius` top corners: `32.r`
- Drag handle at top center
- Title: "Create Room" (`AppTextStyles.headlineSmall`)
- Subtitle: "Set up your focus space" (`AppTextStyles.bodySmall`, `textTertiaryColor`)

### Local state
| Field | Type | Default |
|---|---|---|
| `_nameController` | `TextEditingController` | — |
| `_types` | `List<String>` | `['Study', 'Coding', 'Gym']` |
| `_selectedType` | `String?` | `null` |
| `_selectedColor` | `String` | `'#4A90D9'` |
| `_isPrivate` | `bool` | `false` |
| `_passwordController` | `TextEditingController` | — |

### Fixed color list (hex)
`#4A90D9`, `#2ECC71`, `#9B59B6`, `#E67E22`, `#E74C3C`, `#66D9CC`

### Sections
1. **Room Name** — label + `TextFormField` (hint: "e.g. Deep Work")
2. **Type** — label + horizontal wrap of chip buttons. Each chip is a `FilterChip`-style widget showing the type name + an emoji. The "+ Custom" chip opens the Add Type Modal.
3. **Room Color** — label + row of 6 color circle buttons (40×40, filled, selected state has a white ring/border)
4. **Private Room** — label + `Switch` (teal when on). Subtitle: "Only invited members can join"
5. **Password** — shown only when `_isPrivate == true`. Label + `TextFormField` with obscure toggle (same pattern as `AuthTextField`)
6. **CREATE ROOM button** — full-width teal pill, `AppColors.primaryColor` bg, "CREATE ROOM" label in `AppColors.onPrimaryColor`

### Submit flow
1. Validate: name non-empty; if private, password non-empty
2. Call `context.read<RoomsCubit>().createRoom(...)`
3. Listen via `BlocListener` on `createStatus`:
   - `creating` → disable button, show spinner inside button
   - `createSuccess` → `Navigator.pop(context)`
   - `createFailure` → show `SnackBar` with `createErrorMessage`, re-enable form

### Add Type sub-flow
- Tapping "+ Custom" calls `showModalBottomSheet` for `AddTypeModal`
- Awaits result (`String?`)
- If non-null and non-empty: appends to `_types`, sets `_selectedType` to new value

---

## Add Type Modal

### Visual style
Same dark bottom sheet style as Create Room Modal.

### Local state
| Field | Type |
|---|---|
| `_typeNameController` | `TextEditingController` |

### Sections
1. Title: "Add Type", subtitle: "Set up your focus space"
2. **Type Name** — label + `TextFormField` (hint: "e.g. Drawing 🎨")
3. **CREATE ROOM button** — same full-width teal pill (label reuses same style per design)

### Submit flow
1. Validate: type name non-empty
2. `Navigator.pop(context, _typeNameController.text.trim())`

---

## Cubit / State Changes

### `RoomsState` additions
```dart
enum CreateRoomStatus { idle, creating, createSuccess, createFailure }

// added fields:
final CreateRoomStatus createStatus;   // default: idle
final String? createErrorMessage;      // default: null
```

### `RoomsCubit.createRoom` signature
```dart
Future<void> createRoom({
  required String name,
  required String type,
  required String color,
  required bool isPrivate,
  String? password,
})
```

**Behavior:**
1. Emit `createStatus: CreateRoomStatus.creating`
2. Call repository (TODO: not yet implemented — emit failure with "Not implemented" message as placeholder)
3. On success → emit `createStatus: CreateRoomStatus.createSuccess`
4. On failure → emit `createStatus: CreateRoomStatus.createFailure, createErrorMessage: <message>`

After success/failure the modal handles navigation; the cubit resets `createStatus` to `idle` when `createRoom` is called again (at the top of the method).

---

## Out of Scope
- Actual API/repository implementation for room creation
- Form field validation beyond non-empty checks
- Image/background upload for the room
