'I. SQL Cơ bản'
1. 
Select *
From products
2. 
select *
from products
order by price desc
3. 
select *
from customers
where state_id = 5
4.
select city
from customers
5. 
select tx_id
from transactions 
where qty > 3 and price < 50
6. 
select *
from products
where category not in ("Mix","Youth")
7. 
select tx_id
from transactions
group by tx_id
having sum(price) between 500 and 1000
8.
select *
from customers
where city = "Chardon" and address = "Buckingham Street"
9.
select *
from transactions
order by tx_date desc
limit 5
10.
select *
from customers
where address is null
II. Joins, Aggregate, Group by, Having
1. 
select *
from products p join manufacturers m
on p.manufacturerID = m.manufacturerID
2.
select *
from customers c left join transactions t
on c.cust_id = t.cust_id
3.
select prod_id,product, sum(qty) as total_quantity
from transactions t left join products p
on t.prod_id = p.productID
group by prod_id
order by sum(qty) desc
4.
select prod_id,product, sum(price) as revenue
from transactions t left join products p
on t.prod_id = p.productID
group by prod_id
having sum(price)>10000
order by sum(price) desc
5. 
select cust_id, count(*) as total_trans
from transactions
group by cust_id
III. Subquery, bảng phụ
1.
select product, price
from products 
where price > (select avg(price) from products )
2. 
select cust_id, avg(price)
from transactions
group by cust_id
3. 
select  distinct concat(r.first_name," ",r.last_name) as representatives
from transactions t left join customers c
on t.cust_id = c.cust_id
join states s on s.state_id = c.state_id
join sales_reps r on t.rep_id = r.rep_id
where state_name = "CA"
4. 
select c.cust_id, concat(first_name," ", last_name) as Customers
from customers c left join transactions t
on c.cust_id = t.cust_id
where tx_id is null

