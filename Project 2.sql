## Lấy tổng số lượng khách hàng và tổng số order hoàn thành:
select  FORMAT_TIMESTAMP('%Y-%m', created_at) as month, count(distinct user_id) as total_users,count(order_id) as total_orders
from bigquery-public-data.thelook_ecommerce.orders 
where FORMAT_TIMESTAMP('%Y-%m', created_at) <= '2022-04' and status = "Complete"
group by 1
order by 1
2. 
select FORMAT_TIMESTAMP('%Y-%m', created_at) as month, count(distinct user_id) as total_users, avg(sale_price)
from bigquery-public-data.thelook_ecommerce.order_items
where FORMAT_TIMESTAMP('%Y-%m', created_at) <= '2022-04'
group by 1
order by 1
3.
With tb1 as(
select first_name,last_name, age,gender, 
case when age = min(age) over(partition by gender order by age) then "Youngest" 
when age = max(age) over (partition by gender order by age desc) then "Oldest"
end as tag 
from bigquery-public-data.thelook_ecommerce.users
Where fORMAT_TIMESTAMP('%Y-%m', created_at) <= '2022-04')
select gender, tag, age, count(*)
from tb1 
where tag = 'Oldest' or tag = "Youngest"
group by gender,tag,age
4.
With tb1 as(
select FORMAT_TIMESTAMP('%Y-%m', created_at) as month,p.id,p.name,sum(sale_price), sum(cost), sum(sale_price) - sum(cost) as profit
from bigquery-public-data.thelook_ecommerce.products as p 
join bigquery-public-data.thelook_ecommerce.order_items as o
on p.id = o.product_id
where status = "Complete"
group by 1,2,3
order by 1,2), tb2 as(
select *, dense_rank() over (partition by month order by tb1.profit desc) as rank_
from tb1)
select *
from tb2 
where rank_ <= 5
order by month,rank_
5. 
select FORMAT_TIMESTAMP('%Y-%m-%d', created_at) as date, category,sum(sale_price) as revenue
from bigquery-public-data.thelook_ecommerce.products as p 
join bigquery-public-data.thelook_ecommerce.order_items as o
on p.id = o.product_id
where status = "Complete" and FORMAT_TIMESTAMP('%Y-%m-%d', created_at) between '2022-01-15' and '2022-04-15'
group by 1,2
order by 1,2
II. Lập Dataset cho Dashboard:
Create view vw_ecommerce_analyst as(
With tb1 as (select distinct FORMAT_TIMESTAMP('%Y-%m', created_at) as month, 
extract(year from created_at) as year, 
sum(sale_price) over(partition by FORMAT_TIMESTAMP('%Y-%m', created_at)) as TPV,
count(order_id) over(partition by FORMAT_TIMESTAMP('%Y-%m', created_at)) as TPO,
sum(cost) over (partition by FORMAT_TIMESTAMP('%Y-%m', created_at))as total_cost,
from bigquery-public-data.thelook_ecommerce.products as p 
join bigquery-public-data.thelook_ecommerce.order_items as o
on p.id = o.product_id
where status = "Complete"
)
SELECT *, 
concat(100*cast((TPO - lag(TPO) over(order by month)) as float64)/cast(lag(TPO) over( order by month) as float64),"%")as order_growth, 
concat(100*cast((TPV - lag(TPV) over(order by month)) as float64)/cast(lag(TPV) over( order by month) as float64),"%")as revenue_growth,
TPV - total_cost as total_profit,
(TPV - total_cost) / total_cost as profit_to_cost_ratio
from tb1
order by month
)
III. Tạo cohort analysis
With tb1 as(
select * , 
FORMAT_TIMESTAMP('%Y-%m', created_at) as cohort_date, 
Min(created_at) over(partition by user_id order by created_at) as first_purchase_date
from bigquery-public-data.thelook_ecommerce.order_items 
where status = 'Complete' 
), 
tb2 as (select *, (extract(year from created_at) - extract(year from first_purchase_date)) *12 + extract(month from created_at) - extract(month from first_purchase_date) + 1 as index
from tb1),
tb3 as(
select cohort_date, index, count(distinct user_id) as cnt
from tb2 
group by cohort_date,index
)
, Customer_cohort as (
select cohort_date,
sum(case when index = 1 then cnt else 0 end) as m1,
sum(case when index = 2 then cnt else 0 end) as m2,
sum(case when index = 3 then cnt else 0 end) as m3,
sum(case when index = 3 then cnt else 0 end) as m4
from tb3
group by cohort_date
order by 1 )
select cohort_date,
round(100*m1/m1,2) || '%' as m1,
round(100*m2/m1,2) || '%' as m2,
round(100*m3/m1,2) || '%' as m3,
round(100*m4/m1,2) || '%' as m4

from customer_cohort
