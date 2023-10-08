WITH customer_webview AS (
    SELECT
        customer_id,
        MIN(webview_timestamp) AS webview_timestamp,
        TRUE AS first_apperance
    FROM
        {{ ref('stg_wt__pageviews') }}
    WHERE
        customer_id IS NOT NULL
    GROUP BY
        1
),
re_key_visitor_id AS (
    SELECT
        customer_id,
        visitor_id AS customer_visitor_id
    FROM
        {{ ref('stg_wt__pageviews') }}
        LEFT JOIN customer_webview USING (
            webview_timestamp,
            customer_id
        )
    WHERE
        first_apperance IS TRUE
),
stiched_visitors AS (
    SELECT
        webview_id,
        COALESCE(
            customer_visitor_id,
            visitor_id
        ) AS visitor_id,
        device_type,
        webview_timestamp,
        web_page,
        customer_id
    FROM
        {{ ref('stg_wt__pageviews') }}
        LEFT JOIN re_key_visitor_id USING (customer_id)
),
time_stamp_check AS (
    SELECT
        webview_id,
        visitor_id,
        webview_timestamp,
        LAG(webview_timestamp) over (
            PARTITION BY visitor_id
            ORDER BY
                webview_timestamp
        ) last_timestamp
    FROM
        stiched_visitors
    ORDER BY
        visitor_id,
        webview_timestamp
),
session_increment AS (
    SELECT
        webview_timestamp,
        webview_id,
        visitor_id,
        COUNT(
            CASE
                WHEN datetime_diff(
                    webview_timestamp,
                    last_timestamp,
                    MINUTE
                ) > 30 THEN webview_id
                ELSE NULL
            END
        ) over (
            PARTITION BY visitor_id
            ORDER BY
                webview_timestamp DESC
        ) session_number
    FROM
        time_stamp_check
),
key_creation AS (
    SELECT
        webview_id,
        webview_timestamp,
        CONCAT(visitor_id, CAST(session_number AS STRING)) AS session_key
    FROM
        session_increment
),
session_info AS (
    SELECT
        webview_id,
        session_key,
        MAX(webview_timestamp) over (
            PARTITION BY session_key
        ) AS session_end,
        MIN(webview_timestamp) over (
            PARTITION BY session_key
        ) AS session_start
    FROM
        key_creation
)
SELECT
    *
FROM
    stiched_visitors
    LEFT JOIN session_info USING (webview_id)
