SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

SELECT gender
FROM employee_demographics
GROUP BY gender;

SELECT AVG(age)
FROM employee_demographics;

SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender;

SELECT occupation, salary
FROM employee_salary
GROUP BY occupation, salary;

SELECT gender, AVG(age), MAX(age), MIN(age), count(age)
FROM employee_demographics
GROUP BY gender;

SELECT *
FROM employee_demographics
ORDER BY first_name; 

SELECT *
FROM employee_demographics
ORDER BY gender, age;