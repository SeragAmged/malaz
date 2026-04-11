# Clean Architecture Design: Makeup App (Productivity Rooms)

**Date:** 2026-04-11  
**Project:** Makeup App - Real-time Productivity Application  
**Scope:** MVP - Room discovery, session tracking, basic leaderboard  
**Backend:** Supabase  

---

## Overview

This document describes the clean architecture for a Flutter productivity app without usecases. The architecture emphasizes:
- **Feature-first organization** — Each feature is self-contained
- **Data-Centric** — Repositories → Cubits (no services layer)
- **Result Pattern** — Type-safe error handling via Result<D, E> wrapper
- **Offline-First** — Light caching with remote-first fetch strategy
- **Light Real-Time** — Subscriptions only while user is active in room

---

## Architecture Decisions

### 1. Layer Structure: Repositories → Cubits (No Usecases)

**Why:** MVP scope doesn't require business logic isolation. Repositories handle all data orchestration (caching, fallback), Cubits handle UI state. This reduces boilerplate while maintaining clean boundaries.

**Data Flow:**
```
UI (Widget)
  ↓ calls
Cubit.fetchData()
  ↓ calls
Repository.getData()
  ↓ tries
RemoteDataSource (Supabase) → fetch fresh
  ↓ success → cache locally
  ↓ fail → fallback to LocalDataSource (Hive)
  ↓ returns Result<Data, Error>
Cubit maps to UI State
```

### 2. Error Handling: Result Pattern

**Why:** Type-safe errors without exceptions. Result<D, E extends DomainError> separates success/error paths clearly.

**Flow:**
- DataSources return `Result<Data, DomainError>`
- Repositories map errors to fallback data or propagate
- Cubits convert Results to UI states with user-friendly messages
- Switch/pattern matching prevents null reference errors

### 3. Caching Strategy: Remote-First with Fallback

**Why:** Ensures fresh data while remaining functional offline.

- **Primary:** Fetch from Supabase
- **On Success:** Cache to local storage (Hive)
- **On Failure:** Return cached data (may be stale)
- **If No Cache:** Return error

### 4. Offline Session Sync

**Why:** Users should be able to create pomodoro sessions offline and sync when connection returns.

**Implementation:**
- Sessions created offline stored locally with `isSynced: false`
- Repository detects pending sessions on connection restore
- Auto-syncs via connectivity listener
- Maintains eventual consistency

### 5. State Management: Cubit (Not BLoC)

**Why:** MVP doesn't need event-driven complexity. Cubit's function-driven approach is simpler and faster to implement.

**Pattern:**
```dart
class RoomsCubit extends Cubit<RoomsState> {
  Future<void> fetchRooms() async {
    emit(Loading());
    final result = await repository.getRooms();
    result.when(
      success: (data) => emit(Success(data)),
      error: (err) => emit(Failure(_mapError(err))),
    );
  }
}
```

### 6. Dependency Injection: Injectable + GetIt

**Why:** @injectable annotations reduce boilerplate. @module registers external dependencies (Supabase, Hive). GetIt provides service locator convenience.

---

## Directory Structure

