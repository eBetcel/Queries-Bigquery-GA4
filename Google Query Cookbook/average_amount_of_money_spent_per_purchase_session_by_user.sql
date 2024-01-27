-- Average amount of money spent per purchase session by user
-- The following query shows the average amount of money spent per session by each user. This takes into account only the sessions where the user made a purchase.


-- Example: Average amount of money spent per purchase session by user.

WITH
  events AS (
    SELECT
      session.value.int_value AS session_id,
      COALESCE(spend.value.int_value, spend.value.float_value, spend.value.double_value, 0.0)
        AS spend_value,
      event.*

    -- Replace table name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` AS event
    LEFT JOIN UNNEST(event.event_params) AS session
      ON session.key = 'ga_session_id'
    LEFT JOIN UNNEST(event.event_params) AS spend
      ON spend.key = 'value'

    -- Replace date range
    WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  )
SELECT
  user_pseudo_id,
  COUNT(DISTINCT session_id) AS session_count,
  SUM(spend_value) / COUNT(DISTINCT session_id) AS avg_spend_per_session_by_user
FROM events
WHERE event_name = 'purchase' and session_id IS NOT NULL
GROUP BY user_pseudo_id