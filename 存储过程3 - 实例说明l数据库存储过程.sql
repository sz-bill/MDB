写mysql存储过程应注意的几点：

1、声明变量（declare）时要注意字符集，用变量存储表字段时，表字段与变量的字符编码要一致。

2、mysql的字符合并不能用‘+’号，必须用concat函数。

3、每个游标必须使用不同的declare continue handler for not found set done=1来控制游标的结束。

BEGIN

declare rt VARCHAR(100) CHARACTER SET gbk DEFAULT NULL;

declare done tinyint(1) default 0;

DECLARE ttname VARCHAR(60) CHARACTER SET gbk DEFAULT NULL;

DECLARE tsqltxt VARCHAR(512) CHARACTER SET gbk DEFAULT NULL;

DECLARE tremarks VARCHAR(60) CHARACTER SET gbk DEFAULT NULL;

DECLARE tfield VARCHAR(60) CHARACTER SET gbk DEFAULT NULL;

 

DECLARE curtable CURSOR FOR

      SELECT distinct TABLE_name

       FROM information_schema.TABLEs where TRIM(TABLE_COMMENT)<>'' and TRIM(TABLE_COMMENT)<>'VIEW'  order by TABLE_name;

 

declare continue handler for not found set done=1;

 set NAMES 'utf8';

drop table if EXISTS GetTableSQL;

CREATE TABLE `gettablesql` (

  `tbname` varchar(60) CHARACTER SET gbk DEFAULT NULL,

  `sqltxt` varchar(4096) CHARACTER SET gbk DEFAULT NULL,

  `tabletitle` varchar(51) CHARACTER SET gbk DEFAULT NULL

) ENGINE=InnoDB;

open curtable;

   tableloop:

  LOOP

      set tsqltxt='select';

      FETCH curtable

      INTO ttname;

      IF done = 1 THEN

         LEAVE tableloop;

      END IF;

      -- select ttname;

 BEGIN

       declare done1 tinyint(1) default 0;

       DECLARE curfield CURSOR FOR

      
SELECT  COLUMN_NAME,COLUMN_COMMENT

            FROM information_schema.COLUMNS  where upper(TABLE_name)=upper(ttname) and (COLUMN_COMMENT<>'') ;

       declare continue handler for not found set done1=1;

      OPEN curfield;

         fieldloop:

       LOOP

        FETCH curfield

        INTO tfield,tremarks;

        IF done1 = 1 THEN

         LEAVE fieldloop;

        END IF;

        if tsqltxt='select' THEN

           set tsqltxt=CONCAT(tsqltxt,' ',tfield,' ','''',tremarks,'''');

        ELSE

           set tsqltxt=CONCAT(tsqltxt,',',tfield,' ','''',tremarks,'''');

        END IF;

      

       END LOOP fieldloop;

       close curfield;

       set tsqltxt=concat(tsqltxt,' from ',ttname);

       insert into GetTableSQL values(ttname,tsqltxt,'');

END;

   END LOOP tableloop;

   close curtable;

  update GetTableSQL as G set tabletitle=(select TABLE_COMMENT from information_schema.TABLEs  s

   where (trim(s.TABLE_COMMENT)<>'') and g.tbname=s.table_name );

  select cast(count(*) as char) into rt from GetTableSQL;

  set rt=concat('成功更新',rt,'个表的表名注释和字段注释到字典库GetTableSQL中！');

  SELECT rt;

END