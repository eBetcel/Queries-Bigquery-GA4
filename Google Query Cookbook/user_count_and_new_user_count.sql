-- To get the total user count, count the number of distinct user_id. However, if your Google Analytics client does not send back a user_id with each hit or if you are unsure, count the number of distinct user_pseudo_id.
-- For new users, you can take the same count approach described above but for the following values of event_name:
-- first_visit
-- first_open

-- Example: Get 'Total User' count and 'New User' count.

WITH
  UserInfo AS (
    SELECT
      user_pseudo_id,
      MAX(IF(event_name IN ('first_visit', 'first_open'), 1, 0)) AS is_new_user
    -- Replace table name.
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    -- Replace date range.
    WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201130'
    GROUP BY 1
  )
SELECT
  COUNT(*) AS user_count,
  SUM(is_new_user) AS new_user_count
FROM UserInfo;