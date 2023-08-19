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


-- 3. Creating hash table of names

CREATE TABLE IF NOT EXISTS hash_person_names AS

WITH persons AS (
  SELECT DISTINCT
    REPLACE(SPLIT_PART(spent_on, '(', 2), ')', '') AS p_name
  FROM
    mnthly_expenses
)
SELECT
  *,
  MD5(p_name) AS hashed_name
FROM persons
WHERE
  p_name <> '';


-- 4. Creating qa table of monthly expenses for doing data cleaning

CREATE TABLE IF NOT EXISTS mnthly_expenses_qa AS

WITH split_expense_person AS (
  SELECT
    *,
    SPLIT_PART(spent_on, '(', 1) AS expense,
    REPLACE(SPLIT_PART(spent_on, '(', 2), ')', '') AS p_name
  FROM
    mnthly_expenses
)
SELECT
  t1.*,
  t2.hashed_name
FROM
  split_expense_person t1
LEFT JOIN hash_person_names t2
  ON t1.p_name = t2.p_name;
