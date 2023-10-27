-- 1. Raw table DDL

CREATE TABLE IF NOT EXISTS public.food_expenses_raw (
    year_month VARCHAR,
    month_name VARCHAR,
    expense_date VARCHAR,
    expense_category VARCHAR,
    outlet VARCHAR,
    item VARCHAR,
    amount VARCHAR,
    payment_mode VARCHAR
)

-- 2. Preparing food expenses table

DROP TABLE IF EXISTS food_expenses;

CREATE TABLE food_expenses AS

SELECT
  CAST(year_month AS INT) AS year_month,
  CAST(expense_date AS DATE) AS expense_date,
  expense_category,
  CASE
    WHEN outlet = '-' THEN NULL
    ELSE outlet
  END AS outlet,
  item,
  CAST(REPLACE(amount, '₹', '')AS FLOAT) AS amount,
  payment_mode
FROM
  food_expenses_raw;
