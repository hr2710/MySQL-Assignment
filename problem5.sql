# Problem 5
/*
Create a table with 2 columns, customerNumber and orderCount. Add a trigger on orders table which increments the count in the new table whenever a new entry is done in the orders.
Figure out a way to pre-fill the table with the old data.
*/

drop table if exists updateOrderCount;

create table updateOrderCount(
  customerNumber int not null primary key,
  orderCount int default 0,
  foreign key(customerNumber) references customers(customerNumber)
);

# prefilling the updateOrderCount table
insert into updateOrderCount(customerNumber,orderCount)
select customers.customerNumber, count(orderNumber)
from customers join orders on customers.customerNumber=orders.customerNumber 
group by customerNumber;
/*
Query OK, 108 rows affected (0.05 sec)
Records: 108  Duplicates: 0  Warnings: 0
*/

desc updateOrderCount;
/*
+----------------+---------+------+-----+---------+-------+
| Field          | Type    | Null | Key | Default | Extra |
+----------------+---------+------+-----+---------+-------+
| customerNumber | int(11) | NO   | PRI | NULL    |       |
| orderCount     | int(11) | YES  |     | 0       |       |
+----------------+---------+------+-----+---------+-------+
2 rows in set (0.00 sec)
*/

select * from updateOrderCount limit 20;
/*
+----------------+------------+
| customerNumber | orderCount |
+----------------+------------+
|            103 |          3 |
|            112 |          3 |
|            114 |          5 |
|            119 |          4 |
|            121 |          4 |
|            124 |         17 |
|            128 |          4 |
|            129 |          3 |
|            131 |          4 |
|            141 |         26 |
|            144 |          4 |
|            145 |          5 |
|            146 |          3 |
|            148 |          5 |
|            151 |          4 |
|            157 |          4 |
|            161 |          4 |
|            166 |          4 |
|            167 |          3 |
|            171 |          2 |
+----------------+------------+
20 rows in set (0.00 sec)
*/

drop trigger if exists triggerOrderCount;

delimiter $$
create trigger triggerOrderCount
after insert on orders
for each row
/*If the customer is old, just update the order count else create a new customer entry with order count 1*/
begin
insert into updateOrderCount(customerNumber,orderCount)
    values (new.customerNumber,1) on duplicate key
    update orderCount:=orderCount+1;
end $$

delimiter ;
