--ex1
SELECT 
SUM( case when device_type = 'laptop' then 1 else 0 end) as laptop_views,
SUM( case when device_type in ('phone','tablet') then 1 else 0 end) as mobile_views
FROM viewership
--ex2
select *, 
case when z > x + y or x >y+z or y > x+z then 'No'
else 'Yes'
end as triangle
from triangle
--ex3
SELECT round(sum(case when call_category = 'n/a' or call_category is NULL then 1 else 0 end)/cast(count(case_id) as decimal)*100,1)
FROM callers
--ex4
select name
from customer
where coalesce(referee_id,'1') != 2
--ex5
select case 
when pclass = 1 then 'first_class'
when pclass = 2 then 'second_class'
else 'third_class' end as class,
sum(case when survived = 1 then 1 else 0 end ) as survived,
sum(case when survived = 0 then 1 else 0 end) as not_survived
from titanic
group by 
case when pclass = 1 then 'first_class'
when pclass = 2 then 'second_class'
else 'third_class'
end
