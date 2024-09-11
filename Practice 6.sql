Practice 6
--Ex1:
Select count(*)
From(
SELECT company_id,title, description, count(job_id) as count_
FROM job_listings
group by company_id, title, description ) as table_
where count_ > 1
--Ex2:
SELECT category, product, total_spend
FROM (
SELECT category, product, sum(spend) as total_spend, 
RANK()OVER(partition by category order by sum(spend) desc) as ranking
FROM product_spend
where extract(year from transaction_date) = 2022
group by category, product ) as t2
where ranking <= 2
--ex3:
With tb2 AS (
SELECT policy_holder_id, COUNT(case_id) as case_count
FROM callers
group by policy_holder_id
HAVING COUNT(case_id) >= 3 )
select count(*)
from tb2
--ex4:
Select page_id 
from pages
where page_id not in (
select page_id
from page_likes
where page_id is not NULL)
--ex5:
SELECT extract(month from event_date) as month_, count(distinct user_id)
FROM user_actions
where user_id in (
select user_id
from user_actions
where extract(month from event_date) = 6
) and extract(month from event_date) = 7
group by extract(month from event_date) 
--ex6:
-- Write your PostgreSQL query statement below
select  to_char(trans_date, 'yyyy-mm') as month,country, count(id) as trans_count, 
sum( case when state = 'approved' then 1 else 0 end) as approved_count, sum(amount) as trans_total_amount, sum(case when state = 'approved' then amount else 0 end) as approved_total_amount
from 
transactions
group by country, month
order by month
--ex7:
select product_id, year as first_year, quantity, price
from (
select product_id, year, quantity, price,rank() over(partition by product_id order by year asc ) as rank
from sales
where product_id in (select product_id from product) ) as tb1
where rank = 1
--ex8:
select customer_id
from customer
group by customer_id
having count(product_key) = (select count(distinct product_key)
from product)
--ex9:
select employee_id 
from employees
where salary < 30000 and manager_id not in(select employee_id from employees )
--ex10:
Select count(*)
From(
SELECT company_id,title, description, count(job_id) as count_
FROM job_listings
group by company_id, title, description ) as table_
where count_ > 1
--ex11:
with tb1 as (select (select name from users where users.user_id = movierating.user_id) as results
from movierating
group by user_id
order by count(rating) desc, results asc 
limit 1 ),
tb2 as(
select (select title from movies where movies.movie_id = movierating.movie_id) as results
from movierating
where extract(month from created_at) = 2 and extract(year from created_at) = 2020
group by movie_id
order by avg(rating) desc, results
limit 1)
select * from tb1
union
select * from tb2
--ex12:
Select id, count(*) as num
from 
(select requester_id as id
from RequestAccepted 
union all
select accepter_id as id
from RequestAccepted) as tb
group by id
order by num desc
limit 1




