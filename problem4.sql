#Problem 4
/*
  In continuation to problem 3, On a website, this new customer(created during the transaction) needs to see the invoice details, make a query that showcases the following data: Customer Name, orderNumber, shippedDate, payment date, amount, quantity ordered, productName, image of the productLine.
Use explain statement to refine your query.
*/

/*Selecting the recent customer and his ordernumber*/
select 
    @recentCustomerNumber:=max(customerNumber) 
from customers;
/*
+--------------------------------------------+
| @recentCustomerNumber:=max(customerNumber) |
+--------------------------------------------+
|                                        506 |
+--------------------------------------------+
1 row in set (0.11 sec)
*/

select 
    @recentOrderNumber:= orderNumber from orders where customerNumber=@recentCustomerNumber;
/*
+----------------------------------+
| @recentOrderNumber:= orderNumber |
+----------------------------------+
|                            10435 |
+----------------------------------+
1 row in set (0.01 sec)
*/

/*Invoice details*/
select customers.customerName,orders.orderNumber,shippedDate,paymentDate,amount,quantityOrdered,productName,image
from payments join customers join orders join orderdetails join products join productlines
on payments.customerNumber=customers.customerNumber 
&& customers.customerNumber=orders.customerNumber 
&& customers.customerNumber=@recentCustomerNumber 
&& orders.orderNumber=orderdetails.orderNumber 
&& orders.orderNumber=@recentOrderNumber 
&& orderdetails.productCode=products.productCode 
&& products.productLine=productlines.productLine;
/*
+-----------------+-------------+-------------+-------------+--------+-----------------+---------------------------------------+-------+
| customerName    | orderNumber | shippedDate | paymentDate | amount | quantityOrdered | productName                           | image |
+-----------------+-------------+-------------+-------------+--------+-----------------+---------------------------------------+-------+
| Random Customer |       10435 | NULL        | 2020-06-10  | 455.10 |               5 | 1969 Harley Davidson Ultimate Chopper | NULL  |
+-----------------+-------------+-------------+-------------+--------+-----------------+---------------------------------------+-------+
1 row in set (0.00 sec)
*/


/*Explain the query*/
explain select customers.customerName,orders.orderNumber,shippedDate,paymentDate,amount,quantityOrdered,productName,image
from payments join customers join orders join orderdetails join products join productlines
on payments.customerNumber=customers.customerNumber 
&& customers.customerNumber=orders.customerNumber 
&& customers.customerNumber=@recentCustomerNumber 
&& orders.orderNumber=orderdetails.orderNumber 
&& orders.orderNumber=@recentOrderNumber 
&& orderdetails.productCode=products.productCode 
&& products.productLine=productlines.productLine;
/*
+----+-------------+--------------+------------+--------+------------------------+---------+---------+----------------------------------------+------+----------+-------+
| id | select_type | table        | partitions | type   | possible_keys          | key     | key_len | ref                                    | rows | filtered | Extra |
+----+-------------+--------------+------------+--------+------------------------+---------+---------+----------------------------------------+------+----------+-------+
|  1 | SIMPLE      | customers    | NULL       | const  | PRIMARY                | PRIMARY | 4       | const                                  |    1 |   100.00 | NULL  |
|  1 | SIMPLE      | orders       | NULL       | const  | PRIMARY,customerNumber | PRIMARY | 4       | const                                  |    1 |   100.00 | NULL  |
|  1 | SIMPLE      | payments     | NULL       | ref    | PRIMARY                | PRIMARY | 4       | const                                  |    1 |   100.00 | NULL  |
|  1 | SIMPLE      | orderdetails | NULL       | ref    | PRIMARY,productCode    | PRIMARY | 4       | const                                  |    1 |   100.00 | NULL  |
|  1 | SIMPLE      | products     | NULL       | eq_ref | PRIMARY,productLine    | PRIMARY | 17      | classicmodels.orderdetails.productCode |    1 |   100.00 | NULL  |
|  1 | SIMPLE      | productlines | NULL       | eq_ref | PRIMARY                | PRIMARY | 52      | classicmodels.products.productLine     |    1 |   100.00 | NULL  |
+----+-------------+--------------+------------+--------+------------------------+---------+---------+----------------------------------------+------+----------+-------+
6 rows in set, 1 warning (0.00 sec)
*/