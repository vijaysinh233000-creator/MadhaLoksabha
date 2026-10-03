-- Make the four public search modes real database filters while preserving
-- the existing own-name-first ranking used by the default "all" mode.
create or replace function public.search_voters_ranked(
  search_text text,
  village_name text default '',
  page_number integer default 1,
  page_size integer default 20,
  search_field text default 'all'
)
returns jsonb
language sql
stable
security invoker
set search_path = public, extensions
as $$
with input as (
  select
    lower(regexp_replace(btrim(coalesce(search_text, '')), '\s+', ' ', 'g')) as q,
    split_part(lower(regexp_replace(btrim(coalesce(search_text, '')), '\s+', ' ', 'g')), ' ', 1) as first_token,
    greatest(page_number, 1) as requested_page,
    least(greatest(page_size, 1), 100) as requested_size,
    case when search_field in ('all', 'name', 'relative', 'epic')
      then search_field else 'all' end as field,
    coalesce(search_text, '') ~ '[A-Za-z]'
      and coalesce(search_text, '') !~ '[ऀ-ॿ]' as roman
), base as (
  select v.id, v.name, v.relation_name, v.relation_type, v.epic, v.serial,
         v.part, v.house, v.age, v.gender, v.page, d.id as document_id,
         d.original_filename, g.name as village,
         case when i.roman then v.name_latin else v.name_normalized end as own_value,
         case when i.roman then v.relation_name_latin else v.relation_name_normalized end as relation_value,
         i.q, i.first_token, i.requested_page, i.requested_size, i.field
  from public.voters v
  join public.documents d on d.id = v.document_id and d.status = 'ready' and d.active
  join public.villages g on g.id = v.village_id and g.active
  cross join input i
  where i.q <> ''
    and (village_name = '' or lower(g.name) = lower(village_name))
), candidates as (
  select b.*,
    upper(b.epic) = upper(b.q) as epic_match,
    not exists (
      select 1 from regexp_split_to_table(b.q, '\s+') token
      where b.own_value not ilike '%' || token || '%'
    ) as own_tokens,
    not exists (
      select 1 from regexp_split_to_table(b.q, '\s+') token
      where b.relation_value not ilike '%' || token || '%'
    ) as relation_tokens,
    similarity(b.own_value, b.q) as own_similarity,
    similarity(b.relation_value, b.q) as relation_similarity
  from base b
), matched as (
  select c.*
  from candidates c
  where case c.field
    when 'name' then c.own_tokens or c.own_value ilike '%' || c.q || '%'
      or c.own_value % c.q
    when 'relative' then c.relation_tokens or c.relation_value ilike '%' || c.q || '%'
      or c.relation_value % c.q
    when 'epic' then c.epic_match
    else c.own_tokens or c.relation_tokens
      or c.own_value ilike '%' || c.q || '%'
      or c.relation_value ilike '%' || c.q || '%'
      or c.own_value % c.q or c.relation_value % c.q or c.epic_match
  end
), scored as (
  select m.*,
    case
      when epic_match then 1000
      when own_tokens and own_value = q then 106
      when own_tokens and own_value like first_token || '%' then 105
      when own_tokens and (' ' || own_value || ' ') like '% ' || q || ' %' then 104
      when own_tokens then 103
      when own_similarity >= 0.24 then 101
      when relation_tokens and relation_value = q then 6
      when relation_tokens and relation_value like first_token || '%' then 5
      when relation_tokens and (' ' || relation_value || ' ') like '% ' || q || ' %' then 4
      when relation_tokens then 3
      when relation_similarity >= 0.24 then 1
      else 0
    end as field_rank,
    case
      when field = 'relative' then relation_similarity
      when own_tokens or own_similarity >= 0.24 then own_similarity
      else relation_similarity
    end as relevance
  from matched m
), accepted as (
  select * from scored where field_rank > 0
), totals as (
  select count(*)::bigint as total from accepted
), page_rows as (
  select * from accepted
  order by field_rank desc, relevance desc, name, id
  limit (select requested_size from input)
  offset ((select requested_page - 1 from input) * (select requested_size from input))
), payload as (
  select coalesce(jsonb_agg(jsonb_build_object(
    'id', id, 'name', name, 'relation_name', relation_name,
    'relation_type', relation_type, 'epic', epic, 'serial', serial,
    'part', part, 'house', house, 'age', coalesce(age::text, ''),
    'gender', gender, 'page', page, 'pdf', document_id::text,
    'pdf_name', original_filename, 'village', village,
    'score', round((relevance * 100)::numeric, 1)
  ) order by field_rank desc, relevance desc, name, id), '[]'::jsonb) as rows
  from page_rows
)
select jsonb_build_object(
  'results', payload.rows,
  'total', totals.total,
  'page', input.requested_page,
  'page_size', input.requested_size,
  'query', jsonb_build_object('text', search_text, 'field', input.field),
  'relaxed', false,
  'suggestions', '[]'::jsonb
)
from input cross join totals cross join payload;
$$;

revoke all on function public.search_voters_ranked(text,text,integer,integer,text)
  from public, anon, authenticated;
grant execute on function public.search_voters_ranked(text,text,integer,integer,text)
  to service_role;

notify pgrst, 'reload schema';
