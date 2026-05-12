create table if not exists public.parent_state (
  parent_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.parent_state enable row level security;

drop policy if exists "Parents can read their state" on public.parent_state;
drop policy if exists "Parents can create their state" on public.parent_state;
drop policy if exists "Parents can update their state" on public.parent_state;
drop policy if exists "Parents can delete their state" on public.parent_state;

create policy "Parents can read their state"
on public.parent_state
for select
to authenticated
using (auth.uid() = parent_id);

create policy "Parents can create their state"
on public.parent_state
for insert
to authenticated
with check (auth.uid() = parent_id);

create policy "Parents can update their state"
on public.parent_state
for update
to authenticated
using (auth.uid() = parent_id)
with check (auth.uid() = parent_id);

create policy "Parents can delete their state"
on public.parent_state
for delete
to authenticated
using (auth.uid() = parent_id);
