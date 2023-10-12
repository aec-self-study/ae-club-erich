{% snapshot favorite_ice_cream_flavors %}
 
{{ config(
      target_schema='dbt_epb_snapshots',
      unique_key='github_username',
      strategy='timestamp',
      updated_at='updated_at',
 ) }}
 with source as (
select
    submission_timestamp as updated_at,
    github_username,
    what_s_your_favorite_ice_cream_flavor as favorite_ice_cream_flavor
-- maybe we should be using a source here 😉
 from {{source('sheet_export', 'ice_cream_form_responses')}}
 where submission_timestamp is not null),
 most_recent as (
 select github_username,max(updated_at) as updated_at from source group by 1
 )
 select * from most_recent left join source using (github_username,updated_at)
 
{% endsnapshot %}