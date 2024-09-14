--Ex1:
with tb1 as(
select  *, rank() over(partition by customer_id order by order_date) as rank
from delivery
)
select 100 * count(*) / (select count(distinct customer_id) from delivery ) as immediate_percentage 
from tb1
where rank = 1 and order_date - customer_pref_delivery_date = 0
-Ex2:
# Write your MySQL query statement below
-- Write your PostgreSQL query statement below
with tb1 as (select player_id, event_date - lag(event_date) over(partition by player_id order by event_date) as diff
from activity),
tb2 as(
select count(*) as log_back, cast((select count(distinct player_id) from activity) as float) as player_num
from tb1
where diff = 1
)
select round(log_back / player_num,2) as fraction
from tb2
--ex3:
select (
  case when id % 2 = 1 and id = (select max(id) from Seat) THEN id
  when id % 2 = 0 then id - 1
  else  id + 1 end ) as id, student
from seat
order by id
--ex4:
With tb1 as(
select visited_on, sum(amount)
from customer
group by visited_on)
, tb2 as (
select visited_on,sum(sum) over (order by visited_on rows between 6 preceding and current row) as amount, round(avg(sum) over (order by visited_on rows between 6 preceding and current row ),2)as average_amount, row_number() over(order by visited_on) as num
from tb1)
select visited_on, amount, average_amount
from tb2 
where num > 6
--ex5:
with tb1 as (
select *, count(pid) over(partition by lat,lon) as count
from insurance 
)
select  sum(tiv_2016) as tiv_2016
from tb1
where count < 2
group by tiv_2015
--ex6:
With rank_tb as(
select e.name as employee, d.name as department, salary,  dense_rank() over(partition by d.name order by salary desc) as rank
from Employee as e left join Department as d
on e.departmentId = d.id
)
select department,employee, salary
from rank_tb
where rank <= 3
--ex7:
with tb1 as(
Select *, sum(weight) over(order by turn) as total_amount
from queue
)
select person_name
from tb1 
where total_amount <= 1000
order by total_amount desc
limit 1
--ex8:
With tb1 as(
select *,
(case 
when extract(day from change_date) <= 16 then new_price
when extract(day from change_date) > 16 and product_id not in(select product_id from products
 where extract(day from change_date) <= 16) then 10 end) as price
from products
where extract(month from change_date) <= 8  
)
select distinct product_id, first_value(price) over(partition by product_id order by change_date desc) as price
from tb1
where price is not null


