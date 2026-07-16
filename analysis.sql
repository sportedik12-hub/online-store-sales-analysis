CREATE TABLE orders (
    InvoiceNo TEXT,
    StockCode TEXT,
    Description TEXT,
    Quantity NUMERIC,
    InvoiceDate TIMESTAMP,
    UnitPrice NUMERIC,
    CustomerID NUMERIC,
    Country TEXT
);



select 
	o.invoiceno,
	o.customerid,
	o.country,
	o.invoicedate,
	SUM(o.quantity * o.unitprice ) as order_amount
from orders o
where o.invoiceno like 'C%'
group by
	o.invoiceno,
	o.customerid,
	o.country,
	o.invoicedate
order by order_amount desc;




select 
	count(distinct o.invoiceno )as order_count,
	o.customerid,
	o.country,
	SUM(o.quantity * o.unitprice ) as order_amount,
	AVG(o.quantity * o.unitprice ) as middle_price
from orders o
group by 
	o.customerid,
	o.country
having count(distinct o.invoiceno ) > 5 
order by order_amount desc;



select 
	o.description,
	SUM(o.quantity  ) as product_count,
	SUM(o.quantity * o.unitprice ) as revenue,
	AVG(o.unitprice) as avg_price,
	case 
		when AVG(o.unitprice) >= 6 then 'expensive'
		when AVG(o.unitprice) between 3 and 5 then 'medium'
		else 'cheap'
	end as segment
from orders o 
group by
	o.description 
order by 
	case 
		when AVG(o.unitprice) >= 6 then 1
		when AVG(o.unitprice) between 3 and 5 then 2
		else 3
	end,
	revenue desc;
	



select 
	o.description,
	SUM(o.quantity * o.unitprice ) as revenue,
	count(o.unitprice ) as count_sale
from orders o 
group by o.description 
order by revenue desc
limit 10;



with rating_clients as (
    select
        CustomerID,
        SUM(Quantity * UnitPrice) as revenue,
        COUNT(distinct InvoiceNo) as order_count
    from orders
    where CustomerID IS NOT NULL
    group by CustomerID)
SELECT
    CustomerID,
    revenue,
    order_count,
    RANK() over(order by revenue desc) as rating,
    ROUND(revenue * 100.0 /SUM(revenue) over (),2)
    as percent_user_revenue
from rating_clients
order by revenue desc;




with client_countries as (
    select
        customerid,
        country,
        sum(quantity * unitprice) as sum_purchase
    from orders
    where customerid is not null
    group by customerid, country)
select
    customerid,
    country,
    sum_purchase,
    avg(sum_purchase) over(partition by country) as avg_country,
    dense_rank() over(partition by country order by sum_purchase desc) as rate,
    case
        when sum_purchase >= 600 then 'vip'
        when sum_purchase between 300 and 599 then 'regular'
        else 'low'
    end as segment
from client_countries
order by country, rate;



with purchase_time as (
		select 
			o.invoiceno ,
			o.invoicedate,
			SUM(o.quantity * o.unitprice ) as sum_order
		from orders o 
		group by 
			o.invoiceno ,
			o.invoicedate)
select 
	invoiceno ,
	invoicedate,
	sum_order,
	SUM(sum_order) over(order by invoicedate) as nakopit_revenue,
	AVG(sum_order) over(order by invoicedate) as revenue_now,
	row_number() over(order by invoicedate) as num_ord
from purchase_time
order by invoicedate;
	



with analysis_products as (
			select 
				o.description,
				o.stockcode,
				SUM(o.quantity * o.unitprice ) as revenue
			from orders o 
			group by 
				o.description,
				o.stockcode)
select 
	description,
	stockcode,
	revenue,
	rank() over(order by revenue desc ) as rate,
	round(revenue * 100 / SUM(revenue) over() ,2) as perc_product,
	case 
		when revenue >= 600 then 'top'
		when revenue between 300 and 599 then 'middle'
		else 'low'
	end as segment
from analysis_products
order by revenue desc;
				
				

with valuable_users as (
			select
				o.customerid,
				o.country,
				o.unitprice,
				SUM(o.quantity * o.unitprice) as revenue,
				count(distinct o.invoiceno) as order_count,
				avg(o.quantity * o.unitprice) as avg_check
			from orders o 
			group by 
				o.customerid,
				o.country)
select
	customerid,
	country,
	revenue,
	rank() over(order by revenue desc) as rate,
	dense_rank() over(partition by country order by revenue desc) as rate_country,
	round(revenue * 100.0 / sum(revenue) over(),2) as percent_revenue,
	sum(revenue) over(order by revenue desc) as cumulative_revenue,
	case 
		when revenue >=  650 then 'vip'
		when revenue between  400 and 649 then 'gold'
		when revenue between 200 and 399 then 'silver'
		else 'regular'
	end as segment
from valuable_users
order by revenue desc;