use DataWarehouseAnalytics;

/* segment products into cost ranges and count how many

products fall into each segment */



with product_segment as

(

select product_name, cost,

case 

when cost < 500 then 'low_cost'

when cost between 500 and 1500 then 'med_cost'

else 'high_cost'

end as cost_segmention

from gold.dim_products

)

select cost_segmention, count(product_name)  as products_in_each_segment from product_segment

GROUP BY cost_segmention

order by cost_segmention 


/* group customers into three segments based on their spending behavior:

Vip: customers with at least 12 months of history and spending more than 5000
Regular: customers with at least 12 months of history but spending 5000 or less than 5000
New: customers with a lifespan less than 12 monthes

and find the total number of customers by each group */


with customers_spending_behavior as

(

select c.customer_key, sum(f.sales_amount) as total_spending, min(f.order_date) as first_order , max(f.order_date) as last_order

,DATEDIFF(month, min(f.order_date), max(f.order_date)) as life_span

from gold.fact_sales f

left join gold.dim_customers c on f.customer_key = c.customer_key

group by  c.customer_key

)

select customers_segments, count(customer_key) from

(select customer_key,

case 

when total_spending > 5000 and life_span >= 12  then 'Vip'

when total_spending <= 5000 and life_span >= 12  then 'Regular'

else 'new'

end as customers_segments 

from customers_spending_behavior

where life_span is not null

) t

group by customers_segments desc





