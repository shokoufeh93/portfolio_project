
-- analyze the yearly performance of products by comparing each product's sales to both:

-- its average sales performance and the previous years's sales.

with analyze_yearly_performance as

(
select year(f.order_date) as order_year, p.product_name, sum(f.sales_amount) as total_sales

from gold.fact_sales f

left join gold.dim_products p on f.product_key = p.product_key

where year(f.order_date) is not null

group by  year(f.order_date), p.product_name
)

select order_year, product_name, total_sales, avg(total_sales) over(partition by product_name)

as average_sales, total_sales - avg(total_sales) over(partition by product_name) as diff_total_avg,

case

when  total_sales - avg(total_sales) over(partition by product_name) > 0  then 'above the avg'

when  total_sales - avg(total_sales) over(partition by product_name) < 0  then 'below the avg'

else  'avg'

end as avg_change,

lag(total_sales)over(partition by product_name order by order_year) as per_year_sale ,

total_sales - lag(total_sales)over(partition by product_name order by order_year) as diff_curr_per,

case 

when total_sales - lag(total_sales)over(partition by product_name order by order_year) > 0  then 'increase'

when total_sales - lag(total_sales)over(partition by product_name order by order_year) < 0  then 'decrease'

else 'no_change'

end as diff_change

from analyze_yearly_performance



-- which categories contribute the most to overall sales


 with categories_contribute as

 (

 select p.category, sum(f.sales_amount) as total_sales from gold.fact_sales f

 left join gold.dim_products p on f.product_key = p.product_key

 group by p.category

 )

 select category, total_sales, sum(total_sales) over() as overall_sales ,

 concat(round((cast(total_sales as float) / sum(total_sales) over()) * 100, 2), '%') as percentage_of

 from categories_contribute

 order by total_sales desc