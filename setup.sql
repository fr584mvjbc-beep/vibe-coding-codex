-- Apply once in the Supabase SQL editor. No existing data is removed.
begin;
create table public.vibe_projects (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 title text not null check (char_length(trim(title)) between 1 and 120),
 description text not null default '' check (char_length(description) <= 3000),
 status text not null default 'idea' check (status in ('idea','done')),
 created_at timestamptz not null default now()
);
create table public.vibe_prompts (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 title text not null check (char_length(trim(title)) between 1 and 120),
 body text not null check (char_length(trim(body)) between 1 and 10000),
 created_at timestamptz not null default now()
);
create index vibe_projects_owner_created on public.vibe_projects(user_id, created_at desc);
create index vibe_prompts_owner_created on public.vibe_prompts(user_id, created_at desc);
alter table public.vibe_projects enable row level security;
alter table public.vibe_prompts enable row level security;
revoke all on public.vibe_projects, public.vibe_prompts from anon;
grant select, insert, update on public.vibe_projects to authenticated;
grant select, insert on public.vibe_prompts to authenticated;
create policy projects_read_own on public.vibe_projects for select to authenticated using ((select auth.uid()) = user_id);
create policy projects_insert_own on public.vibe_projects for insert to authenticated with check ((select auth.uid()) = user_id);
create policy projects_update_own on public.vibe_projects for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy prompts_read_own on public.vibe_prompts for select to authenticated using ((select auth.uid()) = user_id);
create policy prompts_insert_own on public.vibe_prompts for insert to authenticated with check ((select auth.uid()) = user_id);
commit;
