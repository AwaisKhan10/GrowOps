# GrowOps Go — Backend API Specification

**For:** Backend developer (Laravel recommended)  
**Consumer:** GrowOps Go Flutter app (`com.growopsgo.app`)  
**App base URL (dev):** `http://127.0.0.1:8001`  
**Auth target:** Laravel Sanctum (Bearer token)  
**Date:** 2026-09-21  
**Status:** Contract for implementation — Flutter currently uses in-memory demo data

---

## 1. Purpose

Build a REST API that powers the GrowOps Go mobile field app for cultivation operations:

- Batches / stages / daily logs / harvest  
- Rooms (grow areas), genetics (strains, mothers, seed lots)  
- Tasks, inventory / lots / traceability  
- Sales (orders, invoices, clients, payments)  
- Reports + exports (CSV/PDF hooks)  
- Workspace settings (log fields, inputs, units)  
- Auth (email/password + Google Sign-In token exchange)

This document is the **single source of truth** for Cursor/backend scaffolding. Implement endpoints, models, migrations, and seeders to match these contracts.

---

## 2. Conventions

### 2.1 Base path

```
{API_BASE}/api/v1
```

Example: `http://127.0.0.1:8001/api/v1`

### 2.2 Auth header

```
Authorization: Bearer {token}
Accept: application/json
Content-Type: application/json
```

### 2.3 Multi-tenancy

Every authenticated request is scoped to the user’s **active workspace**.

- Header (optional override): `X-Workspace-Id: {uuid}`  
- Default: user’s primary / last-selected workspace  
- All resources below (except auth) are **workspace-scoped**

### 2.4 Standard response envelope

**Success (single):**
```json
{
  "data": { }
}
```

**Success (list):**
```json
{
  "data": [ ],
  "meta": {
    "current_page": 1,
    "per_page": 20,
    "total": 100,
    "last_page": 5
  }
}
```

**Error:**
```json
{
  "message": "Human readable summary",
  "errors": {
    "field": ["Validation message"]
  },
  "code": "VALIDATION_ERROR"
}
```

| HTTP | When |
|------|------|
| 200 | OK |
| 201 | Created |
| 204 | No content (delete) |
| 401 | Unauthenticated |
| 403 | Forbidden (wrong workspace / role) |
| 404 | Not found |
| 422 | Validation failed |
| 429 | Rate limited |
| 500 | Server error |

### 2.5 IDs & timestamps

- IDs: UUID strings preferred (`"id": "550e8400-e29b-41d4-a716-446655440000"`)  
- Timestamps: ISO-8601 UTC (`"2026-09-15T14:30:00Z"`)  
- Money: decimal string with currency code (`"amount": "4200.00", "currency": "ZAR"`) — demo UI currently shows `R 4,200` / `$0.00`; backend should return numeric + currency; Flutter formats display

### 2.6 Pagination & filters

Query params (lists):

| Param | Default | Notes |
|-------|---------|-------|
| `page` | 1 | |
| `per_page` | 20 | max 100 |
| `search` | — | free text |
| `sort` | `-created_at` | prefix `-` = desc |
| `status` / `stage` / `filter` | — | resource-specific |

### 2.7 Soft delete

Prefer soft deletes on batches, clients, rooms, strains, inputs. Use `?archived=1` or `?include_archived=1` where needed.

---

## 3. Domain overview (from Flutter models)

```
Workspace
  ├── Users (members + roles)
  ├── Rooms (GrowArea)
  ├── Strains / Mothers / SeedLots
  ├── Batches → JournalEntries (logs) → Harvests → Lots → Stock
  ├── Tasks
  ├── Clients → Orders / Invoices / Payments
  ├── Settings (log fields, inputs, units, waste reasons)
  └── Reports (derived reads + export jobs)
```

### 3.1 Batch stages (canonical enum)

```
Germination | Rooting | Seedling | Veg | Flower | Harvested | Drying | Curing | Packaged
```

**Stage advance map (mobile “Move to …”):**

| Current | Next |
|---------|------|
| Seedling / Rooting | Veg |
| Veg | Flower |
| Flower | Harvested |
| Harvested | Drying |
| Drying | Curing |
| Curing | Packaged |
| Packaged | (terminal) |

### 3.2 Sales order statuses

```
Draft | Open | Confirmed | Picking | Packed | Processing | Shipped | Delivered | Cancelled
```

### 3.3 Invoice statuses

