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
FROM
 persons
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
  t2.hashed_name,
  t2.hashed_name AS updated_hash
FROM
  split_expense_person t1
LEFT JOIN hash_person_names t2
  ON t1.p_name = t2.p_name;


-- 5.1 Fixing and replacing person names

UPDATE mnthly_expenses_qa
SET
  p_name = NULL,
  updated_hash = NULL
WHERE
  hashed_name = '93ff84f987001b4bdb0b5b3aeca2c072';


UPDATE mnthly_expenses_qa
SET
  p_name = NULL,
  updated_hash = NULL
WHERE
  hashed_name = '9dda562283504ee64e8c9cb003729371';



UPDATE mnthly_expenses_qa
SET
  p_name = NULL,
  updated_hash = NULL
WHERE
  hashed_name = 'd613ecf2d51e48f77b890097244d113b';


UPDATE mnthly_expenses_qa
SET
  p_name = (
    SELECT p_name
    FROM hash_person_names
    WHERE hashed_name = 'b8bfd8c4c388fa3643d9cdf2bd540c2c'
  ),
  updated_hash = 'b8bfd8c4c388fa3643d9cdf2bd540c2c'
WHERE
  hashed_name = 'a7b5bdb8cce7b6d6713cc8897c5cf374';


UPDATE mnthly_expenses_qa
SET
 p_name = (
    SELECT p_name
    FROM hash_person_names
    WHERE hashed_name = '927161e4eef8351232e3b15efd2ae872'
  ),
  updated_hash = '927161e4eef8351232e3b15efd2ae872'
WHERE
  hashed_name IN ('4af8989a64edc6f13a0b59ec047d1db5', 'c988fa7c33ce43962b9803702b747a35');


UPDATE mnthly_expenses_qa
SET
  p_name = (
    SELECT p_name
    FROM hash_person_names
    WHERE hashed_name = '298da4610b51213458138d4f800d5a83'
  ),
  updated_hash = '298da4610b51213458138d4f800d5a83'
WHERE
  hashed_name = 'bc7339e35ab33789ade87cdefb9e157f';


UPDATE mnthly_expenses_qa
SET
  p_name = 'Parents'
WHERE
  hashed_name = 'e92e9f7025034e63775e80933b431da4';
