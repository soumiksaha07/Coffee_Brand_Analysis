Create database if not exists coffee_roaster;
use coffee_roaster;

set sql_safe_updates = 0;

update coffee_brand
set TypeofRoast = 'medium-light'
where TypeofRoast = 'medium_light';

select * from coffee_brand;

# Questions to Explore !

/* 1. What is the most expensive coffee per 100g, and what features distinguish it? */

select BrandName,TypeofRoast, 
max(Priceper100ginUSD) as Expensive_coffee
from coffee_brand
group by 1,2
order by Expensive_coffee desc
limit 5;

/* 2. What are the top 5 coffee brands in terms of avergae rating? */

select brandName, avg(Rating) as AvgRating
from coffee_brand
group by BrandName
order by avg(Rating) desc
limit 5;

/* 3. Which roaster has received the best reviews in terms of average rating? */

select TypeofRoast, avg(rating) as AvgRating
from coffee_brand
group by TypeofRoast
order by AvgRating desc;

/* 4. Which country of origin has the highest average rating for coffee? */

with ranked_origin as (
select Origin, avg(Rating) as AvgRating,
row_number() over (order by avg(Rating) desc) as ranks
FROM coffee_brand
group by 1)
select *
from ranked_origin
where ranks <= 3;

/* 5. Find best seasonal coffee in every year? */

with season_category as (
select year(ReviewDate) 'Years', Rating, brandname,
case 
    when month(ReviewDate) in (3,4,5,6) then 'Summer'
    when month(ReviewDate) in (7,8,9,10) then 'Monsoon'
    when month(ReviewDate) in (11,12,1,2) then 'Winter'
end as season
from coffee_brand),
AvgRating as (
select Years, season, Avg(Rating) 'AvgRating', brandname
from season_category
group by 1,2,4 ),
Best_SeasonalCoffee as (
select Years, season, AvgRating, brandname,
row_number() over (partition by Years, season order by AvgRating desc) as ranks
from AvgRating)
select Years, season, AvgRating, brandname
from Best_SeasonalCoffee
where ranks = 1
order by Years, season;

/* 6. How many coffees have a rating above 90? */

select rating_group,  count(*) as countofbrand
from (select brandname,
case
	when avg(rating) < 70 then '<70'
	when avg(rating) between 71 and 80 then '71-80'
	when avg(rating) between 81 and 90 then '81-90'
	else '>90'
end as rating_group
from coffee_brand
group by BrandName) as rated
group by rating_group
order by rating_group desc;

/* 7. Find which type of roast is famous in each selling location.*/

with ranked_roasts as (
    select RoasterLocation, TypeofRoast, avg(Rating) as AvgRating,
	row_number() over (partition by RoasterLocation order by avg(Rating) desc) as rn
    from coffee_brand
    group by RoasterLocation, TypeofRoast
)
select *
from ranked_roasts
where rn = 1
order by RoasterLocation;