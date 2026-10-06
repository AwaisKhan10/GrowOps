# GrowOps Go — Flutter app

Mobile field app matching the client prototype at
[bud-guide-app.lovable.app](https://bud-guide-app.lovable.app/auth).

This is the **front end only**, using the same demo records as the prototype.
The GrowOps Go Laravel/Filament backend (`growops-go/` on port 8001) will be
wired in next via `lib/api/growops_client.dart`.

## What’s included

**Auth:** login, sign up, forgot password, demo autofill (`demo@growops.app` / `demo1234`), Google button (demo login).

**Bottom tabs:** Home, Batches, Tasks, Stock, More.

**Sidebar (Menu):** Main, Cultivation, Sales, Reports, Workspace, Settings — same items as the prototype.

**Quick actions (FAB):** Add log, New batch, Add photo, Scan QR, Harvest.

**Internal screens:** batch detail (stage timeline, journal, mother, trace, archive), genetics (strains / seed lots / mothers), grow areas, harvest weights, drying checks, curing, packaging SKU generator, store orders / invoices / clients / payments, reports hub + report pages, settings (daily log fields, strains, rooms, inputs, units), workspace, profile, QR scan demo, offline/synced badge.

## Run

Install the [Flutter SDK](https://docs.flutter.dev/get-started/install/windows), then:

```powershell
cd C:\xampp\htdocs\cannabis-erp\growops-go-mobile
flutter create . --project-name growops_go --platforms android,ios,web,windows
flutter pub get
flutter run
```

`flutter create .` only adds platform folders; it will keep the existing `lib/` screens.

Chrome/web is the fastest way to compare against the Lovable prototype.

## Demo login

- Email: `demo@growops.app`
- Password: `demo1234`
