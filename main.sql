-- 1. Raw table DDL
CREATE TABLE mnthly_expenses_raw (
  year_month VARCHAR,
  month_name VARCHAR,
  expense_date VARCHAR,
  expense_category VARCHAR,
  spent_on VARCHAR,
  amount VARCHAR
);


-- 2. Preparing monthly expenses
CREATE TABLE IF NOT EXISTS mnthly_expenses AS

SELECT
  CAST(year_month AS INT) AS year_month,
  CAST(expense_date AS DATE) AS expense_date,
  expense_category,
  spent_on,
  CAST(REPLACE(SUBSTR(amount, 3), ',', '') AS FLOAT) AS amount
FROM
  mnthly_expenses_raw;
