DECLARE CONTINUE HANDLER FOR NOT FOUND 解释 

---------


1.解释：

在MySQL的存储过程中经常会看到这句话：DECLARE CONTINUE HANDLER FOR NOT FOUND。

它的含义是：若没有数据返回,程序继续,并将变量IS_FOUND设为0 ，这种情况是出现在select XX into XXX from tablename的时候发生的。

2.示例：

/*建立存储过*/
CREATE PROCEDURE useCursor()
BEGIN
/*局部变量的定义*/
declare tmpName varchar(20) default '' ;
declare allName varchar(255) default '' ;

declare cur1 CURSOR FOR SELECT name FROM test.level ;

declare CONTINUE HANDLER FOR SQLSTATE '02000' SET tmpname = null;
#也可以这么写

#DECLARE CONTINUE HANDLER FOR NOT FOUND SET tmpname = null;

OPEN cur1;


FETCH cur1 INTO tmpName;
    WHILE ( tmpname is not null) DO
    set tmpName = CONCAT(tmpName ,";") ;
    set allName = CONCAT(allName ,tmpName) ;
    FETCH cur1 INTO tmpName;
END WHILE;


CLOSE cur1;

select allName ;
END;
call useCursor()

 
