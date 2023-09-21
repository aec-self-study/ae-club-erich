with customer_webview as (select customer_id, min(webview_timestamp) as webview_timestamp, true as first_apperance
                          from {{ ref('stg_wt__pageviews') }}
                          where customer_id is not null
                          group by 1),
     re_key_visitor_id as (select customer_id, visitor_id as customer_visitor_id
                           from {{ ref('stg_wt__pageviews') }}
                                    left join customer_webview using (webview_timestamp, customer_id)
                           where first_apperance is true)
select webview_id,
       COALESCE(customer_visitor_id, visitor_id) as visitor_id,
       device_type,
       webview_timestamp,
       web_page,
       customer_id
from {{ ref('stg_wt__pageviews') }}
         left join re_key_visitor_id using (customer_id)