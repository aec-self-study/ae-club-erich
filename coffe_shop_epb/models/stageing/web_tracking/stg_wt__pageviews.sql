SELECT
    id AS webview_id,
    visitor_id,
    device_type,
    TIMESTAMP AS webview_timestamp,
    page AS web_page,
    customer_id
FROM
    {{ source(
        'web_tracking',
        'pageviews'
    ) }}
