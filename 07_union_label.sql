SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

-- union (uniqe)
SELECT first_name, last_name
FROM employee_demographics
UNION
SELECT first_name, last_name
FROM employee_salary;

-- union (not uniqe)
SELECT first_name, last_name
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary;

-- label
SELECT first_name, last_name, "old_man" AS label
FROM employee_demographics
WHERE age > 40 AND gender = "Male"
UNION
SELECT first_name, last_name, "old_lady" AS label
FROM employee_demographics
WHERE age > 40 AND gender = "Female"
UNION
SELECT first_name, last_name, "high salary" AS label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name;