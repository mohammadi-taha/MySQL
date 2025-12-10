-- trigger
DELIMITER $$
CREATE TRIGGER add_automation
	AFTER INSERT ON employee_salary
	FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics(employee_id, first_name, last_name)
    VALUES(NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;


INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES(13, "Taha", "Mohammadi", "Machine Learning Engineer", 100000, NULL);


-- event
DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 1 MINUTE
DO
BEGIN
	DELETE 
    FROM employee_demographics
    WHERE age >= 60;
END $$
DELIMITER ;