```
Draft | Sent | Paid | Cancelled
```

### 3.4 Release / compliance statuses (reports)

```
Active | Hold | Released | Completed
```

---

## 4. Authentication APIs

### 4.1 Register

`POST /api/v1/auth/register`

```json
{
  "name": "Demo Grower",
  "email": "demo@growops.app",
  "password": "password123",
  "password_confirmation": "password123",
  "workspace_name": "Demo Farm"
}
```

**201 Response:**
```json
{
  "data": {
    "token": "1|xxxxxxxx",
    "token_type": "Bearer",
    "user": {
      "id": "uuid",
      "email": "demo@growops.app",
      "name": "Demo Grower",
      "workspace": {
        "id": "uuid",
        "name": "Demo Farm",
        "role": "owner"
      }
    }
  }
}
```

### 4.2 Login

`POST /api/v1/auth/login`

```json
{
  "email": "demo@growops.app",
  "password": "password123",
  "device_name": "GrowOpsGo Android"
}
```

**200:** same shape as register (`token` + `user`).

### 4.3 Google Sign-In

`POST /api/v1/auth/google`

```json
{
  "id_token": "google-id-token-from-flutter",
  "device_name": "GrowOpsGo iOS"
}
```

**Behavior:** verify token with Google; create user if new; attach/create default workspace; return Sanctum token.

### 4.4 Forgot password

`POST /api/v1/auth/forgot-password`

```json
{ "email": "demo@growops.app" }
```

**200:** `{ "message": "Reset link sent if account exists" }`

### 4.5 Reset password

`POST /api/v1/auth/reset-password`

```json
{
  "email": "demo@growops.app",
  "token": "reset-token",
  "password": "newpass",
  "password_confirmation": "newpass"
}
```

### 4.6 Me

`GET /api/v1/auth/me`

**200:**
```json
{
  "data": {
    "id": "uuid",
    "email": "demo@growops.app",
    "name": "Demo Grower",
    "workspace": {
      "id": "uuid",
      "name": "Demo Farm",
      "role": "cultivation_operator"
    },
    "workspaces": [
      { "id": "uuid", "name": "Demo Farm", "role": "owner" }
    ]
  }
}
```

### 4.7 Logout

`POST /api/v1/auth/logout`  
Revoke current token. **204**

### 4.8 Flutter mapping

| Flutter | API |
|---------|-----|
| `User.id / email / name / workspace` | `auth/me` + login response |
| Email login / signup / Google / logout / forgot | Auth endpoints above |

---

## 5. Workspace APIs

### 5.1 List / create / switch

| Method | Path | Notes |
|--------|------|-------|
| GET | `/workspaces` | Memberships for current user |
| POST | `/workspaces` | `{ "name": "New Farm" }` |
| GET | `/workspaces/{id}` | Detail |
| PATCH | `/workspaces/{id}` | Rename |
| POST | `/workspaces/{id}/switch` | Set active workspace (session preference) |

### 5.2 Members & invites

| Method | Path |
|--------|------|
| GET | `/workspaces/{id}/members` |
| POST | `/workspaces/{id}/invites` | `{ "email": "...", "role": "grower" }` |
| GET | `/workspaces/{id}/activity` | Team activity feed (paginated journal-like events) |

**Invite response:** send email (or return invite link in demo).

**Roles (suggested):** `owner | admin | cultivation_operator | grower | viewer`

---

## 6. Cultivation — Batches

### 6.1 List batches

`GET /api/v1/batches`

Query: `search`, `stage`, `filter=active|archived|all`, `sort`

**Item shape (Flutter `GrowBatch`):**
```json
{
  "id": "uuid",
  "code": "WC-C-001",
  "strain": "Wedding Cake",
  "strain_id": "uuid",
  "stage": "Flower",
  "plants": 12,
  "area": "Tent 1",
  "room_id": "uuid",
  "day": 58,
  "progress": 0.92,
  "trace_code": "GK-WC-C-001",
  "mother_id": "uuid",
  "mother_code": "WC-M-001",
  "started_at": "2026-07-20",
  "archived": false,
  "release_status": "Active",
  "created_at": "...",
  "updated_at": "..."
}
```

`progress`: 0–1 float (UI shows `% of typical stage`).  
`day`: integer age in days (server-computed from `started_at` preferred).

### 6.2 Create batch

`POST /api/v1/batches`

