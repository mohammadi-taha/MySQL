-- use subquery with WHERE:
SELECT *
FROM employee_demographics
WHERE employee_id IN (
					SELECT employee_id
						FROM employee_salary
                        WHERE dept_id = 1
);

SELECT AVG(salary)
FROM employee_salary;

-- use subquery for show a general result (average salary) for each row:
SELECT first_name, salary,
(SELECT AVG(salary)
FROM employee_salary)
FROM employee_salary;