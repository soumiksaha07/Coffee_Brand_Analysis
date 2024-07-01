Create database if not exists coffee_roaster;
use coffee_roaster;

select * from coffee_brand;

# Questions to Explore !

/* 1. What is the most expensive coffee per 100g, and what features distinguish it? */

select BrandName, roasters, TypeofRoast, max(Priceper100ginUSD) as Expensive_coffee, mouthfeel
from coffee_brand
group by 1,2,3,5
order by Expensive_coffee desc
limit 1;

/* 2. What are the top 10 highest-rated coffee brands? */

select brandName, Rating
from coffee_brand
order by Rating desc
limit 10;

/* 3. Which roaster has received the best reviews in terms of average rating? */

with cte as (
select TypeofRoast, avg(rating) as AvgRating
from coffee_brand
group by TypeofRoast)
select *
from cte
order by AvgRating desc;

/* 4. Which country of origin has the highest average rating for coffee? */

select Origin, avg(rating) as AvgRating
from coffee_brand
group by Origin
order by avg(rating) desc
limit 3;

/* 5. Which coffee brand has the best/worst average rating every year? */

with BestRatingPerYear as (
select year(ReviewDate) as Review_Year, BrandName, avg(Rating) as AvgRating,
	row_number() over (partition by year(ReviewDate) order by avg(Rating) desc) as Rnk
    from coffee_brand  group by year(ReviewDate), BrandName
),
WorstRatingPerYear as (
select year(ReviewDate) as Review_Year, BrandName, AVG(Rating) as AvgRating,
	row_number() over (partition by year(ReviewDate) order by avg(Rating) asc) as Rnk
    from coffee_brand  group by year(ReviewDate), BrandName
)
select Review_Year,BrandName, AvgRating, 'Best' as RatingType
from BestRatingPerYear where Rnk = 1
UNION
select Review_Year, BrandName, AvgRating, 'Worst' as RatingType
from WorstRatingPerYear where Rnk = 1
order by Review_Year, RatingType;

/* 6. How many coffees have a rating above 90? */

select count(distinct brandname) as TotalCount_of_Coffee_above90
from coffee_brand
where rating > 90;

/* 7. Find the average rating for coffee in each location.*/

select roasterlocation, avg(rating) as AvgRating
from coffee_brand
group by 1
order by avg(rating) desc;

/* 8. Which locations have the highest and lowest average prices per 100g, and what are these prices */

(select RoasterLocation, avg(Priceper100ginUSD) as AvgPrice
from coffee_brand
group by 1
order by avg(Priceper100ginUSD) desc
limit 1)
Union
(select RoasterLocation, avg(Priceper100ginUSD) as AvgPrice
from coffee_brand
group by 1
order by avg(Priceper100ginUSD) asc
limit 1);

/* 9. Which country contributes the most to the dataset in terms of coffee production */

select distinct(count(brandname)) as TotalCoffee_produce, Origin
from coffee_brand
group by Origin
order by 1 desc limit 3;

/* 10. Top 5 high average rating coffee brands in Asia, do they have a common Mouthfeel? */

select distinct(RoasterLocation), brandname, avg(rating) as AvgRating, mouthfeel
from coffee_brand
where RoasterLocation in ('Taiwan','Hong Kong','Japan','China')
group by 1,2,4
order by avg(Rating) desc
limit 5;