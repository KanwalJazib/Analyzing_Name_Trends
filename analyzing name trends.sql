-- Analyzing Name Trends for over 

-- 1. How many unique names are in the dataset?

select count(distinct (first_name)) from usa_baby_names; -- 547

-- 2. Top ranked Female names

select first_name, sum(num) as total_babies, sex, 
RANK () OVER (ORDER BY SUM(NUM) DESC) as ranks
FROM usa_baby_names
where  sex = 'F'
group by first_name, sex
order by ranks 
limit 10;

-- 3. Top ranked M names

select first_name, sum(num) as total_babies, sex, 
RANK () OVER (ORDER BY SUM(NUM) DESC) as ranks
FROM usa_baby_names
where  sex = 'M'
group by first_name, sex
order by ranks 
limit 10;

-- 4. name after 2015 onwards that ends with a and for a female. 

select first_name, sum(num) from usa_baby_names
where sex='F' and year > 2015 and first_name like '%a'
group by first_name
order by sum(num) desc;

-- 5. The Olivia Expansion
select first_name, year,num, sum(num) over(order by year) as rolling_total
from usa_baby_names
where first_name = 'Olivia'
order by year;

-- 6. Max male names per year

select first_name, year, max(num) from usa_baby_names
where sex = 'M'
group by year,first_name;

-- 7. top male names
select b.first_name, b.year, b.max_num as "num of babies given the first_name that year"
from (select first_name, year, max(num) as max_num from usa_baby_names
where sex = 'M'
group by year,first_name) b
order by b.max_num desc;

-- 8. Analyze the frequency of top male baby names across different years based on the maximum number of babies given that name.

WITH top_names AS (
  SELECT b.year, b.first_name, b.max_num AS "num of babies given the first_name that year"
  FROM (
    SELECT year, first_name, MAX(num) AS max_num
    FROM usa_baby_names
    WHERE sex = 'M'
    GROUP BY year, first_name
  ) b
  ORDER BY b.max_num DESC
)
SELECT first_name, COUNT(*) AS count_top_name
FROM top_names
GROUP BY first_name
ORDER BY count_top_name DESC;

-- 9. timeless or trendy?

select first_name, sum(num) as total_babies,
case
when count(year) > 80 then 'Classic'
when count(year) > 50 then 'Semi-classic'
when count(year) > 20 then 'Trendy'
else 'Trendy'
end as TimelessorTrendy
from usa_baby_names
group by first_name
order by first_name;

select first_name, sum(num), count(first_name) from usa_baby_names
where sex = 'M'
group by first_name
having count(first_name) = 101
order by sum(num) desc;

-- 10. Classic american names for over 100 years

select first_name, sum(num) from usa_baby_names
group by first_name
having count(year)=101
order by sum(num) desc;