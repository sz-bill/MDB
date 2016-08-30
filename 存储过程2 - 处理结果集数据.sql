-- unbounded SELECT语句用于存储过程返回结果集

DELIMITER $$  

DROP PROCEDURE IF EXISTS sp_emps_in_dept$$  
CREATE PROCEDURE sp_emps_in_dept(in_employee_id INT)  
BEGIN  
     SELECT employee_id, surname, firstname, address1, address2, zipcode, date_of_birth FROM employees WHERE department_id=in_employee_id;  
END$$  
  
DELIMITER ;   
