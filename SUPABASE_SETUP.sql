-- SONA CHICKEN CENTER — Supabase schema
create table if not exists public.shop_members (
  shop_id text not null,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null default 'staff' check (role in ('owner','staff')),
  created_at timestamptz not null default now(),
  primary key (shop_id,user_id)
);
create table if not exists public.ledger_documents (
  shop_id text not null,
  doc_id text not null,
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  updated_by uuid references auth.users(id),
  primary key (shop_id,doc_id)
);
alter table public.shop_members enable row level security;
alter table public.ledger_documents enable row level security;
drop policy if exists "members can read their own membership" on public.shop_members;
create policy "members can read their own membership" on public.shop_members for select to authenticated using (user_id = auth.uid());
drop policy if exists "members can read shop ledger" on public.ledger_documents;
create policy "members can read shop ledger" on public.ledger_documents for select to authenticated using (exists (select 1 from public.shop_members m where m.shop_id = ledger_documents.shop_id and m.user_id = auth.uid()));
drop policy if exists "members can insert shop ledger" on public.ledger_documents;
create policy "members can insert shop ledger" on public.ledger_documents for insert to authenticated with check (updated_by = auth.uid() and exists (select 1 from public.shop_members m where m.shop_id = ledger_documents.shop_id and m.user_id = auth.uid()));
drop policy if exists "members can update shop ledger" on public.ledger_documents;
create policy "members can update shop ledger" on public.ledger_documents for update to authenticated using (exists (select 1 from public.shop_members m where m.shop_id = ledger_documents.shop_id and m.user_id = auth.uid())) with check (updated_by = auth.uid() and exists (select 1 from public.shop_members m where m.shop_id = ledger_documents.shop_id and m.user_id = auth.uid()));
do $$ begin alter publication supabase_realtime add table public.ledger_documents; exception when duplicate_object then null; when undefined_object then null; end $$;

-- After creating the owner in Authentication → Users, replace the UUID and run:
-- insert into public.shop_members(shop_id,user_id,role)
-- values ('sona-chicken-center','REPLACE-WITH-OWNER-UUID','owner');
