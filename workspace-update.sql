-- Already applied to xlmygtqinvyvlwcnbevs on 2026-11-11.
-- Run only on another project after setup.sql.
grant delete on public.vibe_projects to authenticated;
grant update, delete on public.vibe_prompts to authenticated;
create policy projects_delete_own on public.vibe_projects for delete to authenticated
 using ((select auth.uid()) = user_id);
create policy prompts_update_own on public.vibe_prompts for update to authenticated
 using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy prompts_delete_own on public.vibe_prompts for delete to authenticated
 using ((select auth.uid()) = user_id);
