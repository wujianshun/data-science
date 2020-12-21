-- Who is at the top of the organization (i.e.,  reports to no one).
select *
from employees e
where e.reportsTo is Null;
-- Who reports to William Patterson?
select
	e.employeeNumber,
    e.firstName,
    e.lastName,
    concat(r.firstName,' ',r.lastName) as reportsName
from
	employees e
join 
	employees r
on e.reportsTo = r.employeeNumber
where concat(r.firstName,' ',r.lastName) = 'William Patterson';
-- List all the products purchased by Herkku Gifts.
select
	orderNumber,
	productName
from orderdetails 
join products using(productCode)
where  orderNumber 
 in (select
	distinct(orderNumber)
from 
	customers c
join
	orders using(customerNumber)
where
	customerName = 'Herkku Gifts') ;
-- Compute the commission for each sales representative, assuming the commission is 5% of the value of an order. 
-- Sort by employee last name and first name.
select 
	lastName,
    firstName,
    temp.commission
from 
	(select
		salesRepEmployeeNumber,
		sum(amount)*0.05 as commission
	from customers c 
	join payments using(customerNumber)
	group by salesRepEmployeeNumber) temp,employees e
where
	e.employeeNumber = temp.salesRepEmployeeNumber
order by lastName,firstName;
-- What is the difference in days between the most recent and oldest order date in the Orders file?
select
	day(max(orderDate)-min(orderDate)) as difference
from 
	orders;
-- Compute the average time between order date and ship date for each customer ordered by the largest difference.
select
	customerNumber,
    max(shippedDate-orderDate) as Maxdifference,
	avg(shippedDate-orderDate) as Avgdifference
from orders 
group by customerNumber
order by Maxdifference;
-- What is the value of orders shipped in August 2004? (Hint).
select
    sum(quantityOrdered*priceEach) as value_of_orders 
from orders 
join orderdetails using(ordernumber)
where date_format(shippedDate,'%M%Y') = 'August2004';
-- Compute the total value ordered, total amount paid, and their difference 
-- for each customer for orders placed in 2004 and payments received in 2004 

		
 with cte1 as(
        select 
			customerNumber,
            sum(quantityOrdered*priceEach) as total_ordered
		 from orders
         join orderdetails using(orderNumber)
         where year(orderDate) = 2004 
         group by customerNumber
         ),
cte2 as (
		select 
			customerNumber,
            sum(amount) as total_paid
		from payments
        where year(paymentDate) ='2004'
        group by customerNumber
		)
select
	*,
    cte1.total_ordered - cte2.total_paid as difference
from
	cte1,cte2
where cte1.customerNumber = cte2.customerNumber;
-- List the employees who report to those employees who report to Diane Murphy.
-- Use the CONCAT function to combine the employee's first name and last name into a single field for reporting.
select 
	concat(e.firstName,' ',e.lastName) as whoReports, 
	concat(m.firstName,' ',m.lastName) as reportsToWho
from 
	employees e
left join 
	employees m
on e.reportsTo = m.employeeNumber
where concat(m.firstName,' ',m.lastName) = 'Diane Murphy';
-- What is the percentage value of each product in inventory sorted by the highest percentage first (Hint: Create a view first).

with cte1 as
	(select 
	sum(MSRP*quantityInStock) as total_value
    from products)
select 
	productName,
	quantityInStock*MSRP/(select total_value from cte1) as percentage
from
	products
order by percentage desc;
-- Write a function to convert miles per gallon to liters per 100 kilometers.
-- Write a procedure to increase the price of a specified product category by a given percentage. You will need to create a product table with appropriate data to test your procedure. Alternatively, load the ClassicModels database on your personal machine so you have complete access. You have to change the DELIMITER prior to creating the procedure.
-- What is the value of orders shipped in August 2004? (Hint).
select
	sum(quantityOrdered*priceEach) as total_shipped_value 
from 
	orders 
join
	orderdetails using(ordernumber)
where status = 'shipped' and date_format(shippedDate,'%M%Y')='August2004';
-- What is the ratio the value of payments made to orders received for each month of 2004. 
-- (i.e., divide the value of payments made by the orders received)

select 
	month(paymentDate) as Month,
	sum(amount)/sum((quantityOrdered*priceEach)) as ratio
from orders 
join payments using(customerNumber)
join orderdetails using(ordernumber)
where year(paymentDate) = '2004'
group by month(paymentDate)
order by Month;
-- What is the difference in the amount received for each month of 2004 compared to 2003?
with cte1 as (
select
	month(paymentDate) as Month,
	sum(amount) as total_payments
from payments
where year(paymentDate) = '2003'
group by month(paymentDate)
order by Month(paymentDate)
),
cte2 as (
select
	month(paymentDate) as Month,
	sum(amount) as total_payments
from payments
where year(paymentDate) = '2004'
group by month(paymentDate)
order by Month(paymentDate)
)
select
	cte1.Month,
    cte2.total_payments- cte1.total_payments as difference 
from cte1,cte2
where cte1.Month = cte2.Month;
-- Write a procedure to report the amount ordered in a specific month and year for customers containing a specified character string in their name.
-- Write a procedure to change the credit limit of all customers in a specified country by a specified percentage.
-- Basket of goods analysis: A common retail analytics task is to analyze each basket or order to learn what products are often purchased together. 
-- Report the names of products that appear in the same order ten or more times.
select
	orderNumber,
    productName,
    quantityOrdered
