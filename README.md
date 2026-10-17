# SONA CHICKEN CENTER — Supabase + GitHub Pages

This repository is the web-app source. GitHub Pages hosts the static frontend; Supabase provides authentication, PostgreSQL storage, row-level security and realtime updates.

## Setup
1. Create a Supabase project at https://supabase.com/.
2. Open the Supabase SQL Editor and run `SUPABASE_SETUP.sql`.
3. In Supabase Authentication, create the owner account. Copy its UUID and insert it into `public.shop_members` as the owner (SQL example is at the bottom of the setup file).
4. In Supabase Project Settings → API, copy the Project URL and publishable/anon key. Never put a service-role key in this browser app.
5. Open the app on GitHub Pages, enter the URL/key/shop ID, create/sign in to the account, and authorize the user in `shop_members`.
6. In GitHub, go to Settings → Pages → Deploy from a branch → `main` → `/(root)` → Save. Wait for the Pages URL to appear.

## Important
- GitHub Pages hosts files; it does not provide the database. Supabase is the database and login provider.
- Free-plan limits and availability may change.
- Test with dummy data before using real shop records. Keep backups.
- This starter stores the app ledger as a shared JSON document; avoid editing the same record simultaneously on multiple devices until conflict-safe transactions are implemented.
