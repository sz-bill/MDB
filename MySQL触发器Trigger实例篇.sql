-- http://blog.csdn.net/hireboy/article/details/18079183
以前关注的数据存储过程不太懂其中奥妙，最近遇到跨数据库，同时对多个表进行CURD（Create增、Update改、Read读、Delete删），怎么才能让繁琐的数据CURD同步变得更容易呢？
相信很多人会首先想到了MYSQL存储过程、触发器，这种想法确实不错。于是饶有兴趣地亲自写了CUD（增、改、删）触发器的实例，用触发器实现多表数据同步更新。

定义： 何为MySQL触发器？
在MySQL Server里面也就是对某一个表的一定的操作，触发某种条件（Insert,Update,Delete 等），从而自动执行的一段程序。
从这种意义上讲触发器是一个特殊的存储过程。下面通过MySQL触发器实例，来了解一下触发器的工作过程吧！


一、创建MySQL实例数据表：
在mysql的默认的测试test数据库下，创建两个表t_a与t_b：

-------------------------- SQL BOF
/*Table structure for table `t_a` */
DROP TABLE IF EXISTS `t_a`;
CREATE TABLE `t_a` (
  `id` smallint(1) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(20) DEFAULT NULL,
  `groupid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
 
/*Data for the table `t_a` */
LOCK TABLES `t_a` WRITE;
UNLOCK TABLES;
 
/*Table structure for table `t_b` */
DROP TABLE IF EXISTS `t_b`;
CREATE TABLE `t_b` (
  `id` smallint(1) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(20) DEFAULT NULL,
  `groupid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=57 DEFAULT CHARSET=latin1;
 
/*Data for the table `t_b` */
LOCK TABLES `t_b` WRITE;
UNLOCK TABLES;
-------------------------- SQL EOF
在t_a表上分创建一个CUD（增、改、删）3个触发器，将t_a的表数据与t_b同步实现CUD，注意创建触发器每个表同类事件有且仅有一个对应触发器，为什么只能对一个触发器，不解释啦，看MYSQL的说明帮助文档吧。

二、创建MySQL实例触发器：

在实例数据表t_a上依次按照下面步骤创建tr_a_insert、tr_a_update、tr_a_delete三个触发器

	1、创建INSERT触发器trigger_a_insert：
	-------------------------- SQL BOF
	DELIMITER $$
	 
	USE `test`$$
	 
	--判断数据库中是否存在tr_a_insert触发器
	DROP TRIGGER /*!50032 IF EXISTS */ `tr_a_insert`$$
	--不存在tr_a_insert触发器，开始创建触发器
	--Trigger触发条件为insert成功后进行触发
	CREATE
	    /*!50017 DEFINER = 'root'@'localhost' */
	    TRIGGER `tr_a_insert` AFTER INSERT ON `t_a` 
	    FOR EACH ROW BEGIN
		--Trigger触发后，同时对t_b新增同步一条数据
		INSERT INTO `t_b` SET username = NEW.username, groupid=NEW.groupid;
	    END;
	$$
	 
	DELIMITER ;
	-------------------------- SQL EOF

	2、创建UPDATE触发器trigger_a_update：
	-------------------------- SQL BOF
	DELIMITER $$
	 
	USE `test`$$
	--判断数据库中是否存在tr_a_update触发器
	DROP TRIGGER /*!50032 IF EXISTS */ `tr_a_update`$$
	--不存在tr_a_update触发器，开始创建触发器
	--Trigger触发条件为update成功后进行触发
	CREATE
	    /*!50017 DEFINER = 'root'@'localhost' */
	    TRIGGER `tr_a_update` AFTER UPDATE ON `t_a` 
	    FOR EACH ROW BEGIN 
	    --Trigger触发后，当t_a表groupid,username数据有更改时，对t_b表同步一条更新后的数据
	      IF new.groupid != old.groupid OR old.username != new.username THEN
		UPDATE `t_b` SET groupid=NEW.groupid,username=NEW.username WHEREusername=OLD.username AND groupid=OLD.groupid;
	      END IF;
		  
	    END;
	$$
	 
	DELIMITER ;
	-------------------------- SQL EOF

	3、创建DELETE触发器trigger_a_delete：
	-------------------------- SQL BOF
	DELIMITER $$
	 
	USE `test`$$
	--判断数据库中是否存在tr_a_delete触发器
	DROP TRIGGER /*!50032 IF EXISTS */ `tr_a_delete`$$
	--不存在tr_a_delete触发器，开始创建触发器
	--Trigger触发条件为delete成功后进行触发
	CREATE
	    /*!50017 DEFINER = 'root'@'localhost' */
	    TRIGGER `tr_a_delete` AFTER DELETE ON `t_a` 
	    FOR EACH ROW BEGIN
		--t_a表数据删除后，t_b表关联条件相同的数据也同步删除
		DELETE FROM `t_b` WHERE username=Old.username AND groupid=OLD.groupid;
	    END;
	$$
	 
	DELIMITER ;
	-------------------------- SQL EOF


-- *************


三、测试MySQL实例触发器：

分别测试实现t_a与t_b实现数据同步CUD(增、改、删)3个Triggers

1、测试MySQL的实例tr_a_insert触发器：

在t_a表中新增一条数据，然后分别查询t_a/t_b表的数据是否数据同步，测试触发器成功标志，t_a表无论在何种情况下，新增了一条或多条记录集时，没有t_b表做任何数据insert操作，它同时新增了一样的多条记录集。

下面来进行MySQL触发器实例测试：

--t_a表新增一条记录集
    INSERT INTO `t_a` (username,groupid) VALUES ('sky54.net',123)
   
    --查询t_a表
    SELECT id,username,groupid FROM `t_a`
   
    --查询t_b表
    SELECT id,username,groupid FROM `t_b`
2、测试MySQL的实例tr_a_update、tr_a_delete触发器：

这两个MySQL触发器测试原理、步骤与tr_a_insert触发器一样的，先修改/删除一条数据，然后分别查看t_a、t_b表的数据变化情况，数据变化同步说明Trigger实例成功，否则需要逐步排查错误原因。

世界上任何一种事物都其其优点和缺点，优点与缺点是自身一个相对立的面。当然这里不是强调“世界非黑即白”式的“二元论”，“存在即合理”嘛。当然MySQL触发器的优点不说了，说一下不足之处，MySQL Trigger没有很好的调试、管理环境，难于在各种系统环境下测试，测试比MySQL存储过程要难，所以建议在生成环境下，尽量用存储过程来代替MySQL触发器。

本篇结束前再强调一下，支持触发器的MySQL版本需要5.0以上，5.0以前版本的MySQL升级到5.0以后版本方可使用触发器！