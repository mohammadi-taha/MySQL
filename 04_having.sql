-- Warning: SELECT gender, AVG(age)  #DO NOT FORGET THE FUNC PART

SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40
;

SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE "%manager%"
GROUP BY occupation, first_name
HAVING AVG(salary) > 75000;
