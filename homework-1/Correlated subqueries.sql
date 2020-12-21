-- Who reports to Mary Patterson?
select
	concat(firstName,' ',lastName) as whoReport,
    reportsTo
from employees e
where reportsTo = (
		select employeeNumber 
        from employees
        where e.reportsTo  = employeeNumber
        and concat(firstName,' ',lastName) = 'Mary Patterson'
);
-- Which payments in any month and year are more than twice the average for that month and year (i.e. compare all payments in Oct 2004 with the average payment for Oct 2004)? Order the results by the date of the payment. You will need to use the date functions.
select
	paymentDate,
    amount
from payments p
where amount>2*(
	select 
		avg(amount) 
	from payments 
    where 
		year(p.paymentDate) = year(paymentDate)
		and 
		month(p.paymentDate) = month(paymentDate)
);
-- Report for each product, the percentage value of its stock on hand as a percentage of the stock on hand for product line to which it belongs.
--  Order the report by product line and percentage value within product line descending. Show percentages with two decimal places.
with pct as (
	select productName,
		   productLine,
		   quantityInStock/sum(quantityInStock)over(partition by productLine) as pct_productLine_stock,
           quantityInStock*buyPrice/sum(quantityInStock*buyPrice)over(partition by productLine) as pct_productLine_stock_value
    from products
)
select
		*
from pct
where round(pct_productLine_stock,2) = round(pct_productLine_stock_value,2)
order by productLine, pct_productLine_stock_value desc;
-- For orders containing more than two products, report those products that constitute more than 50% of the value of the order.
with two_more as
(
 select orderNumber
 from orders 
	join orderdetails using(orderNumber)
 group by orderNumber
 having count(*) >=2
)
select 
	productCode
from orderdetails o
join two_more using(orderNumber) 
where quantityOrdered*priceEach>0.5*(
		select
			sum(quantityOrdered*priceEach)
		from 
			orderdetails 
		where orderNumber = o.orderNumber
)