```
lib/
├── config/
│   ├── theme/
│   │   └── app_theme.dart
│   ├── router/
│   │   └── app_router.dart
│   └── env/
│       └── env_config.dart
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── extensions/
│   │   ├── result_extensions.dart
│   │   └── string_extensions.dart
│   ├── utils/
│   │   └── formatters.dart
│   ├── errors/
│   │   └── domain_errors.dart
│   └── di/
│       ├── injectable.dart
│       ├── injectable.config.dart (generated)
│       └── injectable_module.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   └── auth_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── user_model.dart
│   │   │   │   └── auth_response_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── user.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── auth_cubit.dart
│   │       │   └── auth_state.dart
│   │       └── pages/
│   │           ├── login_page.dart
│   │           ├── register_page.dart
│   │           └── widgets/
│   ├── rooms/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── rooms_remote_datasource.dart
│   │   │   │   └── rooms_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── room_model.dart
│   │   │   ├── mappers/
│   │   │   │   └── room_mapper.dart
│   │   │   └── repositories/
│   │   │       └── rooms_repository_impl.dart
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── room.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── rooms_cubit.dart
│   │       │   └── rooms_state.dart
│   │       └── pages/
│   │           ├── rooms_list_page.dart
│   │           └── widgets/
│   ├── sessions/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── leaderboard/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

### Key Folders

- **config/** — App-level configuration (theme, routing, env)
- **core/** — Shared utilities, constants, error handling, DI setup
- **features/** — Feature modules (auth, rooms, sessions, leaderboard)
  - **data/** — Datasources, models, repositories
  - **domain/** — Pure Dart entities
  - **presentation/** — Cubits, pages, widgets

Each feature is **completely self-contained**. No shared code between features except via core/.

---

## Data Layer Patterns

### Entity (Domain)

Pure Dart classes with no external dependencies. Example:

```dart
class Room {
  final String id;
  final String name;
  final int currentUsers;
  // ...
}
```

### Model (Data)

JSON-serializable using freezed + json_serializable. Maps directly from Supabase JSON.

```dart
@freezed
class RoomModel with _$RoomModel {
  const factory RoomModel({
    required String id,
    required String name,
    @JsonKey(name: 'current_users') required int currentUsers,
    // ...
  }) = _RoomModel;

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);
}
```

### Mapper

Extension methods convert Models ↔ Entities:

```dart
extension RoomMapper on RoomModel {
  Room toDomain() => Room(id: id, name: name, ...);
}
```

### Repository

Orchestrates datasources, implements caching logic, returns Result:

```dart
@injectable
class RoomsRepository {
  final RoomsRemoteDataSource remote;
  final RoomsLocalDataSource local;

  RoomsRepository({required this.remote, required this.local});

  Future<Result<List<Room>, DomainError>> getRooms() async {
    // Remote-first fetch, fallback to cache on error
  }
}
```

---

## Presentation Layer Patterns

### Cubit States

One state class per Cubit status (Loading, Success, Failure, Initial):

```dart
abstract class RoomsState {}

class RoomsLoading extends RoomsState {}

class RoomsSuccess extends RoomsState {
  final List<Room> rooms;
  RoomsSuccess(this.rooms);
}

class RoomsFailure extends RoomsState {
  final String error;
  RoomsFailure(this.error);
}
```

### Cubit Methods

Simple functions that emit states:

```dart
class RoomsCubit extends Cubit<RoomsState> {
  final RoomsRepository repository;

  RoomsCubit(this.repository) : super(RoomsInitial());

  Future<void> fetchRooms() async {
    emit(RoomsLoading());
    final result = await repository.getRooms();
    
    result.when(
      success: (rooms) => emit(RoomsSuccess(rooms)),
      error: (error, _) => emit(RoomsFailure(_mapErrorMessage(error))),
    );
  }

  String _mapErrorMessage(DomainError error) {
    return switch (error) {
      NetworkError() => 'Network error. Check your connection.',
      _ => 'Unknown error occurred.',
    };
  }
}
```

### Real-Time Subscriptions (Light)

Subscriptions only while user is active in a room:

```dart
class SessionsCubit extends Cubit<SessionsState> {
  StreamSubscription? _sessionsSub;

  void startMonitoring(String roomId) {
    _sessionsSub = repository.watchSessions(roomId).listen((result) {
      result.when(
        success: (sessions) => emit(SessionsSuccess(sessions)),
        error: (error, _) => emit(SessionsFailure(_mapErrorMessage(error))),
      );
    });
  }

