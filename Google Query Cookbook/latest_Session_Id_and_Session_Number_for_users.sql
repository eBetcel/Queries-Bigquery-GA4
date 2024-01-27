-- Latest Session Id and Session Number for users
-- The following query provides the list of the latest ga_session_id and ga_session_number from last 4 days for a list of users. You can provide either a user_pseudo_id list or a user_id list.

-------------------- user_pseudo_id --------------------


-- Get the latest ga_session_id and ga_session_number for specific users during last 4 days.

-- Replace timezone. List at https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
DECLARE REPORTING_TIMEZONE STRING DEFAULT 'America/Los_Angeles';

-- Replace list of user_pseudo_id's with ones you want to query.
DECLARE USER_PSEUDO_ID_LIST ARRAY<STRING> DEFAULT
  [
    '1005355938.1632145814', '979622592.1632496588', '1101478530.1632831095'];

CREATE TEMP FUNCTION GetParamValue(params ANY TYPE, target_key STRING)
AS (
  (SELECT `value` FROM UNNEST(params) WHERE key = target_key LIMIT 1)
);

CREATE TEMP FUNCTION GetDateSuffix(date_shift INT64, timezone STRING)
AS (
  (SELECT FORMAT_DATE('%Y%m%d', DATE_ADD(CURRENT_DATE(timezone), INTERVAL date_shift DAY)))
);

SELECT DISTINCT
  user_pseudo_id,
  FIRST_VALUE(GetParamValue(event_params, 'ga_session_id').int_value)
    OVER (UserWindow) AS ga_session_id,
  FIRST_VALUE(GetParamValue(event_params, 'ga_session_number').int_value)
    OVER (UserWindow) AS ga_session_number
FROM
  -- Replace table name.
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  user_pseudo_id IN UNNEST(USER_PSEUDO_ID_LIST)
  AND RIGHT(_TABLE_SUFFIX, 8)
    BETWEEN GetDateSuffix(-3, REPORTING_TIMEZONE)
    AND GetDateSuffix(0, REPORTING_TIMEZONE)
WINDOW UserWindow AS (PARTITION BY user_pseudo_id ORDER BY event_timestamp DESC);

-------------------- user_id --------------------

-- Get the latest ga_session_id and ga_session_number for specific users during last 4 days.

-- Replace timezone. List at https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
DECLARE REPORTING_TIMEZONE STRING DEFAULT 'America/Los_Angeles';

-- Replace list of user_id's with ones you want to query.
DECLARE USER_ID_LIST ARRAY<STRING> DEFAULT ['<user_id_1>', '<user_id_2>', '<user_id_n>'];

CREATE TEMP FUNCTION GetParamValue(params ANY TYPE, target_key STRING)
AS (
  (SELECT `value` FROM UNNEST(params) WHERE key = target_key LIMIT 1)
);

CREATE TEMP FUNCTION GetDateSuffix(date_shift INT64, timezone STRING)
AS (
  (SELECT FORMAT_DATE('%Y%m%d', DATE_ADD(CURRENT_DATE(timezone), INTERVAL date_shift DAY)))
);

SELECT DISTINCT
  user_pseudo_id,
  FIRST_VALUE(GetParamValue(event_params, 'ga_session_id').int_value)
    OVER (UserWindow) AS ga_session_id,
  FIRST_VALUE(GetParamValue(event_params, 'ga_session_number').int_value)
    OVER (UserWindow) AS ga_session_number
FROM
  -- Replace table name.
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  user_id IN UNNEST(USER_ID_LIST)
  AND RIGHT(_TABLE_SUFFIX, 8)
    BETWEEN GetDateSuffix(-3, REPORTING_TIMEZONE)
    AND GetDateSuffix(0, REPORTING_TIMEZONE)
WINDOW UserWindow AS (PARTITION BY user_pseudo_id ORDER BY event_timestamp DESC);