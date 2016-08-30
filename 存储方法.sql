存储方法

存储方法与存储过程的区别

1，存储方法的参数列表只允许IN类型的参数，而且没必要也不允许指定IN关键字

2，存储方法返回一个单一的值，值的类型在存储方法的头部定义

3，存储方法可以在SQL语句内部调用

4，存储方法不能返回结果集

语法：  http://dev.mysql.com/doc/refman/5.7/en/create-procedure.html



--------



CREATE
    [DEFINER = { user | CURRENT_USER }]
    PROCEDURE sp_name ([proc_parameter[,...]])
    [characteristic ...] routine_body

CREATE
    [DEFINER = { user | CURRENT_USER }]
    FUNCTION sp_name ([func_parameter[,...]])
    RETURNS type
    [characteristic ...] routine_body

proc_parameter:
    [ IN | OUT | INOUT ] param_name type

func_parameter:
    param_name type

type:
    Any valid MySQL data type

characteristic:
    COMMENT 'string'
  | LANGUAGE SQL
  | [NOT] DETERMINISTIC
  | { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }
  | SQL SECURITY { DEFINER | INVOKER }

routine_body:
    Valid SQL routine statement



----------------  例子
DELIMITER $$   
   
DROP FUNCTION IF EXISTS f_discount_price$$   
CREATE FUNCTION f_discount_price   
     (normal_price NUMERIC(8,2))   
     RETURNS NUMERIC(8,2)   
     DETERMINISTIC   
BEGIN   
     DECLARE discount_price NUMERIC(8,2);   
   
     IF (normal_price > 500) THEN   
         SET discount_price = normal_price * .8;   
     ELSEIF (normal_price >100) THEN   
         SET discount_price = normal_price * .9;   
     ELSE   
         SET discount_price = normal_price;   
     END IF;   
   
     RETURN(discount_price);   
END$$   
   
DELIMITER ;   