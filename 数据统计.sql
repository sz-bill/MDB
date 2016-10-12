在介绍GROUP BY 和 HAVING 子句前，我们必需先讲讲sql语言中一种特殊的函数：聚合函数，
例如SUM, COUNT, MAX, AVG等。这些函数和其它函数的根本区别就是它们一般作用在多条记录上。

SELECT SUM(population) FROM bbc

这里的SUM作用在所有返回记录的population字段上，结果就是该查询只返回一个结果，即所有

国家的总人口数。

通过使用GROUP BY 子句，可以让SUM 和 COUNT 这些函数对属于一组的数据起作用。

当你指定 GROUP BY region 时， 属于同一个region（地区）的一组数据将只能返回一行值．

也就是说，表中所有除region（地区）外的字段，只能通过 SUM, COUNT等聚合函数运算后返回一个值．

HAVING子句可以让我们筛选成组后的各组数据．WHERE子句在聚合前先筛选记录．也就是说作用在GROUP BY 子句和HAVING子句前．

而 HAVING子句在聚合后对组记录进行筛选。

让我们还是通过具体的实例来理解GROUP BY 和 HAVING 子句，还采用第三节介绍的bbc表。

SQL实例：

一、显示每个地区的总人口数和总面积．

SELECT region, SUM(population), SUM(area)

FROM bbc

GROUP BY region

先以region把返回记录分成多个组，这就是GROUP BY的字面含义。分完组后，然后用聚合函数对每组中

的不同字段（一或多条记录）作运算。

二、 显示每个地区的总人口数和总面积．仅显示那些面积超过1000000的地区。

SELECT region, SUM(population), SUM(area)

FROM bbc

GROUP BY region

HAVING SUM(area)>1000000

在这里，我们不能用where来筛选超过1000000的地区，因为表中不存在这样一条记录。

相反，HAVING子句可以让我们筛选成组后的各组数据