from 
	orders 
join
	orderdetails using(orderNumber)
join
	products using(productCode)
where quantityOrdered >=10
order by orderNumber,productName;
-- ABC reporting: Compute the revenue generated by each customer based on their orders. 
-- Also, show each customer's revenue as a percentage of total revenue. Sort by customer name.
with total as 
(
	select sum(priceEach*quantityOrdered) as total
    from orders 
    join orderdetails using(orderNumber)
)

select
	customerName,
	sum(priceEach*quantityOrdered) as total_for_each,
    sum(priceEach*quantityOrdered)/(select * from total) as pct
from orders 
join orderdetails using(orderNumber)
join customers using(customerNumber)
group by customerName 
order by customerName;
-- Compute the profit generated by each customer based on their orders. Also, show each customer's profit as a percentage of total profit. 
-- Sort by profit descending.
with total as 
(
	select sum((priceEach-buyPrice)*quantityOrdered) as total_profit
    from orders 
    join orderdetails using(orderNumber)
    join products using(productCode)
)

select
	customerName,
    orderNumber,
	sum((priceEach-buyPrice)*quantityOrdered) as total_profit_for_each,
    sum((priceEach-buyPrice)*quantityOrdered)/(select * from total) as pct
from orders 
join orderdetails using(orderNumber)
join customers using(customerNumber)
join products using(productCode)
group by customerName,orderNumber 
order by customerName,pct Desc;
-- Compute the revenue generated by each sales representative based on the orders from the customers they serve.

select  salesRepEmployeeNumber,
		customerNumber,
        customerName,
        sum(priceEach*quantityOrdered) as total_for_each
from customers 
right join
	orders using(customerNumber)
join orderdetails using(orderNumber)
group by salesRepEmployeeNumber,customerNumber;
-- Compute the profit generated by each sales representative based on the orders from the customers they serve. 
-- Sort by profit generated descending.

select  salesRepEmployeeNumber,
		customerNumber,
        customerName,
        orderNumber,
        sum((priceEach-buyPrice)*quantityOrdered) as total_profit_for_each
from customers 
right join
	orders using(customerNumber)
join orderdetails using(orderNumber)
join products using(productCode)
group by salesRepEmployeeNumber,customerNumber,orderNumber
order by total_profit_for_each desc;
-- Compute the revenue generated by each product, sorted by product name.

select
	productCode,
    productName,
	sum(priceEach*quantityOrdered) as revenue_for_each_product
from 
	 orders 
join orderdetails using(orderNumber)
join products using(productCode)
group by productCode
order by productName;
-- Compute the profit generated by each product line, sorted by profit descending.
select
	productLine,
	sum((priceEach-buyPrice)*quantityOrdered) as profit
from 
	 orders 
join orderdetails using(orderNumber)
join products using(productCode)
group by productLine
order by profit desc;
-- Same as Last Year (SALY) analysis: Compute the ratio for each product of sales for 2003 versus 2004.
with sales_2003 as 
(select
	productCode,
    productName,
	sum(priceEach*quantityOrdered) as revenue_for_each_product
from 
	 orders 
join orderdetails using(orderNumber)
join products using(productCode)
where year(orderDate) = '2003'
group by productCode
order by productName),
sales_2004 as 
(select
	productCode,
    productName,
	sum(priceEach*quantityOrdered) as revenue_for_each_product
from 
	 orders 
join orderdetails using(orderNumber)
join products using(productCode)
where year(orderDate) = '2004'
group by productCode
order by productName
)
select 
	productName,
    sales_2004.revenue_for_each_product-sales_2003.revenue_for_each_product as difference 
from 
	 sales_2003
join sales_2004 using(productName);
-- Compute the ratio of payments for each customer for 2003 versus 2004.

with payment_ratio_2003 as
(
select
	customerNumber,
    sum(amount)/(select sum(amount)from payments where year(paymentDate)='2003') as total_pay_ratio
from payments
where year(paymentDate) = '2003'
group by customerNumber 
order by customerNumber 
),
payment_ratio_2004 as(
select
	customerNumber,
    sum(amount)/(select sum(amount)from payments where year(paymentDate)='2004') as total_pay_ratio
from payments
where year(paymentDate) = '2004'
group by customerNumber 
order by customerNumber 
)

select
	customerNumber,
    payment_ratio_2004.total_pay_ratio-payment_ratio_2003.total_pay_ratio as diff
from
	payment_ratio_2003
join payment_ratio_2004 using(customerNumber);
-- Find the products sold in 2003 but not 2004.

select 
	distinct(productName)
from orders
join orderdetails using(orderNumber)
join products using(productCode)
where year(orderDate) = '2003' 
and productName not in(
	select 
	distinct(productName)
	from orders
	join orderdetails using(orderNumber)
	join products using(productCode)
	where year(orderDate) = '2004');
-- Find the customers without payments in 2003.
select 
	customerNumber,
    customerName
from 
	customers
left join
	(select customerNumber,
			amount 
     from payments
     where year(paymentDate) = '2003'
		) as t using(customerNumber)
where amount is null;














