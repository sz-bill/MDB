-- $$  是存储过程结束的句标符号,  可以自定义
-- DROP PROCEDURE IF EXITS cursor_example$$  , 创建存储过程前检查是否已经存在， 如存在就删除


DELIMITER $$  
DROP PROCEDURE IF EXITS cursor_example$$  
CREATE PROCEDURE cursor_example()  
     READS SQL DATA  
	BEGIN  
	     DECLARE l_employee_id INT;  
	     DECLARE l_salary NUMERIC(8,2);  
	     DECLARE l_department_id INT;  
	     DECLARE done INT DEFAULT 0;  

	     -- 把查询的结果集放入到变量[ cur1 ]中， 用法如:  DECLARE cur1 CURSOR FOR [这里是填写SQL查询语句的地方];
	     DECLARE cur1 CURSOR FOR SELECT employee_id, salary, department_id FROM employees;  
	     
	     -- 这里的作用是， 当查询语句发生异常的时候做什么处理/操作, 如果不处理， 将提前结束存储过程。
	     -- 如果对异常作出处理， 存储过程将继续往下运行
	     DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;  
	  
	     -- 处理结果集 [ cur1 ]
	     OPEN cur1;  

	     -- 循环结果集， 处理每条记录
	     emp_loop: LOOP  
		 FETCH cur1 INTO l_employee_id, l_salary, l_department_id;  
		 IF done=1 THEN  
		     LEAVE emp_loop;  
		 END IF;  
	     END LOOP emp_loop;  
	     -- 结束循环

	     -- 关闭结果集
	     CLOSE cur1;  

	END$$ 
DELIMITER ;  