```json
{
  "strain_id": "uuid",
  "room_id": "uuid",
  "plants": 12,
  "stage": "Seedling",
  "mother_id": null,
  "code": null
}
```

If `code` null → server generates (`{STRAIN_PREFIX}-C-{NNN}`).

### 6.3 Batch detail

`GET /api/v1/batches/{id}`

### 6.4 Update batch

`PATCH /api/v1/batches/{id}`  
Fields: `plants`, `room_id`, `strain_id`, `archived`, notes, etc.

### 6.5 Advance stage

`POST /api/v1/batches/{id}/advance-stage`

```json
{ "to_stage": "Flower" }
```

Or omit `to_stage` to use next-stage map. Creates a journal log automatically.

### 6.6 Harvest

`POST /api/v1/batches/{id}/harvest`

```json
{
  "wet_weight_g": 1820,
  "trim_weight_g": 410,
  "waste_weight_g": 50,
  "harvested_at": "2026-09-06"
}
```

Sets stage → `Drying` (or `Harvested` then drying — match product rule; Flutter currently jumps to Drying).

---

## 7. Cultivation — Journal / Daily logs

### 7.1 List logs

`GET /api/v1/batches/{id}/logs`  
Also: `GET /api/v1/logs?batch_id=&type=&from=&to=`

**Item (Flutter `JournalEntry`):**
```json
{
  "id": "uuid",
  "batch_id": "uuid",
  "title": "Fed",
  "subtitle": "Bloom nutrients",
  "type": "fed",
  "meta": "20L",
  "qty": "20L",
  "staff_name": null,
  "image_url": null,
  "logged_at": "2026-09-12T10:00:00Z",
  "created_at": "..."
}
```

### 7.2 Create log

`POST /api/v1/batches/{id}/logs`

```json
{
  "type": "watering",
  "title": "Watering",
  "notes": "3L per plant",
  "meta": { "volume_l": 36 },
  "image_url": null
}
```

`type` must match enabled **settings log fields** where applicable (`watering`, `temperature`, `humidity`, `ec_ph`, `pest_check`, `photo`, `notes`, `stage`, `fed`, `issue`, …).

### 7.3 Delete / update log

`PATCH /api/v1/logs/{id}`  
`DELETE /api/v1/logs/{id}`

---

## 8. Tasks

`GET /api/v1/tasks`  
Query: `done=0|1`, `search`, `batch_id`

```json
{
  "id": "uuid",
  "title": "Check irrigation Tent 1",
  "batch_id": "uuid",
  "batch_label": "WC-C-001 · Wedding Cake",
  "done": false,
  "confidence": null,
  "due_at": null,
  "created_at": "..."
}
```

`POST /api/v1/tasks`  
`PATCH /api/v1/tasks/{id}` — toggle `done`, edit title  
`DELETE /api/v1/tasks/{id}`

**CAPA rule (reports):** titles prefixed with `CAPA:` are tracked in CAPA Aging report.

---

## 9. Inventory / Stock / Lots / Trace

### 9.1 Stock list (packaged inventory)

`GET /api/v1/stock`

```json
{
  "id": "uuid",
  "strain": "Gorilla Glue",
  "size": "1g",
  "sku": "GK-GG-C-002-1G-001",
  "qty": 60,
  "harvest": "Harvest Sep 6",
  "harvest_date": "2026-09-06",
  "batch_code": "GG-C-002",
  "batch_id": "uuid",
  "lot_id": "uuid"
}
```

`GET /api/v1/stock/{id}`  
`PATCH /api/v1/stock/{id}` — adjust qty

### 9.2 Lots

`GET /api/v1/lots`

```json
{
  "id": "uuid",
  "sku": "GK-GG-C-002-3.5G-001",
  "strain": "Gorilla Glue",
  "size": "3.5g",
  "qty": 24,
  "source_batch_code": "GG-C-002",
  "source_batch_id": "uuid",
  "stage": "drying",
  "status": "available"
}
```

### 9.3 Inventory by pack size (report)

`GET /api/v1/reports/inventory/summary`

```json
{
  "data": [
    { "pack_size": "3.5g", "lots": 1, "units": 24 },
    { "pack_size": "1g", "lots": 1, "units": 60 },
    { "pack_size": "7g", "lots": 1, "units": 8 }
  ]
}
```

### 9.4 Inventory movements

`GET /api/v1/inventory/movements?range=30d`

