-- List products sold by order date.
select 
	orderDate,
    productName
from orders 
join 
	orderdetails 
		using(orderNumber)
join
	products 
		using(productCode)
order by orderDate;

-- List the order dates in descending order for orders for the 1940 Ford Pickup Truck.
select orderDate,
	   productName
from 
	products p
join
	orderdetails
    using(productCode)
join
	orders
    using(orderNumber)
where p.productName like '%1940 Ford Pickup Truck%'
order by orderDate desc;
-- List the names of customers and their corresponding order number where a particular order from that customer has a value greater than $25,000?
select
	customerName,
    orderNumber, 
	amount
from
	orders 
join
	customers using(customerNumber)
join
	payments using(customerNumber)
where
	amount >=25000;
-- Are there any products that appear on all orders?
select
	productName
from 
	orders 
left join
	orderdetails using(orderNumber)
join
	products using(productCode)	
group by productName;
-- List the names of products sold at less than 80% of the MSRP.
select
	productName
from 
	orders 
left join
	orderdetails using(orderNumber)
join
	products using(productCode)	
where 
	08*MSRP > priceEach
group by productName;
-- Reports those products that have been sold with a markup of 100% or more (i.e.,  the priceEach is at least twice the buyPrice)
select
	productName
from 
	orders 
left join
	orderdetails using(orderNumber)
join
	products using(productCode)	
where 
	priceEach >= 2*buyPrice
group by productName;
-- List the products ordered on a Monday.
select
	productName
from 
	orders 
left join
	orderdetails using(orderNumber)
join
	products using(productCode)	
where 
	weekday(orderDate) = 0
group by productName;
-- What is the quantity on hand for products listed on 'On Hold' orders?
select 
	productName,
    quantityOrdered
from 
	orders 
left join
	orderdetails using(orderNumber)
join
	products using(productCode)	
where status = 'On hold'; 