--ex1
select distinct city 
from station
where id%2 = 0
--ex2
select count(*) - count(distinct city)
from station
--ex3
select ceil(avg(salary)-avg(replace(salary,'0','')))
from employees
--ex5
SELECT candidate_id
from candidates
where skill in ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
having COUNT(*) = 3
--ex4
SELECT  ROUND(cast(SUM(order_occurrences*item_count ) as decimal
) / SUM(order_occurrences) , 1)
FROM items_per_order
--ex6
SELECT user_id, MAX(post_date::date) - MIN(post_date::date)
FROM posts
where date_part('year', post_date:: Date) = 2021
GROUP BY user_id
having count(*) > 1
--ex7
SELECT card_name, (max(issued_amount)-min(issued_amount)) as diff
FROM monthly_cards_issued
group by card_name
ORDER BY diff desc
--ex8
SELECT manufacturer, COUNT(*), SUM(abs(total_sales - cogs)) as total_lost
FROM pharmacy_sales
where total_sales < cogs
GROUP BY manufacturer
order by total_lost desc
--ex9
select *
from cinema
where id%2 != 0 and description != 'boring'
order by rating desc
--ex10
select teacher_id, count(distinct subject_id) as cnt
from teacher
group by teacher_id
--ex11
select user_id, count(follower_id) as followers_count
from followers
group by user_id
--ex12
# Write your MySQL query statement below
select class
from courses
group by class
having count(student) > 4
