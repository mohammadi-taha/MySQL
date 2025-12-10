-- stored procedure
CREATE PROCEDURE high_salary()
SELECT *
FROM employee_salary
WHERE salary >= 50000;


-- call a stored procedure
CALL high_salary();


-- multiple procedure
DELIMITER $$
CREATE PROCEDURE salary_check1()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
	SELECT *
	FROM employee_salary
	WHERE salary >= 10000;
END $$
DELIMITER ;


CALL salary_check();


DELIMITER $$
CREATE PROCEDURE salary_check2(p_employee_id INT)
BEGIN
	SELECT salary
	FROM employee_salary
	WHERE employee_id = p_employee_id;
END $$
DELIMITER $$

CALL salary_check2(1)



