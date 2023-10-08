with time_stamp_check as (select webview_id,
                                 visitor_id,
                                 webview_timestamp,
                                 lag(webview_timestamp)
                                     over (partition by visitor_id order by webview_timestamp) last_timestamp
                          from {{ref('int__web_views')}}
                          order by visitor_id, webview_timestamp),
     session_increment as (select webview_timestamp,
                                  webview_id,
                                  visitor_id,
                                  count(
                                          case
                                              when DATETIME_DIFF(webview_timestamp, last_timestamp, minute) > 30
                                                  then webview_id
                                              else null end)
                                          over (partition by visitor_id order by webview_timestamp desc) session_number
                           from time_stamp_check),
     key_creation as (select webview_id,
                             webview_timestamp,
                             CONCAT(visitor_id, cast(session_number as string)) as session_key
                      from session_increment)
select webview_id,
       session_key,
       max(webview_timestamp) over (partition by session_key) as session_end,
       min(webview_timestamp) over (partition by session_key) as session_start
from key_creation