```json
{
  "id": "uuid",
  "date": "2026-09-09",
  "type": "stage",
  "batch_code": "BD-S-007",
  "detail": "Batch created"
}
```

### 9.5 Trace by SKU / code

`GET /api/v1/trace/{code}`

```json
{
  "code": "GK-GG-C-002-3.5G-001",
  "label": "Gorilla Glue · 3.5g · 24 units",
  "backward": {
    "batch": "GG-C-002",
    "mother": "GG-M-001",
    "harvest": "2026-09-06"
  },
  "forward": {
    "sales": [],
    "status": "not_sold"
  }
}
```

Used by Stock detail “View package QR / trace” and Lot Traceability screen.

---

## 10. Rooms (Grow areas)

`GET /api/v1/rooms`  
`POST /api/v1/rooms`  
`PATCH /api/v1/rooms/{id}`  
`DELETE /api/v1/rooms/{id}`

```json
{
  "id": "uuid",
  "name": "Mother Room",
  "kind": "Mother",
  "capacity": "12 plant capacity",
  "capacity_plants": 12,
  "enabled": true,
  "stats": {
    "batches": 2,
    "plants": 16,
    "stages": ["FLOWER", "VEG"]
  }
}
```

Kinds used in UI: `Mother | Clone | Veg | Flower | Dry | Packaging | Custom`

---

## 11. Genetics

### 11.1 Strains

`GET/POST /api/v1/strains`  
`PATCH/DELETE /api/v1/strains/{id}`

```json
{
  "id": "uuid",
  "name": "Wedding Cake",
  "type": "Hybrid",
  "flower_days": 63,
  "flower_days_label": "63d flower",
  "enabled": true
}
```

### 11.2 Mothers

`GET/POST /api/v1/mothers`  
`GET /api/v1/mothers/{id}`

```json
{
  "id": "uuid",
  "code": "WC-M-001",
  "strain": "Wedding Cake",
  "strain_id": "uuid",
  "status": "active"
}
```

### 11.3 Seed lots

`GET/POST /api/v1/seed-lots`  
`PATCH /api/v1/seed-lots/{id}`

```json
{
  "id": "uuid",
  "name": "PH-SEED-02",
  "strain": "Purple Haze",
  "qty": 30
}
```

---

## 12. Sales

### 12.1 Clients / Stores

`GET/POST /api/v1/clients`  
`GET/PATCH/DELETE /api/v1/clients/{id}`

```json
{
  "id": "uuid",
  "name": "Green Leaf Lounge",
  "license": "LIC-8891",
  "email": "alex@greenleaf.example",
  "invoice_count": 0
}
```

### 12.2 Store orders

`GET /api/v1/orders?status=Open`  
`POST /api/v1/orders`  
`GET/PATCH /api/v1/orders/{id}`

```json
{
  "id": "uuid",
  "client_id": "uuid",
  "client_name": "Green Leaf Lounge",
  "status": "Draft",
  "total": "4200.00",
  "currency": "ZAR",
  "ordered_at": "2026-09-12",
  "notes": null,
  "line_items": []
}
```

### 12.3 Invoices

`GET /api/v1/invoices?status=All`  
`POST /api/v1/invoices`  
`GET/PATCH /api/v1/invoices/{id}`

```json
{
  "id": "uuid",
  "number": "INV-1042",
  "client_id": "uuid",
  "client_name": "Green Leaf Lounge",
  "amount": "4200.00",
  "currency": "ZAR",
  "status": "Sent",
  "line_items": [
    { "description": "Gorilla Glue 3.5g", "qty": 12, "unit_price": "50.00" }
  ]
}
```

### 12.4 Payments

`GET /api/v1/payments`  
`POST /api/v1/payments`

```json
{
  "id": "uuid",
  "client_id": "uuid",
  "client_name": "Green Leaf Lounge",
  "amount": "4200.00",
  "currency": "ZAR",
  "method": "EFT",
  "paid_at": "2026-09-10",
  "invoice_id": "uuid"
}
```

---

## 13. Settings / Configure

### 13.1 Daily log fields

`GET /api/v1/settings/log-fields`  
`PUT /api/v1/settings/log-fields` — reorder + enable flags  
`POST /api/v1/settings/log-fields` — add custom field

```json
{
  "id": "uuid",
  "name": "Watering",
  "type": "Number",
  "unit": "L",
  "emoji": "💧",
  "enabled": true,
  "sort_order": 0
}
```

### 13.2 Inputs (nutrients)

