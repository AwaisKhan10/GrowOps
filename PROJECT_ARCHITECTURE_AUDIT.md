# GrowOps Go — Project Architecture Audit

**Project:** `/Users/awaiskhan/Desktop/GrowOpsGo-Flutter`  
**Version:** `0.1.0+1`  
**Audit date:** September 16, 2026  
**Phase:** 1 — Read-only audit (no code changes)

---

## Executive Summary

GrowOps Go is a **front-end prototype** Flutter mobile field app matching the Lovable web prototype ([bud-guide-app.lovable.app](https://bud-guide-app.lovable.app/auth)). It implements a broad feature surface using **in-memory demo data** and **no external runtime dependencies** beyond the Flutter SDK.

| Metric | Value |
|--------|-------|
| `lib/` Dart files | 16 |
| Application LOC | ~3,700 |
| Runtime packages | `flutter` only |
| State management | Custom `ChangeNotifier` + `InheritedNotifier` |
| Backend integration | Stub only (`GrowOpsGoClient` — unused) |
| Localization | None |
| Custom assets | None |
| Test coverage | 1 smoke test |

**Verdict:** The app is a well-structured **UI prototype** with a centralized color palette and reusable widgets, but it is **not production-ready**. All domain logic, navigation, and data live in a single god object (`AppState`). Migration to BLoC + Clean Architecture should be **incremental and feature-by-feature**, preserving existing UI flows and demo behavior until the Laravel backend is wired.

---

## 1. Current Architecture

### 1.1 Pattern Overview

```
main.dart
  └── AppScope (InheritedNotifier<AppState>)
        └── AnimatedBuilder(listens to AppState)
              └── MaterialApp
                    └── AppShell (home:)
                          └── Screen widgets (read/mutate AppState)
```

| Layer | Present? | Notes |
|-------|----------|-------|
| Presentation | Yes | Screen widgets in `lib/screens/` |
| State management | Partial | Single `AppState` god object |
| Domain / use cases | No | Logic embedded in `AppState` and widgets |
| Repository | No | Direct list mutation |
| Data sources | No | Demo seed in `AppState.resetDemo()` |
| DI | No | Manual instantiation in `main.dart` |
| Routing | Custom strings | `AppState.route` + `_pageFor()` switch |

### 1.2 Bootstrap (`main.dart`)

1. `GrowOpsGoApp` creates one `AppState()` instance (constructor calls `resetDemo()`).
2. Wraps tree in `AppScope` (`InheritedNotifier<AppState>`).
3. Root `AnimatedBuilder` rebuilds entire `MaterialApp` on every `notifyListeners()`.
4. `MaterialApp(home: AppShell())` — no named routes, no `go_router`.
5. Light theme via `buildGoTheme()`; dark theme is minimal `ThemeData` seed only.

### 1.3 State Management Deep Dive

**`AppState extends ChangeNotifier`** — single global store holding:

| Category | Fields |
|----------|--------|
| Session | `loggedIn`, `email`, `growerName`, `workspace` |
| UI prefs | `lightTheme`, `offline` |
| Navigation | `route`, `history` |
| Filters | `searchBatches`, `searchStock`, `batchFilter`, `geneticsTab`, `selectedBatchId` |
| Units | `unitWeight`, `unitVolume` |
| Data | `batches`, `journal`, `tasks`, `stock`, `areas`, `mothers`, `seedLots`, `orders`, `invoices`, `clients`, `payments`, `logFields`, `strains`, `inputs` |

**Business methods (encapsulated):** `resetDemo()`, `go()`, `back()`, `login()`, `logout()`, `toggleOffline()`, `addLog()`, `advanceStage()`, `completeHarvest()`, `addBatch()`, area helpers.

**Anti-pattern:** UI directly mutates model fields and calls `app.notifyListeners()` in **~26 screen call sites** instead of going through `AppState` methods. Examples: `batch.plants++`, `t.done = true`, `app.searchBatches = v`.

**Computed getters:** `activeBatches`, `focusBatch` (hardcoded to batch `b1`), `batchById(id)`.

### 1.4 Consumption Pattern

```dart
final app = AppScope.of(context);
// Read fields, mutate models, call notifyListeners()
```

**Not used:** `provider`, `flutter_bloc`, `riverpod`, `get_it`, `go_router`.

---

## 2. Folder Structure

```
lib/
├── main.dart                 (43 lines)   Entry, MaterialApp, theme wiring
├── app_shell.dart            (218 lines)  Auth gate, bottom nav, drawer, route map, FAB
├── app_state.dart            (682 lines)  Models, demo data, AppState, AppScope
├── theme.dart                (65 lines)   GoColors palette, buildGoTheme()
├── widgets.dart              (384 lines)  Shared UI components
├── api/
│   └── growops_client.dart   (11 lines)   Placeholder API client (unimplemented)
└── screens/
    ├── auth_screens.dart         (250 lines)
    ├── home_screen.dart          (138 lines)
    ├── batch_screens.dart        (344 lines)
    ├── task_screens.dart         (81 lines)
    ├── stock_screens.dart        (105 lines)
    ├── more_screen.dart          (142 lines)
    ├── cultivation_screens.dart  (587 lines)  ← largest screen file
    ├── sales_screens.dart        (335 lines)
    ├── settings_screens.dart     (199 lines)
    └── workspace_screens.dart    (134 lines)
```

---

## 3. Features & Screens

### 3.1 Auth (unauthenticated)

| Screen | Route | Behavior |
|--------|-------|----------|
| `LoginScreen` | default | Demo autofill, fake Google login |
| `SignupScreen` | `/signup` | Demo signup → logs in |
| `ForgotPasswordScreen` | `/forgot-password` | SnackBar demo |

### 3.2 Bottom Tabs (authenticated)

| Tab | Route | Screen |
|-----|-------|--------|
| Home | `/` | Dashboard, focus batch, alerts, tasks, journal |
| Batches | `/batches` | Search, stage filters, batch cards |
| Tasks | `/tasks` | Open/completed tasks |
| Stock | `/inventory` | Inventory search |
| More | `/more` | Profile, shortcuts, theme/offline, logout |

### 3.3 Feature Domains (~45 screen widgets)

| Domain | Key routes | File |
|--------|-----------|------|
| **Cultivation** | `/genetics`, `/areas`, `/harvest`, `/drying`, `/curing`, `/packaging`, `/log`, `/scan`, `/trace/:code` | `cultivation_screens.dart` |
| **Batches** | `/batches/:id`, `/new-batch` | `batch_screens.dart` |
| **Sales** | `/sales/orders`, `/sales/invoices`, `/sales/clients`, `/sales/payments` | `sales_screens.dart` |
| **Reports** | `/reports` + 18 sub-routes (stubs) | `sales_screens.dart` |
| **Settings** | `/settings/*` | `settings_screens.dart` |
| **Workspace** | `/workspace`, `/profile`, `/workspace/invite`, `/workspace/activity` | `workspace_screens.dart` |

### 3.4 Shell Components

- `GoDrawer` — full sidebar navigation
- FAB quick actions — Add log, New batch, Add photo, Scan QR, Harvest

---

## 4. Data Models

All defined in `app_state.dart`. **Mutable classes, no `json_serializable`, no `copyWith`, no `Equatable`.**

| Model | Key fields | Mutable fields |
|-------|-----------|----------------|
| `GrowBatch` | id, code, strain, stage, plants, area, day, progress, traceCode | stage, plants, area, day, progress, archived |
| `JournalEntry` | batchId, title, subtitle, when, ago, meta, kind | — |
| `GrowTask` | id, title, batchId, batchLabel | done, confidence |
| `StockItem` | id, strain, size, sku, qty, harvest, batchCode | qty |
| `GrowArea` | id, name, kind | name, kind |
| `MotherPlant` | id, code, strain, status | — |
| `SeedLot` | id, name, strain, qty | — |
| `StoreOrder` | id, client, total, when | status |
| `Invoice` | id, number, client, amount | status |
| `ClientRecord` | id, name, license, email | — |
| `Payment` | id, client, amount, when, method | — |
| `LogField` | name | enabled |

**Domain constants:** `stages` (7 labels), `nextStageLabel(stage)` progression map.

---

## 5. Services, API & Data Sources

### 5.1 `GrowOpsGoClient` (`lib/api/growops_client.dart`)

```dart
class GrowOpsGoClient {
  GrowOpsGoClient({this.baseUrl = 'http://127.0.0.1:8001'});
  Future<void> login({required String email, required String password}) async {
    throw UnimplementedError('Connect Sanctum / Filament token auth to $baseUrl');
  }
}
```

| Capability | Status |
|------------|--------|
| Imported/used | **No** — dead code |
| HTTP client | None |
| Auth | Client-side only (`email.contains('@')`) |
| Firebase | None |
| Local storage | None |
| Offline sync | UI badge only (`offline` toggle) |

**Target backend:** Laravel/Filament `growops-go/` on port `8001` (per README).

---

## 6. Navigation

**Custom string routing** — not `Navigator.push`, not `go_router`.

| Mechanism | Implementation |
|-----------|----------------|
| Current route | `AppState.route` |
| Back stack | `AppState.history` (manual) |
| Navigate | `AppState.go(path)` |
| Back | `AppState.back()` |
| Screen resolution | `AppShell._pageFor(route)` + domain routers |

**Limitations:**
- System back button does not call `app.back()` (no `PopScope`)
- No deep linking / web URL strategy
- Auth route `/auth` on logout — not explicitly handled (falls to `LoginScreen`)
- `history` can grow unbounded
- String route typos silently fall back to `HomeScreen`

---

## 7. Theme, Design System & Styling Audit

### 7.1 What Exists

**`GoColors`** — 19 semantic tokens in `theme.dart`:
`cream`, `forest`, `forestSoft`, `mint`, `card`, `ink`, `muted`, `line`, stage chip colors.

**`buildGoTheme()`** — Material 3 light theme with custom AppBar, InputDecoration, FilledButton.

### 7.2 What's Missing

| System | Status |
|--------|--------|
| `AppSpacing` | ❌ Hardcoded `EdgeInsets` everywhere |
| `AppRadius` | ❌ 16, 20, 22, 28, Stadium scattered |
| `AppTextStyles` | ❌ ~102 inline `TextStyle()` |
| `AppShadows` | ❌ Not centralized |
| `AppAssets` | ❌ No assets declared |
| Dark theme | ⚠️ Incomplete — many hardcoded light colors break |
| Localization | ❌ All English literals inline |

### 7.3 Styling Pattern Counts (grep)

| Pattern | Approx. count |
|---------|---------------|
| `GoColors.` | ~110 |
| `Colors.` | ~107 |
| `TextStyle(` | ~102 |
| `EdgeInsets` | ~108 |
| Inline `Color(0x...)` | ~32 |
| `EdgeInsets.fromLTRB(16, 8, 16, 100)` | ~40 (screen scaffold pattern) |

### 7.4 Hardcoded Inline Colors (not in `GoColors`)

| Color | Usage |
|-------|-------|
| `0xFFF3E0D0`, `0xFFDDEBD8`, `0xFF8A5A22` | SyncedBadge |
| `0xFFE4D7C8`, `0xFF6A5038` | Curing chip |
| `0xFFDCE4F0`, `0xFF3A5278` | Packaged chip |
| `0xFFF1EEE8` | SoftButton outline |
| `0xFFF3F6F3`, `0xFFF3EFE8` | Auth demo box, input fill |
| `0xFF9AD4E6` | Batch photo placeholder |
| `0xFFC47B2B` | Home alert icon |

---

## 8. Shared / Reusable Widgets

Defined in `widgets.dart`:

| Widget | Purpose |
|--------|---------|
| `SyncedBadge` | Online/offline status pill |
| `StageChip` | Lifecycle stage badge (also misused for area kind, stock size) |
| `GoCard` | White bordered card |
| `SoftButton` | Expanded action button |
| `BatchCard` | Batch summary with progress |
| `GoHeader` | Title + back + sync + menu |
| `SectionLabel` | Uppercase section divider |
| `MenuRow` | Navigation list tile |

**Not extracted (repeated inline):** ChoiceChip selectors, search fields, journal tiles, list scaffolds.

---

## 9. Duplicated Code Patterns

### High duplication

1. **Screen scaffold:** `ListView(padding: EdgeInsets.fromLTRB(16, 8, 16, 100), ...)` — 40×
2. **ChoiceChip styling** — 10+ copies
3. **Search field + mutate + notifyListeners** — batches, stock
4. **Journal entry rendering** — home, batch detail, workspace activity
5. **Domain routers** — 4 near-identical `if (route == ...)` patterns in sales, reports, settings, workspace
6. **Direct model mutation + notifyListeners** from UI

### Medium duplication

- SnackBar demo feedback
- Empty `onPressed: () {}` stubs
- `firstWhere(..., orElse: () => list.first)` in detail screens

---

## 10. Assets

| Type | Status |
|------|--------|
| `pubspec.yaml` assets | None declared |
| `Image.asset` / bundled fonts | None |
| Icons | Material `Icons.*` only |
| Images | Colored `Container` placeholders |
| Platform icons | Android launcher, Web favicon |

---

## 11. Testing & Linting

### Tests

| File | Coverage |
|------|----------|
| `test/widget_test.dart` | Login screen smoke test only |

**Not tested:** navigation, state mutations, auth flow, business logic, widgets, API.

### Linting

- `analysis_options.yaml` — `flutter_lints` with `avoid_print: false`
- Excludes `build/`, `android/`, `web/`, `windows/`

---

## 12. Dependencies

### Current (`pubspec.yaml`)

```yaml
dependencies:
  flutter: sdk

dev_dependencies:
  flutter_test: sdk
  flutter_lints: ^4.0.0
```

### Planned additions for BLoC migration (Phase 2+)

| Package | Purpose | Priority |
|---------|---------|----------|
| `flutter_bloc` | State management | Required |
| `equatable` | Immutable state comparison | Required |
| `get_it` | Dependency injection | Required |
| `go_router` | Typed navigation + auth guards | High |
| `dio` | HTTP client (when wiring API) | High |
| `flutter_localizations` + `intl` | Localization | High |
| `shared_preferences` / `flutter_secure_storage` | Token/prefs storage | Medium |

**Do not add packages prematurely.** Add per-phase as features require them.

---

## 13. Technical Debt & Risks

### Critical

| Risk | Impact | Migration note |
|------|--------|----------------|
| God object `AppState` (682 lines) | Untestable, blocks scaling | Split by feature; do not delete until each feature migrated |
| No persistence | Data lost on restart | Introduce repository + local cache when API arrives |
| Root `AnimatedBuilder` | Full app rebuild on every state change | Replace with scoped `BlocBuilder`/`BlocSelector` |
| UI mutates models directly | Breaks when API arrives | Route all mutations through repositories/use cases |
| `TextEditingController` in `build()` | Memory leaks | Fix during feature migration |

### High

| Risk | Impact |
|------|--------|
| Fake auth | Any `@` email logs in |
| Incomplete dark theme | Hardcoded light colors |
| No system back integration | Poor Android UX |
| `focusBatch` hardcoded to `b1` | Home ignores user context |
| `StageChip` semantic misuse | Confusing when extending |

### Medium

| Risk | Impact |
|------|--------|
| Large `cultivation_screens.dart` (587 lines) | Hard to maintain |
| 18 report routes are identical stubs | Low priority for migration |
| Search rebuilds entire app | Performance on real devices |
| No error/loading states | Not production-ready |

### Low

| Risk | Impact |
|------|--------|
| No localization | Blocks i18n |
| Currency hardcoded `R 4,200` | ZAR inline |
| Dates as display strings | No `DateTime` parsing |
| `Segoe UI` not bundled | Inconsistent typography |

---

## 14. Performance Concerns

| Issue | Severity | Fix during migration |
|-------|----------|---------------------|
| Root rebuild on every `notifyListeners()` | **High** | Scoped BLoC listeners |
| Search triggers full tree rebuild | **High** | Debounced search Cubit + `BlocSelector` |
| No `ListView.builder` audit needed yet | Low | Lists are small demo data |
| Controllers created in `build()` | **Medium** | StatefulWidget + dispose |
| No pagination | Low (demo data) | Add when API connected |

---

## 15. Code That Should NOT Be Unnecessarily Rewritten

Preserve and refactor — do not redesign:

| Asset | Reason |
|-------|--------|
| `GoColors` palette | Matches prototype; good design foundation |
| `widgets.dart` components | Solid reusable UI — move to `core/widgets/`, enhance |
| Screen flows & route map | Complete prototype coverage |
| Demo data structure | Useful for fixtures, offline dev, widget tests |
| Bottom nav + drawer + FAB | Matches product spec |
| `nextStageLabel()` / stage constants | Real domain logic |
| Visual layout of screens | Client-approved prototype match |

---

## 16. Target Architecture (Feature-First + Clean + BLoC)

```
lib/
├── main.dart
├── app.dart                              # MaterialApp bootstrap
├── core/
│   ├── config/                           # Env, API base URL
│   ├── constants/                        # Stages, pagination, durations
│   ├── di/                               # get_it service locator
│   ├── errors/                           # Failure types, exceptions
│   ├── extensions/                       # Context, string helpers
│   ├── network/                          # Dio client, interceptors
│   ├── routing/                          # go_router, route guards
│   ├── theme/
│   │   ├── app_colors.dart               # From GoColors
│   │   ├── app_theme.dart                # Light + dark
│   │   ├── app_text_styles.dart
│   │   ├── app_spacing.dart
│   │   ├── app_radius.dart
│   │   └── app_shadows.dart
│   ├── utils/
│   └── widgets/                          # From widgets.dart
├── l10n/                                 # ARB files
└── features/
    ├── auth/
    │   ├── data/       (datasources, models, repositories)
    │   ├── domain/     (entities, repository contracts, usecases)
    │   └── presentation/ (bloc, pages, widgets)
    ├── home/
    ├── batches/
    ├── tasks/
    ├── inventory/
    ├── cultivation/      # genetics, areas, harvest pipeline
    ├── logging/          # quick log, scan, trace
    ├── sales/
    ├── reports/
    ├── settings/
    └── workspace/
```

**Principle:** Adapt structure to actual needs. Small features (e.g. `more`) may use Cubit-only without full use-case layer until complexity warrants it.

---

## 17. Migration Strategy

### Phase 1 — Audit ✅ (this document)

No code changes. Understand project, plan migration.

### Phase 2 — Foundation

Establish shared infrastructure before touching features:

1. Add dependencies: `flutter_bloc`, `equatable`, `get_it`, `go_router`
2. Extract `core/theme/` from `theme.dart` (colors, spacing, radius, text styles, full dark theme)
3. Extract `core/widgets/` from `widgets.dart`
4. Create `core/errors/failures.dart` (NetworkFailure, ServerFailure, etc.)
5. Create `core/di/injection.dart` skeleton
6. Create `core/routing/app_router.dart` (mirror existing route map)
7. Add `l10n/` scaffold with English ARB (migrate strings incrementally)
8. Add `ARCHITECTURE.md` developer guide

**Keep `AppState` alive** as compatibility layer during migration.

### Phase 3 — Feature Migration Order

| Order | Feature | Rationale | BLoC type |
|-------|---------|-----------|-----------|
| 1 | **Auth** | Gates all routes; first API integration point | `AuthBloc` |
| 2 | **App shell / navigation** | Replace string routing with `go_router` | `AppCubit` (theme, offline) |
| 3 | **Batches** | Core domain; highest user value | `BatchListCubit`, `BatchDetailCubit` |
| 4 | **Logging** | Primary FAB action for field operators | `QuickLogCubit` |
| 5 | **Home** | Dashboard aggregating batch/task/journal data | `HomeCubit` |
| 6 | **Inventory** | Depends on packaging flow | `InventoryCubit` |
| 7 | **Cultivation pipeline** | Harvest → drying → curing → packaging | Feature Cubits per step |
| 8 | **Tasks** | Likely API-driven | `TaskListCubit` |
| 9 | **Sales** | Secondary to cultivation | `SalesCubit` per sub-feature |
| 10 | **Settings / Workspace** | Configuration | Simple Cubits |
| 11 | **Reports** | Read-only stubs; lowest priority | `ReportsCubit` |

### Per-Feature Migration Checklist

For each feature:

- [ ] Extract entities/models from `app_state.dart`
- [ ] Create repository interface + demo implementation
- [ ] Create use cases where business logic exists
- [ ] Create BLoC/Cubit with explicit states (Initial, Loading, Success, Failure, Empty)
- [ ] Convert screen to consume BLoC (scoped rebuilds)
- [ ] Replace hardcoded colors → theme tokens
- [ ] Replace hardcoded strings → l10n
- [ ] Remove feature's direct `AppState` dependencies
- [ ] Add BLoC unit tests
- [ ] Run `flutter analyze` + existing tests + manual screen verification

### Backward Compatibility During Migration

- `AppState` remains until all features migrated
- New BLoCs read/write through repositories; demo repo wraps existing demo data initially
- Do not create new dependencies on legacy `AppScope.of(context)` in migrated code
- Mark legacy code with `// TODO(migration): remove after [feature] migrated`

### Phase 4 — Cleanup

- Remove `AppState`, `AppScope`, `app_state.dart`
- Remove dead `GrowOpsGoClient` stub → real implementation
- Full dark theme audit
- Performance audit (rebuilds, memory leaks)
- Expand test suite
- Production build verification

---

## 18. BLoC Design Guidelines (Project-Specific)

### Use Cubit when

- Simple CRUD list/detail (tasks, stock, settings toggles)
- Filter/search state (batch filters, genetics tabs)
- Theme/offline toggles

### Use Bloc when

- Auth flow (LoginSubmitted, LogoutRequested, SessionExpired)
- Multi-step forms (new batch, harvest recording)
- Event-driven flows with side effects

### State shape example (Batches)

```dart
sealed class BatchListState extends Equatable {}

final class BatchListInitial extends BatchListState { ... }
final class BatchListLoading extends BatchListState { ... }
final class BatchListLoaded extends BatchListState { ... }
final class BatchListEmpty extends BatchListState { ... }
final class BatchListFailure extends BatchListState {
  final BatchFailure failure; // NOT a UI string
}
```

### Performance rules for this project

- Never wrap `MaterialApp` in `BlocBuilder`
- Use `BlocSelector` for search/filter fields
- Debounce batch/stock search (300ms)
- Keep demo repository in-memory until API ready — no premature caching layer

---

## 19. Feature-to-Folder Mapping

| Current file | Target feature module(s) |
|-------------|-------------------------|
| `auth_screens.dart` | `features/auth/` |
| `home_screen.dart` | `features/home/` |
| `batch_screens.dart` | `features/batches/` |
| `task_screens.dart` | `features/tasks/` |
| `stock_screens.dart` | `features/inventory/` |
| `more_screen.dart` | `features/more/` (or merge into `home/`) |
| `cultivation_screens.dart` | `features/cultivation/` + `features/logging/` |
| `sales_screens.dart` | `features/sales/` + `features/reports/` |
| `settings_screens.dart` | `features/settings/` |
| `workspace_screens.dart` | `features/workspace/` |
| `app_state.dart` | Split → feature entities + demo repositories |
| `app_shell.dart` | `core/routing/` + `features/shell/` |
| `theme.dart` | `core/theme/` |
| `widgets.dart` | `core/widgets/` |
| `api/growops_client.dart` | `core/network/` |

---

## 20. Quality Gate (Final Refactor Complete)

- [ ] `flutter analyze` passes
- [ ] Tests pass (BLoC + critical widgets)
- [ ] App builds on Android/iOS
- [ ] All existing screens functional
- [ ] BLoC architecture consistent across features
- [ ] No business logic in widgets
- [ ] Repository layer organized
- [ ] DI centralized (`get_it`)
- [ ] Theme/colors/typography/spacing centralized
- [ ] Localization scaffold in place
- [ ] Light + dark theme complete
- [ ] Rebuilds optimized (no root listener)
- [ ] Error/loading/empty states consistent
- [ ] `ARCHITECTURE.md` created
- [ ] `AppState` removed
- [ ] No secrets in source

---

## 21. Recommended Next Step

**Proceed to Phase 2 — Foundation:**

1. Add core packages to `pubspec.yaml`
2. Create `core/theme/`, `core/widgets/`, `core/errors/`, `core/di/`
3. Create `ARCHITECTURE.md`
4. Migrate **Auth** as the first feature (smallest API surface, gates routing)

No feature screens should be rewritten until foundation is in place.

---

## Appendix A — Complete Route Map

```
/                           HomeScreen
/batches                    BatchesScreen
/batches/:id                BatchDetailScreen
/tasks                      TasksScreen
/inventory                  StockScreen
/inventory/:id              StockDetailScreen
/more                       MoreScreen
/log                        QuickLogScreen
/new-batch                  NewBatchScreen
/scan                       ScanScreen
/harvest                    HarvestScreen
/drying                     DryingScreen
/curing                     CuringScreen
/packaging                  PackagingScreen
/genetics                   GeneticsScreen
/areas                      AreasScreen
/areas/:id                  AreaDetailScreen
/mothers/:id                MotherDetailScreen
/trace/:code                TraceScreen
/sales/orders               OrdersScreen
/sales/orders/new           NewOrderScreen
/sales/invoices             InvoicesScreen
/sales/invoices/new         NewInvoiceScreen
/sales/invoices/:id         InvoiceDetailScreen
/sales/clients              ClientsScreen
/sales/clients/:id          ClientDetailScreen
/sales/payments             PaymentsScreen
/reports                    ReportsHubScreen
/reports/**                 ReportPageScreen (18 sub-routes)
/settings                   SettingsHomeScreen
/settings/daily-log         DailyLogFieldsScreen
/settings/strains           StrainsSettingsScreen
/settings/rooms             RoomsSettingsScreen
/settings/inputs            InputsSettingsScreen
/settings/units             UnitsSettingsScreen
/workspace                  WorkspaceScreen
/profile                    ProfileScreen
/workspace/invite           InviteScreen
/workspace/activity         ActivityScreen
/workspace/new              NewWorkspaceScreen
/signup                     SignupScreen
/forgot-password            ForgotPasswordScreen
/auth                       Logout target → LoginScreen
```

## Appendix B — Demo Data Inventory

| Collection | Demo count | Seeded in |
|------------|-----------|-----------|
| Batches | 4 | `AppState.resetDemo()` |
| Journal entries | 7 | same |
| Tasks | 4 | same |
| Stock items | 3 | same |
| Areas | 3 | same |
| Mothers | 2 | same |
| Seed lots | 2 | same |
| Orders | 2 | same |
| Invoices | 1 | same |
| Clients | 2 | same |
| Payments | 1 | same |
| Log fields | 11 | same |
| Strains | 4 | same |
| Inputs | 4 | same |

## Appendix C — Demo Credentials

- Email: `demo@growops.app`
- Password: `demo1234`

---

*Phase 1 complete. Awaiting approval to begin Phase 2 — Foundation.*
