mysql查看所有存储过程,函数，视图，触发器，表


查询数据库中的存储过程和函数

方法一：

       select `name` from mysql.proc where db = 'your_db_name' and `type` = 'PROCEDURE'   //存储过程
       select `name` from mysql.proc where db = 'your_db_name' and `type` = 'FUNCTION'   //函数

方法二：

         show procedure status; //存储过程

        show function status;     //函数

查看存储过程或函数的创建代码

show create procedure proc_name;
show create function func_name;

查看视图

SELECT * from information_schema.VIEWS   //视图

SELECT * from information_schema.TABLES   //表

查看触发器

方法一：
语法：SHOW TRIGGERS [FROM db_name] [LIKE expr]
实例：SHOW TRIGGERS\G     //触发器

方法二：
对INFORMATION_SCHEMA数据库中的TRIGGERS表查询
mysql>SELECT * FROM triggers T WHERE trigger_name=”mytrigger” \G