`GET/POST/PATCH /api/v1/settings/inputs`

```json
{
  "id": "uuid",
  "name": "CalMag",
  "unit": "ml",
  "enabled": true
}
```

### 13.3 Units & measurement

`GET /api/v1/settings/units`  
`PUT /api/v1/settings/units`

```json
{
  "weight": "g",
  "volume": "L",
  "temperature": "°C",
  "nutrient": "EC",
  "plant_count_label": "plants",
  "waste_reasons": ["Mould", "Pest damage", "Over-dry", "Contamination", "Other"]
}
```

### 13.4 Preferences

`GET/PUT /api/v1/settings/preferences`

```json
{
  "theme": "light",
  "locale": "en"
}
```

---

## 14. Reports (read APIs + export)

All report GETs support: `range=7d|30d|90d|year|all` where applicable.  
Export: `GET .../export?format=csv|pdf` → file download **or** `{ "job_id": "..." }` for async.

| Mobile screen | Method | Path |
|---------------|--------|------|
| Active Batches | GET | `/reports/cultivation/active-batches` |
| Batch History | GET | `/reports/cultivation/batch-history?batch_id=` |
| Environmental Monitoring | GET | `/reports/cultivation/environment` |
| Production | GET | `/reports/cultivation/production` |
| Yield | GET | `/reports/cultivation/yield` |
| Input Usage | GET | `/reports/cultivation/input-usage` |
| Inventory | GET | `/reports/inventory/summary` |
| Lot Inventory | GET | `/reports/inventory/lots` |
| Inventory Movement | GET | `/reports/inventory/movements` |
| eBR | GET | `/reports/quality/ebr?batch_id=` |
| Release Status | GET | `/reports/quality/release-status` |
| CAPA Aging | GET | `/reports/quality/capa` |
| Track & Trace Audit | GET | `/reports/trace/audit` |
| Tracking & Trace | GET | `/reports/trace/tracking` |
| Batch Genealogy | GET | `/reports/trace/genealogy` |
| Lot Traceability | GET | `/reports/trace/lot?sku=` |
| Waste | GET | `/reports/waste` |
| Production Dashboard | GET | `/reports/dashboards/production` |
| Compliance Dashboard | GET | `/reports/dashboards/compliance` |

### 14.1 Example — Release Status

```json
{
  "summary": { "active": 3, "hold": 1, "released": 0, "completed": 0 },
  "rows": [
    {
      "batch": "WC-C-001",
      "strain": "Wedding Cake",
      "stage": "flower",
      "status": "Active",
      "started": "2026-07-20"
    }
  ]
}
```

### 14.2 Example — eBR

```json
{
  "batch": {
    "code": "WC-C-001",
    "strain": "Wedding Cake",
    "started": "2026-07-20",
    "stage": "flower",
    "plants": 12,
    "mother_code": "WC-M-001"
  },
  "logs": [ ],
  "harvests": [ ],
  "packaging": [ ]
}
```

### 14.3 Audit pack sign-off

`POST /api/v1/reports/trace/audit/sign`

```json
{
  "range": "all",
  "name": "Sam Taylor",
  "role": "Head Grower"
}
```

Locks declaration for the period; PDF export includes declaration.

---

## 15. Home / Dashboard aggregates

`GET /api/v1/dashboard/home`

```json
{
  "focus_batch": { },
  "alerts": [
    { "type": "warning", "title": "...", "body": "..." }
  ],
  "today_tasks": [ ],
  "recent_activity": [ ]
}
```

Reduces mobile round-trips for Home tab.

---

## 16. Suggested database tables (Laravel)

| Table | Notes |
|-------|-------|
| `users` | Sanctum |
| `workspaces` | |
| `workspace_user` | role pivot |
| `workspace_invites` | |
| `rooms` | grow areas |
| `strains` | |
| `mothers` | |
| `seed_lots` | |
| `batches` | stage, plants, room_id, strain_id, mother_id, started_at, archived |
| `batch_logs` | journal |
| `harvests` | wet/trim/waste |
| `lots` | sku, size, qty, batch_id, status |
| `stock_items` | denormalized or view over lots |
| `inventory_movements` | |
| `tasks` | |
| `clients` | |
| `orders` + `order_items` | |
| `invoices` + `invoice_items` | |
| `payments` | |
| `log_fields` | settings |
| `inputs` | settings |
| `workspace_settings` | units JSON + waste_reasons JSON |
| `audit_signoffs` | |
| `personal_access_tokens` | Sanctum |

