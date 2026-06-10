-- Cumulitave Analysis

-- Calculate the total sales per month

-- and the running total of sales over time


select sales_per_month, total_sales, sum(total_sales) over(order by sales_per_month) as running_total_sale

from

(select datetrunc (month, order_date) as sales_per_month, sum(sales_amount) as total_sales

from gold.fact_sales

where order_date is not null

group by  datetrunc (month, order_date)) t



with running_total as

(

select DATETRUNC(month, order_date) as month_order, sum(sales_amount) as total_sales, 

avg(sales_amount) as moving_avg from gold.fact_sales

where DATETRUNC(month, order_date) is not null

group by DATETRUNC(month, order_date)

)

select month_order, total_sales, sum(total_sales) over(partition by month_order order by month_order) as monthly_sales ,

avg(moving_avg) over(partition by month_order order by month_order) as avg_sales from running_total