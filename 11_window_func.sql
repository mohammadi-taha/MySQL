SELECT gender, AVG(salary)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender;

-- window func
SELECT dem.first_name, dem.last_name, 
AVG(salary) OVER() AS avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
-- window func + partition by gender
SELECT dem.first_name, dem.last_name, dem.gender, 
AVG(salary) OVER(PARTITION BY gender) AS avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
SELECT dem.first_name, dem.last_name, gender, 
SUM(salary) OVER(PARTITION BY gender) AS sum_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;

-- rolling total
SELECT dem.first_name, dem.last_name, gender, salary,
SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS rolling_total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
-- row number
SELECT ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
dem.first_name, dem.last_name, salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
SELECT dem.first_name, dem.last_name, salary,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_rank
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
SELECT dem.first_name, dem.last_name, salary, gender,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank_row
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;

    
    