---

## 17. Implementation phases (for Cursor backend)

Build in this order so Flutter can wire incrementally:

| Phase | Deliverable | Flutter screens unblocked |
|-------|-------------|---------------------------|
| **P0** | Auth + workspaces + `/auth/me` | Login, signup, Google, logout, profile |
| **P1** | Rooms, strains, batches CRUD + advance-stage + logs | Home, Batches, Log, New batch |
| **P2** | Harvest, lots, stock, trace | Stock, harvest/drying/packaging flows |
| **P3** | Tasks | Tasks tab |
| **P4** | Sales (clients, orders, invoices, payments) | Sales hub |
| **P5** | Settings APIs | Configure screens |
| **P6** | Reports + CSV/PDF export | Reports hub + detail pages |
| **P7** | Invites + activity + dashboard aggregate | Workspace / More polish |

---

## 18. Seed data (match Flutter demo)

Provide an Artisan seeder `DemoFarmSeeder` with:

- Workspace: **Demo Farm**  
- User: `demo@growops.app` / `password`  
- Active batches:  
  - `BD-S-007` Blue Dream · Seedling · 4 plants · Tent 1 · Day 7 · progress 0.50  
  - `OG-S-004` OG Kush · Veg · 8 · Tunnel A · Day 28 · progress 1.0  
  - `WC-C-001` Wedding Cake · Flower · 12 · Tent 1 · Day 58 · progress 0.92  
  - `GG-C-002` Gorilla Glue · Drying · 6 · Outdoor North · Day 86 · progress 0.86  
- Lots: `GK-GG-C-002-{3.5G|1G|7G}-001` with qty 24 / 60 / 8  
- Clients: Green Leaf Lounge, Harbour Wellness  
- Rooms: Mother / Clone / Veg / Flower / Dry / Packaging  
- Strains: Wedding Cake, OG Kush, Gorilla Glue, Blue Dream  

Exact numbers keep Flutter UI and backend demos aligned.

---

## 19. Security & ops checklist

- [ ] Sanctum SPA/mobile tokens with ability scopes if needed  
- [ ] Workspace isolation on every query (`where workspace_id =`)  
- [ ] Rate limit auth endpoints  
- [ ] Validate Google `id_token` aud/iss  
- [ ] File uploads for log photos (S3 / local) with signed URLs  
- [ ] CORS for local Flutter web if used  
- [ ] HTTPS in staging/production  
- [ ] OpenAPI (`/docs`) generated from routes — optional but recommended  

---

## 20. OpenAPI prompt for Cursor (backend repo)

Paste this into the backend Cursor chat:

> Implement a Laravel 11 API for GrowOps Go using Sanctum. Follow `BACKEND_API_SPEC.md` from the Flutter repo exactly. Create migrations, models, Form Requests, API Resources, controllers under `api/v1`, policies for workspace scoping, and `DemoFarmSeeder`. Start with Phase P0–P2. Return JSON envelopes as documented. Base URL port `8001`.

---

## 21. Flutter ↔ API field map (quick)

| Flutter class | Primary endpoints |
|---------------|-------------------|
| `User` | `/auth/*` |
| `GrowBatch` | `/batches` |
| `JournalEntry` | `/batches/{id}/logs`, `/logs` |
| `GrowTask` | `/tasks` |
| `StockItem` | `/stock` |
| `GrowArea` | `/rooms` |
| `MotherPlant` | `/mothers` |
| `SeedLot` | `/seed-lots` |
| `StoreOrder` | `/orders` |
| `Invoice` | `/invoices` |
| `ClientRecord` | `/clients` |
| `Payment` | `/payments` |
| `LogField` | `/settings/log-fields` |
| `InputItem` | `/settings/inputs` |
| `StrainItem` | `/strains` |
| Units / waste | `/settings/units` |

---

## 22. Contact notes for backend

- Mobile package / Firebase project already configured as **GrowOpsGo** (`com.growopsgo.app`).  
- UI prototype is largely complete; **blocking work is API + Flutter repository wiring**.  
- Prefer **stable contracts** early; additive fields are OK, renaming breaks the app.  
- Questions: stage machine after harvest, currency default (ZAR vs USD), and photo upload storage.

---

**Document owner:** GrowOps Go Flutter team  
**File:** `BACKEND_API_SPEC.md` (share this file with the backend developer / Cursor backend project)
