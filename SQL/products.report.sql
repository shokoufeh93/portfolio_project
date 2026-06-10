
/*
===============================================================
Product Report
===============================================================

Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:

    1. Gathers essential fields such as product name, category, subcategory, and cost.

    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.

    3. Aggregates product-level metrics:
        - total orders
        - total sales
        - total quantity sold
        - total customers (unique)
        - lifespan (in months)

    4. Calculates valuable KPIs:
        - recency (months since last sale)
        - average order revenue (AOR)
        - average monthly revenue

===============================================================
*/

create view gold.report_products as

WITH PRODUCTS_INFO AS

(
select p.product_name, p.category, p.subcategory, p.cost, f.order_number, f.sales_amount,

f.quantity, c.customer_id, f.order_date from gold.dim_products p

left join gold.fact_sales f on p.product_key = f.product_key

left join gold.dim_customers c on c.customer_key = f.customer_key

where order_date is not null

)

, Aggregates_product_level_metrics as

(
 select  product_name, category, subcategory, cost, count(order_number) as total_orders, 
 
 sum(sales_amount) as total_sales, sum(quantity) as total_quantity_sold, count(distinct(customer_id)) as total_customers,max(order_date) as last_order

 , datediff(month, min(order_date), max(order_date)) as lifespan, round(AVG(cast(sales_amount as float) / nullif(quantity, 0)),1) as avg_sell_price
 
 from PRODUCTS_INFO

 group by product_name, category, subcategory, cost)

 SELECT *,
 
 case 

 when total_sales > 50000 then 'High-Performers'

 when total_sales > 10000 then 'Mid-Range'

 else 'Low_performances'

 end as Segments_products,

 DATEDIFF(MONTH, last_order, GETDATE()) as recency,

 case

 when total_orders = 0 then 0

 else total_sales / total_orders 

 end as average_order_revenue,

 case

 when lifespan = 0 then 0

 else total_sales / lifespan

 end as average_monthly_revenue

 FROM Aggregates_product_level_metrics  