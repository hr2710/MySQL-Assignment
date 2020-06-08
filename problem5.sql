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

drop trigger if exists triggerOrderCount;

create trigger triggerOrderCount
after insert on orders
for each row
insert into updateOrderCount(customerNumber,orderCount)
    values (new.customerNumber,1) on duplicate key
    update orderCount:=orderCount+1;


