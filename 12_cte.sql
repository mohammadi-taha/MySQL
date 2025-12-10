-- cte
WITH cte_example (gender, avg_sal, max_sal, min_sal, count_sal) AS
(
SELECT gender, AVG(salary), MAX(salary), MIN(salary), COUNT(salary)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM cte_example;


WITH cte_example (gender, avg_sal, max_sal, min_sal, count_sal) AS
(
SELECT gender, AVG(salary), MAX(salary), MIN(salary), COUNT(salary)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT AVG(avg_sal)
FROM cte_example;


-- multiple cte
WITH cte_example AS
(
SELECT employee_id, first_name, last_name, birth_date
FROM employee_demographics
WHERE birth_date > "1980-01-01"
),
cte_example2 AS
(
SELECT employee_id, salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *
FROM cte_example e1
JOIN cte_example2 e2
	ON e1.employee_id = e2.employee_id;