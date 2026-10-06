# GrowOps Go — Architecture Guide

This document describes the target architecture for GrowOps Go after the BLoC + Clean Architecture migration.

## Current Status

| Phase | Status |
|-------|--------|
| Phase 1 — Audit | ✅ Complete (`PROJECT_ARCHITECTURE_AUDIT.md`) |
| Phase 2 — Foundation | ✅ Complete |
| Phase 3 — Feature migration | 🔄 In progress (Auth ✅) |

During migration, **legacy `AppState` remains active** for unmigrated features. New code must not add dependencies on legacy patterns.

---

## Folder Structure

```
lib/
├── main.dart                 # Entry point, DI bootstrap
├── app.dart                  # MaterialApp, theme, localization
├── app_shell.dart            # Legacy shell (routing via AppState)
├── app_state.dart            # Legacy global state (to be removed)
├── core/
│   ├── config/               # App-wide configuration
│   ├── constants/            # Shared constants
│   ├── di/                   # get_it service locator
│   ├── errors/               # Failures & exceptions
│   ├── extensions/           # Context/helpers
│   ├── network/              # API client
│   ├── routing/              # Route constants & GoRouter (Phase 3)
│   ├── theme/                # Design system
│   └── widgets/              # Shared UI components
├── features/                 # Feature modules (Phase 3+)
│   └── auth/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── l10n/                     # Localization ARB files
└── screens/                  # Legacy screens (migrate incrementally)
```

---

## Data Flow (Target)

```
UI (Page/Widget)
    ↓ events
BLoC / Cubit
    ↓
UseCase (optional, when business logic warrants it)
    ↓
Repository (interface)
    ↓
DataSource (remote / local / demo)
```

**Rules:**
- Widgets describe UI only — no API calls, no business logic in `build()`
- BLoCs emit typed states (`Initial`, `Loading`, `Success`, `Failure`, `Empty`)
- BLoCs emit `Failure` types — not localized strings
- UI maps failures to messages via `failure.toLocalizedMessage(context)`

---

## State Management

| Use | Tool |
|-----|------|
| Complex event flows | `Bloc` + `Equatable` events/states |
| Simple CRUD / toggles | `Cubit` |
| DI | `get_it` |
| Scoped rebuilds | `BlocBuilder`, `BlocSelector`, `buildWhen` |

Do **not** wrap `MaterialApp` in a `BlocBuilder`.

---

## Design System

All tokens live in `lib/core/theme/`:

| File | Purpose |
|------|---------|
| `app_colors.dart` | Color tokens (`AppColors`, legacy alias `GoColors`) |
| `app_spacing.dart` | Padding/gap scale |
| `app_radius.dart` | Border radius values |
| `app_text_styles.dart` | Typography tokens |
| `app_shadows.dart` | Reusable shadows |
| `app_theme.dart` | Light + dark `ThemeData` |

**Change once → updates everywhere.** Do not hardcode `Color(0x...)` in UI code.

---

## Localization

- ARB files: `lib/l10n/app_en.arb`
- Generated: `lib/l10n/app_localizations.dart` (via `flutter gen-l10n`)
- Access: `AppLocalizations.of(context).loginTitle`
- Migrate strings incrementally per feature

---

## Dependency Injection

Register services in `lib/core/di/injection.dart`:

```dart
await configureDependencies(); // called in main()
final state = getIt<AppState>(); // legacy, until removed
```

Add feature registrations as each module is migrated.

---

## Routing

- **Current:** `AppState.route` + `AppShell._pageFor()` (legacy)
- **Target:** `go_router` via `lib/core/routing/app_router.dart`
- Route constants: `lib/core/routing/app_routes.dart`

Switch to GoRouter during Phase 3 shell migration.

---

## Creating a New Feature

```
features/orders/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

1. Define entity + repository interface in `domain/`
2. Implement repository + demo/API datasource in `data/`
3. Create use cases for non-trivial business rules
4. Create BLoC/Cubit with explicit states
5. Build page widgets consuming the BLoC
6. Register dependencies in `injection.dart`
7. Add route to `app_routes.dart` / `app_router.dart`
8. Add strings to `app_en.arb`
9. Write BLoC unit tests

---

## Testing Strategy

| Layer | What to test |
|-------|-------------|
| BLoC | Initial, loading, success, failure, edge cases |
| Repository | Success, network/server/parsing failures |
| UseCase | Business rules |
| Widgets | Critical reusable components and key screens |

Run before each feature merge:

```bash
flutter analyze
flutter test
flutter build apk --debug
```

---

## Migration Rules

1. **One feature at a time** — verify after each
2. **Do not delete `AppState`** until all features are migrated
3. **No new `AppScope.of(context)` usage** in migrated code
4. Mark legacy code: `// TODO(migration): remove after [feature] migrated`
5. Preserve all existing UI behavior and demo data

---

## Auth Feature (Phase 3 — Complete)

```
features/auth/
├── data/
│   ├── datasources/demo_auth_data_source.dart
│   ├── models/user_model.dart
│   └── repositories/auth_repository_impl.dart
├── domain/
│   ├── entities/user.dart
│   ├── repositories/auth_repository.dart
│   └── usecases/ (login, signup, google, logout, password reset)
└── presentation/
    ├── bloc/auth_bloc.dart
    ├── pages/ (login, signup, forgot password)
    └── widgets/ (AuthDemoBox, AuthLegacyListener)
```

- `AuthBloc` manages auth session state
- `AuthLegacySync` keeps `AppState.loggedIn` in sync during migration
- Logout from More screen uses `AuthBloc` (not `app.logout()` directly)

## Next Step: Phase 3 — Batches Feature

See `PROJECT_ARCHITECTURE_AUDIT.md` for the full migration order.
