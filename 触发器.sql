-- 触发器
-- 触发器在INSERT、UPDATE或DELETE等DML语句修改数据库表时触发
-- 触发器的典型应用场景是重要的业务逻辑、提高性能、监控表的修改等
-- 触发器可以在DML语句执行前或后触发

DELIMITER $$   
   
DROP TRIGGER sales_trigger$$   
CREATE TRIGGER sales_trigger   
     BEFORE INSERT ON sales   
     FOR EACH ROW   
BEGIN   
     IF NEW.sale_value > 500 THEN   
         SET NEW.free_shipping = 'Y';   
     ELSE   
         SET NEW.free_shipping = 'N';   
     END IF;   
   
     IF NEW.sale_value > 1000 THEN   
         SET NEW.discount = NEW.sale_value * .15;   
     ELSE   
         SET NEW.discount = 0;   
     END IF;   
END$$   
   
DELIMITER ; 