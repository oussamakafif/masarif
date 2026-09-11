# مصاريف (Masarif) — Flutter UI (Frontend Only)

This is the **frontend-only** implementation of the 6 screens you shared
(onboarding, login, dashboard, log-expense, transfers, analytics). Everything
runs on **hardcoded mock data** in `lib/models/mock_data.dart` — there is no
Supabase / network call anywhere in this project yet.

## Run it

```
flutter pub get
flutter run
```

`google_fonts` will fetch the "Tajawal" Arabic font at runtime the first time
you launch the app, so you'll need an internet connection on first run (or
bundle the font locally later for production/offline use).

## Structure

```
lib/
  main.dart                  # app entry, RTL wrapper, theme
  theme/app_theme.dart       # colors + ThemeData (green/gold palette)
  models/mock_data.dart      # all mock/dummy data used by the screens
  widgets/                   # shared pieces: top bar, bottom nav, tiles...
  screens/
    onboarding_screen.dart
    login_screen.dart
    main_shell.dart          # bottom-nav shell wrapping the 3 tabs below
    dashboard_screen.dart
    transfers_screen.dart
    analytics_screen.dart
    log_expense_screen.dart  # opened as a full-screen modal from the "+" button
```

## Navigation flow

Onboarding → Login → MainShell (Dashboard / Transfers / Analytics tabs, "+"
opens Log Expense as a modal).

## Notes for when you wire up the backend

The mock data field names were deliberately kept close to your actual Supabase
schema (`buyer_id` → `buyerName`, `item_name` → `itemName`, `amount_dzd` →
`amountDzd`, `sender_id` → `senderName`, `amount_sar` / `converted_amount_dzd`,
etc.) so swapping `MockData.*` lists for real Supabase queries later should be
a fairly direct mapping — no restructuring of the widgets needed.

Known gaps carried over from our schema discussion (not addressed in this UI
pass either): no place/merchant field on the log-expense screen, and no
budgets/savings_goals screens yet.

## Not included (on purpose, per your request)

- No Supabase client, no auth, no network calls
- No real persistence — state resets on app restart
- No flutter_localizations setup (RTL is forced via a `Directionality` wrapper
  instead, which is enough for layout but not for locale-aware date/number
  formatting)
