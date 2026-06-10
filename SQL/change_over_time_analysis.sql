-- the sales performance over time

select  year(order_date) , month(order_date) as order_month, sum(sales_amount) as total_sale ,

count(distinct(customer_key)) as total_customers ,count(quantity) as total_sold from gold.fact_sales

where order_date is not null

group by  year(order_date) ,month(order_date)

order by  year(order_date) ,month(order_date);

-- year and month in one column

select  DATETRUNC(month, order_date), sum(sales_amount) as total_sale ,

count(distinct(customer_key)) as total_customers ,count(quantity) as total_sold from gold.fact_sales

where order_date is not null

group by  DATETRUNC(month, order_date)

order by  DATETRUNC(month, order_date)