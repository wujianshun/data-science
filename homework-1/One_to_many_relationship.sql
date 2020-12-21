-- Report the account representative for each customer.
select distinct(customerNumber)  
from
	payments p 
join 
	customers c
using(customerNumber);
-- Report total payments for Atelier graphique.

select 
	customerName,
	sum(amount)
from
	payments p 
join 
	customers c
using(customerNumber)
where customerName = 'Atelier graphique';
-- Report the total payments by date
select
	paymentDate,
    sum(amount) as total
from payments
group by paymentDate;
-- Report the products that have not been sold.
select 
	productName
from 
	orderdetails o
right join 
	products p 
using(productCode)
where o.quantityOrdered is null ;
-- List the amount paid by each customer.
select 
	customerNumber,
    sum(amount) as total_paid
from 
	customers 
join 
	payments 
	using(customerNumber)
 group by 
	customerNumber;
-- How many orders have been placed by Herkku Gifts?
select
	count(*) as 'number of orders'
from customers c, orders o
where
	c.customerNumber = o.customerNumber and 
	c.customerName = 'Herkku Gifts'; 
-- Who are the employees in Boston?
select
	city,
	concat(firstName,lastName) as name
from 
	employees e
join
	offices o
using(officeCode)
where  o.city = 'boston';
-- Report those payments greater than $100,000. 
-- Sort the report so the customer who made the highest payment appears first.
select 
	customerName,
    sum(amount) as total
from 
	customers c
join 
	payments
using (customerNumber)
group by customerName
having total > 100000
order by total desc;
-- List the value of 'On Hold' orders
select
	sum(quantityOrdered * priceEach) as 'Value of On hold'
from 
	orders o
right join 
	orderdetails od 
using(orderNumber)
where o.status = 'on hold'; 
-- Report the number of orders 'On Hold' for each customer.
select
	customerNumber,
    customerName,
	sum(quantityOrdered * priceEach) as 'Value of On hold'
from 
	orderdetails as od 
join 
	orders o
		using(ordernumber)
join
	customers c
		using(customerNumber)
where o.status = 'on hold'
group by customerNumber,customerName; 