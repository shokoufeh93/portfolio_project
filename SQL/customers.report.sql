

/*
====================================================================
Customer Report
====================================================================

Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:

1. Gathers essential fields such as names, ages, and transaction details.

2. Segments customers into categories (VIP, Regular, New) and age groups.

3. Aggregates customer-level metrics:
    - total orders
    - total sales
    - total quantity purchased
    - total products
    - lifespan (in months)

4. Calculates valuable KPIs:
    - recency (months since last order)
    - average order value
    - average monthly spend

====================================================================
*/

create view gold.report_customers AS


with cutomer_info as

(

select  c.customer_key, c.customer_number, f.order_date, f.order_number, CONCAT(c.first_name,' ', c.last_name) as full_name,

f.product_key, f.sales_amount, f.quantity, datediff(year,c.birthdate, getdate()) as age from gold.fact_sales f

left join gold.dim_customers c on f.customer_key = c.customer_key)

, customer_agg as

(

select  customer_key, customer_number, full_name, age, count(order_number) AS total_orders,  count(product_key) as total_products, 

sum(sales_amount) as transaction_detail, sum(quantity) as total_quantity_purchased,min(order_date),max(order_date) as last_order,

datediff(month, min(order_date), max(order_date)) as lifespan from cutomer_info 

group by   customer_key, customer_number, full_name, age )


SELECT *,

case 

when transaction_detail > 5000 then 'VIP'

when transaction_detail < 5000 then 'Regular'

else 'new'

end as customers_categories , 

case

when  age < 35 then 'young'

when  age between 35 and 55 then 'middle_age'

else 'old'

end as age_segment

, datediff(month, last_order, getdate()) as recency,

case

when lifespan = 0 then transaction_detail

else transaction_detail / lifespan 

end as average_monthly_spend

from customer_agg
