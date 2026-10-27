-- Hot Pink Hours: run this once in Supabase > SQL Editor > New query

create table if not exists public.docs (
  user_id    uuid        not null default auth.uid() references auth.users(id) on delete cascade,
  kind       text        not null check (kind in ('config', 'dueouts', 'day')),
  key        text        not null,          -- 'main' for config/dueouts, 'YYYY-MM-DD' for days
  data       jsonb       not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, kind, key)
);

-- Row Level Security: every row is visible and editable only by the user who owns it.
alter table public.docs enable row level security;

create policy "Read own docs"   on public.docs for select to authenticated using ((select auth.uid()) = user_id);
create policy "Insert own docs" on public.docs for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "Update own docs" on public.docs for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "Delete own docs" on public.docs for delete to authenticated using ((select auth.uid()) = user_id);

-- Live sync between your phone, iPad and Mac
alter publication supabase_realtime add table public.docs;