  void stopMonitoring() {
    _sessionsSub?.cancel();
  }
}
```

---

## Offline & Sync Strategy

### Session Sync Flow

1. **User creates session offline** → Saved to Hive with `isSynced: false`
2. **App detects connection** → Connectivity listener fires
3. **Repository syncs pending** → `syncPendingSessions()` uploads to Supabase
4. **Mark synced** → Update Hive flag to `isSynced: true`
5. **Cubit updates UI** → No action needed, local data already showed

### Implementation Hooks

- **Connectivity listener** in main.dart or core DI
- **Repository.syncPendingSessions()** method
- **Hive box** with pending sessions flag

---

## Dependency Injection Setup

### External Dependencies Module

```dart
@module
abstract class InjectableModule {
  @singleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @singleton
  HiveInterface get hiveInterface => Hive;

  @singleton
  Connectivity get connectivity => Connectivity();
}
```

### Feature Annotations

Each datasource, repository, and cubit is annotated:

```dart
@injectable
class RoomsRepository { ... }

@injectable
class RoomsCubit extends Cubit { ... }
```

### Build & Setup

```bash
flutter pub run build_runner build
```

Then in main.dart:

```dart
void main() async {
  // Initialize
  await Supabase.initialize(...);
  await Hive.initFlutter();
  
  // Setup DI
  configureInjectable();
  
  runApp(MyApp());
}
```

---

## Error Handling

### Domain Errors

Custom error types extending DomainError:

```dart
class NetworkError extends DomainError {}
class AuthError extends DomainError {}
class ValidationError extends DomainError {}
```

### Result Type

```dart
sealed class Result<D, E extends DomainError> {
  const Result();
}

class Success<D, E> extends Result<D, E> {
  final D data;
  Success(this.data);
}

class Error<D, E> extends Result<D, E> {
  final E error;
  Error(this.error);
}
```

### Result Extensions

Pattern matching via `when()`, `map()`, `onSuccess()`, etc.

```dart
result.when(
  success: (data) => emit(SuccessState(data)),
  error: (error, _) => emit(FailureState(_mapError(error))),
);
```

---

## Testing Strategy

### Unit Tests

Test repositories (mocking datasources) and cubits (mocking repositories):

```dart
test('RoomsRepository returns cached data on network error', () async {
  when(remote.fetchRooms()).thenThrow(NetworkError());
  when(local.getCachedRooms()).thenAnswer((_) async => mockRooms);
  
  final result = await repository.getRooms();
  
  expect(result, isA<Success>());
});
```

### Cubit Tests

Test state transitions:

```dart
blocTest<RoomsCubit, RoomsState>(
  'emits [Loading, Success] when fetchRooms succeeds',
  build: () => RoomsCubit(mockRepository),
  act: (cubit) => cubit.fetchRooms(),
  expect: () => [isA<RoomsLoading>(), isA<RoomsSuccess>()],
);
```

### Integration Tests

Real Supabase + local storage for critical user flows (login, create session, sync).

### Scope for MVP

Unit + integration tests only. No UI tests (avoid scope creep).

---

## Key Constraints & Assumptions

| Item | Assumption |
|------|-----------|
| **Authentication** | Email/password only (Supabase auth) |
| **Real-Time** | Light (subscriptions while in room only) |
| **Caching** | Moderate (rooms, profiles, sessions) |
| **Offline** | Sessions sync when connection returns |
| **Scalability** | Extendable to services layer if complexity grows (future) |

---

## Migration Path to Approach 2

If complexity grows, extract sync logic into a separate `sync/` module:

```
data/
├── datasources/
├── repositories/
└── sync/
    ├── sync_queue.dart
    └── sync_service.dart
```

No refactoring of existing code needed — just new files.

---

## Summary

This architecture provides:
✅ Feature isolation (self-contained features)  
✅ Type-safe error handling (Result pattern)  
✅ Offline capability (cache + sync)  
✅ Clean DI (Injectable + GetIt)  
✅ Easy to test (mocking at datasource/repository level)  
✅ MVP-focused (Cubit instead of BLoC, no usecases)  
✅ Future-proof (can upgrade to services layer later)  

Ready for implementation.
