-- Find products containing the name 'Ford'.
select
	productName
from 
	products 
where productName like '%Ford%';
-- List products ending in 'ship'.
select
	productName
from 
	products 
where productName like '%ship';
-- Report the number of customers in Denmark, Norway, and Sweden.
select 
	country,
	count(distinct(customerNumber)) as 'number of customers'
from customers
where country in ('Denmark','Norway','Sweden')
group by country;
-- What are the products with a product code in the range S700_1000 to S700_1499?
select 
	productCode,
	productName
from 
	products 
where
	substring(productCode,1,5) = 'S700_'
    and (convert(substring(productCode,6),unsigned int) between 1000 and 1499 );
-- Which customers have a digit in their name?
select 
	customerName
from customers 
where  customerName regexp '[0-9]{1}';
-- List the names of employees called Dianne or Diane.
select
	firstName,
    lastName 
from employees
where firstName in ('Dianne','Diane') or lastName in ('Dianne','Diane');
-- List the products containing ship or boat in their product name.
select
	productName
from 
	products
where 
	productName like '%boat%' or productName like '%ship%';
-- List the products with a product code beginning with S700.
select 
	productCode,
    productName
from 
	products 
where 
	productCode like 'S700%';
-- List the names of employees called Larry or Barry.
select 
	lastName,
    firstName
from 
	employees
where lastName in ('Larry','Barry') or firstName in ('Larry','Barry');
-- List the names of employees with non-alphabetic characters in their names.
select 
	lastName,
    firstName
from 
	employees
where lastName regexp '[^a-zA-Z]+'or firstName regexp'[^a-zA-Z]+';
-- List the vendors whose name ends in Diecast
select 
	productVendor
from products 
where productVendor like '%Diecast';