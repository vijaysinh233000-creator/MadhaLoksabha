-- Recompute duplicate review from the latest ready/active voter index.
-- This function is read-only: it never merges, hides, or updates voters.
create or replace function public.admin_duplicate_voters()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  with active as materialized (
    select v.id, v.name, v.name_normalized, v.relation_name,
           v.relation_name_normalized, v.relation_type, v.epic, v.serial,
           v.part, v.house, v.age, v.gender, v.page,
           v.village_id, g.name as village, d.id as document_id,
           d.original_filename as pdf_name, d.indexed_at
      from public.voters v
      join public.documents d on d.id = v.document_id
        and d.status = 'ready' and d.active
      join public.villages g on g.id = v.village_id and g.active
  ),
  epic_groups as (
    select upper(btrim(epic)) as match_key, min(epic) as label,
           count(*) as match_count,
           jsonb_agg(jsonb_build_object(
             'id', id, 'name', name, 'relation_name', relation_name,
             'relation_type', relation_type, 'epic', epic, 'serial', serial,
             'part', part, 'house', house, 'age', coalesce(age::text, ''),
             'gender', gender, 'page', page, 'village', village,
             'pdf', document_id, 'pdf_name', pdf_name
           ) order by village, pdf_name, page, id) as records
      from active
     where btrim(epic) <> ''
     group by upper(btrim(epic))
    having count(*) > 1
  ),
  name_groups as (
    select village_id::text || ':' || name_normalized || ':' || relation_name_normalized as match_key,
           min(name) as label, min(relation_name) as relation_label,
           case
             when count(distinct nullif(upper(btrim(epic)), '')) = 1
               and count(nullif(btrim(epic), '')) = count(*) then 'confirmed'
             when count(distinct nullif(btrim(house), '')) = 1
               and count(nullif(btrim(house), '')) = count(*)
               and count(distinct age) <= 1
               and count(distinct nullif(btrim(gender), '')) <= 1 then 'strong_match'
             else 'manual_review'
           end as verification,
           count(*) as match_count,
           jsonb_agg(jsonb_build_object(
             'id', id, 'name', name, 'relation_name', relation_name,
             'relation_type', relation_type, 'epic', epic, 'serial', serial,
             'part', part, 'house', house, 'age', coalesce(age::text, ''),
             'gender', gender, 'page', page, 'village', village,
             'pdf', document_id, 'pdf_name', pdf_name
           ) order by pdf_name, page, id) as records
      from active
     where btrim(name_normalized) <> '' and btrim(relation_name_normalized) <> ''
     group by village_id, name_normalized, relation_name_normalized
    having count(*) > 1
  )
  select jsonb_build_object(
    'verified_at', to_char(statement_timestamp() at time zone 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'),
    'latest_indexed_at', coalesce((select max(indexed_at)::text from active), ''),
    'epic', coalesce((select jsonb_agg(jsonb_build_object(
      'key', match_key, 'label', label, 'relation_label', '',
      'verification', 'confirmed',
      'reasons', jsonb_build_array('Same non-empty EPIC in latest active index'),
      'count', match_count, 'records', records
    ) order by label) from epic_groups), '[]'::jsonb),
    'name', coalesce((select jsonb_agg(jsonb_build_object(
      'key', match_key, 'label', label, 'relation_label', relation_label,
      'verification', verification,
      'reasons', jsonb_build_array('Same normalized voter and relative name in one village'),
      'count', match_count, 'records', records
    ) order by label) from name_groups), '[]'::jsonb)
  );
$$;

revoke all on function public.admin_duplicate_voters() from public, anon, authenticated;
grant execute on function public.admin_duplicate_voters() to service_role;

-- Cross-village groups use the same full-detail payload and conservative
-- confidence labels. Different-relative matches always require manual review.
create or replace function public.admin_cross_village_duplicates()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  with active as materialized (
    select v.id, v.name, v.name_normalized, v.relation_name,
           v.relation_name_normalized, v.relation_type, v.epic, v.serial,
           v.part, v.house, v.age, v.gender, v.page,
           v.village_id, g.name as village, d.id as document_id,
           d.original_filename as pdf_name
      from public.voters v
      join public.documents d on d.id = v.document_id
        and d.status = 'ready' and d.active
      join public.villages g on g.id = v.village_id and g.active
     where btrim(v.name_normalized) <> ''
       and btrim(v.relation_name_normalized) <> ''
  ),
  same_relative as (
    select name_normalized || ':' || relation_name_normalized as match_key,
           min(name) as label, min(relation_name) as relation_label,
           case
             when count(distinct nullif(upper(btrim(epic)), '')) = 1
               and count(nullif(btrim(epic), '')) = count(*) then 'confirmed'
             when count(distinct nullif(btrim(house), '')) = 1
               and count(nullif(btrim(house), '')) = count(*) then 'strong_match'
             else 'manual_review'
           end as verification,
           count(*) as match_count,
           jsonb_agg(jsonb_build_object(
             'id', id, 'name', name, 'relation_name', relation_name,
             'relation_type', relation_type, 'epic', epic, 'serial', serial,
             'part', part, 'house', house, 'age', coalesce(age::text, ''),
             'gender', gender, 'page', page, 'village', village,
             'pdf', document_id, 'pdf_name', pdf_name
           ) order by village, pdf_name, page, id) as records
      from active
     group by name_normalized, relation_name_normalized
    having count(distinct village_id) > 1
  ),
  different_relative as (
    select name_normalized as match_key, min(name) as label,
           count(*) as match_count,
           jsonb_agg(jsonb_build_object(
             'id', id, 'name', name, 'relation_name', relation_name,
             'relation_type', relation_type, 'epic', epic, 'serial', serial,
             'part', part, 'house', house, 'age', coalesce(age::text, ''),
             'gender', gender, 'page', page, 'village', village,
             'pdf', document_id, 'pdf_name', pdf_name
           ) order by village, relation_name, pdf_name, page, id) as records
      from active
     group by name_normalized
    having count(distinct village_id) > 1
       and count(distinct relation_name_normalized) > 1
  )
  select jsonb_build_object(
    'same_relative', coalesce((select jsonb_agg(jsonb_build_object(
      'key', match_key, 'label', label, 'relation_label', relation_label,
      'verification', verification,
      'reasons', jsonb_build_array('Same normalized voter and relative name across villages'),
      'count', match_count, 'records', records
    ) order by label) from same_relative), '[]'::jsonb),
    'different_relative', coalesce((select jsonb_agg(jsonb_build_object(
      'key', match_key, 'label', label, 'relation_label', '',
      'verification', 'manual_review',
      'reasons', jsonb_build_array('Same normalized voter name but different relatives'),
      'count', match_count, 'records', records
    ) order by label) from different_relative), '[]'::jsonb)
  );
$$;

revoke all on function public.admin_cross_village_duplicates() from public, anon, authenticated;
grant execute on function public.admin_cross_village_duplicates() to service_role;
