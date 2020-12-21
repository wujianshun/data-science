-- Prepare a list of offices sorted by country, state, city.
select *
from offices o
order by o.country desc,o.state, o.city;
-- How many employees are there in the company?
select 
	count(distinct(e.employeeNumber)) as 'Number of employees'
from
	employees e;
-- What is the total of payments received?
select sum(amount) as total_payments 
from payments;
-- List the product lines that contain 'Cars'
select distinct productLine
from 
	products
where productLine like '%Cars%';
-- Report total payments for October 28, 2004.
select sum(amount) as total_payments 
from payments
where paymentDate = '2004-10-28';
-- Report those payments greater than $100,000.
select *
from payments
where amount>100000;
-- List the products in each product line.
select 
	productLine,
	productName
from  products   
order by productLine;
-- How many products in each product line?
select 
	productLine,
	count(productName)
from  products   
group by productLine;
-- What is the minimum payment received?
select min(amount) as 'minimum payment'
from payments;
-- List all payments greater than twice the average payment.
select amount 
from payments 
where 
	amount > 2*(
    select avg(amount)
    from payments 
    );
-- What is the average percentage markup of the MSRP on buyPrice?
select 
	avg(buyPrice/MSRP) as 'avg_percentage'
from products;
-- How many distinct products does ClassicModels sell?
select
	count(distinct(productCode))
from products;
-- Report the name and city of customers who don't have sales representatives?
select 
	customerName,
    city
from customers c
where c.salesRepEmployeeNumber is null;
-- What are the names of executives with VP or Manager in their title?
-- Use the CONCAT function to combine the employee's first name and last name into a single field for reporting.
select
	concat(firstName,lastName) as name ,
    e.jobTitle
from employees e  
where e.jobTitle like '%VP%' or e.jobTitle like '%Manager%';
-- Which orders have a value greater than $5,000?
select *
from (select 
	orderNumber,
    sum(quantityOrdered * priceEach) as total_price
from 
	orderdetails 
group by orderNumber) t
where t.total_price >5000

