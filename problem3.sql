/*
Problem 3
Create a transaction which does the following things:
Create a new customer
New customer places an order for a motorcyle
And finally does the payment.
*/

start transaction;

/*Selecting the new customer*/
select
    @customerNumberNew:=max(customerNumber)+1
from
    customers;
/*
+-------------------------------------------+
| @customerNumberNew:=max(customerNumber)+1 |
+-------------------------------------------+
|                                       506 |
+-------------------------------------------+
1 row in set (0.00 sec)

Query OK, 1 row affected (0.00 sec)
*/


/*Inserting a new customer in Customer table*/
insert into customers(customerNumber,customerName, contactLastName, contactFirstName, phone, addressLine1, city, country)
values(@customerNumberNew,"Random Customer","Last","First",'999999999',"Dream11 office,Mumbai","Mumbai","India");


/*Selecting a new orderNumber for the new customer*/
select
    @orderNumberNew:=max(orderNumber)+1
from
    orders;
/*
+-------------------------------------+
| @orderNumberNew:=max(orderNumber)+1 |
+-------------------------------------+
|                               10435 |
+-------------------------------------+
1 row in set (0.00 sec)

Query OK, 1 row affected (0.00 sec)
*/


/* Selecting the maximum price bike*/
select
    @motorCycleCode:= productCode,
    @price:=max(buyPrice)
from products where productLine="Motorcycles" limit 1;
/*
+-------------------------------+-----------------------+
| @motorCycleCode:= productCode | @price:=max(buyPrice) |
+-------------------------------+-----------------------+
| S10_1678                      |                 91.02 |
+-------------------------------+-----------------------+
1 row in set (0.00 sec)

Query OK, 1 row affected (0.00 sec)
*/

/*Inserting a new entry in order details*/
insert into orders(orderNumber,orderDate,requiredDate,status,customerNumber)
values(@orderNumberNew,current_date(),"2020-10-27","In Process",@customerNumberNew);

/*Inserting entry in orderdetails and fixing number of motorcyles bought=5*/
insert into orderdetails(orderNumber,productCode,quantityOrdered,priceEach,orderLineNumber)
values(@orderNumberNew,@motorCycleCode,5,@price,1);


select 
    @quantity:=quantityOrdered
from orderdetails where orderNumber=@orderNumberNew;
/*
+----------------------------+
| @quantity:=quantityOrdered |
+----------------------------+
|                          5 |
+----------------------------+
1 row in set (0.00 sec)

Query OK, 1 row affected (0.00 sec)
*/


/*Inserting entry in payments table*/
insert into payments(customerNumber,checkNumber,paymentDate,amount)
values(@customerNumberNew,"HR210012",current_date(),@price*@quantity);

commit;