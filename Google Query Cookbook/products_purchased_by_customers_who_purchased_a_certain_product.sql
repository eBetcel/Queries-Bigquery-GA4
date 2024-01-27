-- Products purchased by customers who purchased a certain product
-- The following query shows what other products were purchased by customers who purchased a specific product. This example does not assume that the products were purchased in the same order.

-- The optimized example relies on BigQuery scripting features to define a variable that declares which items to filter on. While this does not improve performance, this is a more readable approach for defining variables compared creating a single value table using a WITH clause. The simplified query uses the latter approach using the WITH clause.

-- The simplified query creats a separate list of "Product A buyers" and does a join with that data. The optimized query, instead, creates a list of all items a user has purchased across orders using the ARRAY_AGG function. Then using the outer WHERE clause, purchase lists across all users are filtered for the target_item and only relevant items are shown.

-- Example: Products purchased by customers who purchased a specific product.
--
-- `Params` is used to hold the value of the selected product and is referenced
-- throughout the query.

WITH
  Params AS (
    -- Replace with selected item_name or item_id.
    SELECT 'Google Navy Speckled Tee' AS selected_product
  ),
  PurchaseEvents AS (
    SELECT
      user_pseudo_id,
      items
    FROM
      -- Replace table name.
      `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE
      -- Replace date range.
      _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
      AND event_name = 'purchase'
  ),
  ProductABuyers AS (
    SELECT DISTINCT
      user_pseudo_id
    FROM
      Params,
      PurchaseEvents,
      UNNEST(items) AS items
    WHERE
      -- item.item_id can be used instead of items.item_name.
      items.item_name = selected_product
  )
SELECT
  items.item_name AS item_name,
  SUM(items.quantity) AS item_quantity
FROM
  Params,
  PurchaseEvents,
  UNNEST(items) AS items
WHERE
  user_pseudo_id IN (SELECT user_pseudo_id FROM ProductABuyers)
  -- item.item_id can be used instead of items.item_name
  AND items.item_name != selected_product
GROUP BY 1
ORDER BY item_quantity DESC;

------------------------------ OPTIMIZED QUERY ------------------------------
 

-- Optimized Example: Products purchased by customers who purchased a specific product.

-- Replace item name
DECLARE target_item STRING DEFAULT 'Google Navy Speckled Tee';

SELECT
  IL.item_name AS item_name,
  SUM(IL.quantity) AS quantity
FROM
  (
    SELECT
      user_pseudo_id,
      ARRAY_AGG(STRUCT(item_name, quantity)) AS item_list
    FROM
      -- Replace table
      `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`, UNNEST(items)
    WHERE
      -- Replace date range
      _TABLE_SUFFIX BETWEEN '20201201' AND '20201210'
      AND event_name = 'purchase'
    GROUP BY
      1
  ),
  UNNEST(item_list) AS IL
WHERE
  target_item IN (SELECT item_name FROM UNNEST(item_list))
  -- Remove the following line if you want the target_item to appear in the results
  AND target_item != IL.item_name
GROUP BY
  item_name
ORDER BY
  quantity DESC;