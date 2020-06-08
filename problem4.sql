#Problem 4
/*
  In continuation to problem 3, On a website, this new customer(created during the transaction) needs to see the invoice details, make a query that showcases the following data: Customer Name, orderNumber, shippedDate, payment date, amount, quantity ordered, productName, image of the productLine.
Use explain statement to refine your query.
*/

/*Selecting the recent customer and his ordernumber*/
select 
    @recentCustomerNumber:=max(customerNumber) 
from customers;
select 
    @recentOrderNumber:= orderNumber from orders where customerNumber=@recentCustomerNumber;


select customers.customerName,orders.orderNumber,shippedDate,paymentDate,amount,quantityOrdered,productName,image
from payments join customers join orders join orderdetails join products join productlines
on payments.customerNumber=customers.customerNumber 
&& customers.customerNumber=orders.customerNumber 
&& customers.customerNumber=@recentCustomerNumber 
&& orders.orderNumber=orderdetails.orderNumber 
&& orders.orderNumber=@recentOrderNumber 
&& orderdetails.productCode=products.productCode 
&& products.productLine=productlines.productLine;

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