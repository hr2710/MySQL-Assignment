#Problem 1
/*
Modify payments/orders table to add another column which can include a foreign key and make a query possible that answers which payment corresponds to which order.
*/

# Adding a column for the foreign key
alter table payments add column orderNumber int not null;

# Updating random orderNumbers for the previous payments
update payments set orderNumber=(select orderNumber from orders order by rand() limit 1);

select * from payments order by paymentDate desc limit 10;
/*
+----------------+-------------+-------------+----------+-------------+
| customerNumber | checkNumber | paymentDate | amount   | orderNumber |
+----------------+-------------+-------------+----------+-------------+
|            506 | HR210012    | 2020-06-10  |   455.10 |       10209 |
|            503 | HR210012    | 2020-06-08  |   455.10 |       10333 |
|            504 | HR210012    | 2020-06-08  |   455.10 |       10208 |
|            500 | HR210012    | 2020-06-08  |    91.02 |       10415 |
|            502 | HR210012    | 2020-06-08  |   455.10 |       10279 |
|            505 | HR210012    | 2020-06-08  |   455.10 |       10420 |
|            501 | HR210012    | 2020-06-08  |    91.02 |       10382 |
|            499 | TT221122    | 2020-06-07  |    91.02 |       10330 |
|            353 | HJ618252    | 2005-06-09  | 46656.94 |       10229 |
|            242 | HR224331    | 2005-06-03  | 12432.32 |       10380 |
+----------------+-------------+-------------+----------+-------------+
10 rows in set (0.00 sec)
*/

# Adding a foreign key orderNumber which references from orders tables
alter table payments add constraint info foreign key(orderNumber) references orders(orderNumber);

# Adding a new entry in orders and payments table to verify if orders and payments are linked correctly 
insert into orders (orderNumber,orderDate,requiredDate,shippedDate,status,comments,customerNumber) values(10450,current_date,'2019-10-27','2019-06-21','In process','Successfully order placed',103);
insert into payments (customerNumber,checkNumber,paymentDate,amount,orderNumber) values (103,'HR200017',current_date,10000,10450);

select * from payments where checkNumber='HR200017';
/*
+----------------+-------------+-------------+----------+-------------+
| customerNumber | checkNumber | paymentDate | amount   | orderNumber |
+----------------+-------------+-------------+----------+-------------+
|            103 | HR200017    | 2020-06-10  | 10000.00 |       10450 |
+----------------+-------------+-------------+----------+-------------+
1 row in set (0.00 sec)
*/
select * from payments where orderNumber=10450;
/*
+----------------+-------------+-------------+----------+-------------+
| customerNumber | checkNumber | paymentDate | amount   | orderNumber |
+----------------+-------------+-------------+----------+-------------+
|            103 | HR200017    | 2020-06-10  | 10000.00 |       10450 |
+----------------+-------------+-------------+----------+-------------+
1 row in set (0.00 sec)
*/

