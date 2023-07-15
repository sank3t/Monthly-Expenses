-- monthly expenses
CREATE TABLE IF NOT EXISTS mnthly_expenses AS

SELECT
  CAST(year_month AS INT) AS year_month,
	CAST(expense_date AS DATE) AS expense_date,
	expense_category,
	spent_on,
	CAST(REPLACE(SUBSTR(amount, 3), ',', '') AS FLOAT) AS amount
FROM
  mnthly_expenses_raw;
