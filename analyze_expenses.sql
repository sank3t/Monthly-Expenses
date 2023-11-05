-- Total Expenses by month

SELECT
  year_month,
	SUM(amount) AS total_expenses
FROM
  mnthly_expenses_prod
GROUP BY
  year_month
ORDER BY
  year_month;
