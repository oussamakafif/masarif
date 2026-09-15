# مصاريف (Masarif)

A family expense & budget tracking app for a household split across two
countries — Algiers 🇩🇿 and Saudi Arabia 🇸🇦. Built with **Flutter** on the
frontend and **Supabase (PostgreSQL + Auth + Row Level Security)** on the
backend.

Family members log household expenses locally in DZD, a parent in Saudi
Arabia sends money via SAR transfers, and everyone sees a shared,
transparent picture of where the money goes — with automatic currency
conversion tracked at the time each transaction happened.

---

## Status

This is an active work-in-progress. Here's what's real vs. still a mockup:

| Screen | Status |
|---|---|
| Onboarding | UI only |
| Login | ✅ Real Supabase auth (email + password) |
| Dashboard | ✅ Wired to real data (totals, per-member spending, recent expenses, budget ceiling) |
| Transfers | ✅ Wired to real data (in progress — last session was mid-debugging a stale-build issue, double check it's actually showing live data before trusting it) |
| Log Expense | ⚠️ UI only — the "save" button doesn't write to the database yet |
| Analytics | ⚠️ UI only — still showing mock data |

### Known gaps / TODO
- Log Expense screen needs to actually `insert` into `expenses` (this is the next big piece)
- Analytics screen needs the same real-data treatment as Dashboard/Transfers (the `v_top_products` view already exists for this)
- Log Expense's category picker is hardcoded — should pull from the real `categories` table
- No place/merchant field in the Log Expense UI yet, even though `expenses.place_note` exists in the schema for it
- No session persistence — the app always shows onboarding → login on every restart, even if already signed in
- Fingerprint/face quick-login was removed from the login screen (needs `local_auth` + secure session storage, not built yet)
- `budgets` and `savings_goals` tables exist and have RLS policies, but only the monthly budget ceiling is surfaced in the UI so far — savings goals aren't shown anywhere yet
- No invite flow — new family members are added manually via the Supabase dashboard + a SQL insert into `household_members` (see below)

---

## Tech stack

- **Flutter** (mobile UI)
- **Supabase**: PostgreSQL database, Auth, Row Level Security, auto-generated REST API via `supabase_flutter`
- No public sign-up — accounts are created manually by an admin (see setup below)

---

## Project structure

```
lib/
  main.dart                    # app entry, Supabase.initialize(), RTL wrapper, theme
  theme/app_theme.dart         # colors + ThemeData
  models/
    mock_data.dart             # shared data classes (FamilyMember, ExpenseEntry, etc.) + demo data
    category_icon_map.dart     # maps category.icon text keys → Flutter IconData/Color
  services/
    dashboard_repository.dart  # Supabase queries for the Dashboard screen
    transfers_repository.dart  # Supabase queries for the Transfers screen
  widgets/                     # shared UI pieces: top bar, bottom nav, tiles...
  screens/
    onboarding_screen.dart
    login_screen.dart          # real Supabase auth
    main_shell.dart            # bottom-nav shell (Dashboard / Transfers / Analytics)
    dashboard_screen.dart      # real data
    transfers_screen.dart      # real data
    analytics_screen.dart      # still mock data
    log_expense_screen.dart    # UI only, not wired to save yet
```

---

## Database schema

Core tables (all in the `public` schema, all with Row Level Security enabled,
scoped by `household_id`):

- **households** — one row per family (`name`, `base_currency`)
- **profiles** — extends `auth.users` (`full_name`, `avatar_url`)
- **household_members** — join table linking a `profiles.id` to a `households.id`, with a `role` (`admin` / `member`)
- **categories** — per-household expense categories (`name`, `icon` — a short text key like `'groceries'`, `color` — a hex string)
- **expenses** — `user_id`, `category_id`, `item_name`, `amount`, `currency`, `exchange_rate_to_base`, `note`, `receipt_url`, `place_note`
- **transfers** — `from_user_id`, `to_user_id`, `amount`, `currency`, `exchange_rate_to_base`, `note`
- **budgets** — spending limits, scoped to a category and/or member, `period` (`weekly`/`monthly`)
- **savings_goals** — target/current amount per goal (not yet surfaced in the UI)

Two analytics views:
- **v_member_spending** — per-member, per-month totals + % share of household spend
- **v_top_products** — most-purchased items by frequency and total cost

Access control: two helper functions, `is_household_member(household_id)`
and `is_household_admin(household_id)`, back every RLS policy — members can
read everything in their own household, only admins can insert into
`budgets`/`savings_goals`/`household_members`.

---

## Setup

### 1. Supabase project

You'll need your own Supabase project. Grab these from
**Settings → API Keys** (Publishable key) and **Settings → Data API** (Project URL):

```dart
// lib/main.dart
await Supabase.initialize(
  url: 'https://YOUR-PROJECT-REF.supabase.co',
  anonKey: 'sb_publishable_...',
);
```

Run the schema + RLS + views SQL against your project (ask for the full
migration script if you don't have it saved — it's been built up over
several sessions).

### 2. Create your first account(s)

No public sign-up — create accounts manually:

1. Supabase dashboard → Authentication → Users → Add user (repeat per family member)
2. SQL editor: `insert into households (...)` to create your household
3. SQL editor: `insert into household_members (household_id, user_id, role)` once per account, to link them in

### 3. Run the app

```
flutter pub get
flutter run
```

---

## Notes for next session

Pick up with wiring **Log Expense** to actually save — that's the write
path this whole app depends on, and everything else (Dashboard, Transfers,
Analytics) is just reading data that has to come from somewhere. Once
that's in, seed a few real expenses through the app itself instead of
manual SQL inserts, and the Analytics screen becomes the natural next
target since `v_top_products` is already built and waiting to be used.
