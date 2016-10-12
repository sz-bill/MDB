mysql中的select语句where条件group by ,having , order by,limit的顺序及用法

语句顺序
select 选择的列
from 表
where 查询的条件
group by   分组属性  having 分组过滤的条件
order by 排序属性
limit 起始记录位置，取记录的条数   
其中
select 选择的列
from 表
where 查询的条件
以上是基本的结构

group by   分组属性  having 分组过滤的条件
这个是按照分组属性进行分组，所有分组属性上值相同的记录被分为一组，作为结果中的一条记录，后面的having是对分组进行过滤的条件，必须和group by一起使用

order by 排序属性    是对结果集合进行排序，可以是升序asc，也可以是降序desc

limit 起始记录位置，取记录的条数 
对记录进行选取，主要用来实现分页功能


2016/10/122016/10/122016/10/122016/10/12



-- 语法：
SELECT select_list　　　 
FROM table_name　　 
[ WHERE search_condition ]　　 
[ GROUP BY group_by_expression ]　　 
[ HAVING search_condition ]　　 
[ ORDER BY order_expression [ ASC | DESC ] ] 
[limit m,n] 
  
-- 示例：
-- limit 0,10是从第一条开始,取10条数据
select classNo  from table_name  
group by classNo   
having(avg(成绩)>70) 
order by classNo  
limit 0,10