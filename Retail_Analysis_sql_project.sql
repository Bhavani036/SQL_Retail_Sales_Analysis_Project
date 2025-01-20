
CREATE TABLE retail_sales
            (
				transactions_id INT PRIMARY KEY,
				sale_date DATE, 
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(10),
				age INT,
				category VARCHAR(15),
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			);

SELECT * FROM retail_sales;

select count(*) from retail_sales;
-------------------------------------------------------------------
---DATA CLEANING---
---checking for null values---
SELECT * FROM retail_sales
where transactions_id is null;

SELECT * FROM retail_sales
where sale_date is null;

SELECT * FROM retail_sales
where sale_time is null;

---so,instead of checking null values for every column,can write in single code as below
SELECT * FROM retail_sales
where transactions_id is null
      or
	  sale_date is null
	  or
	  sale_time is null
	  or
	  gender is null
	  or
	  category is null
	  or
	  quantiy is null
	  or
	  cogs is null
	  or
	  total_sale is null;
--------------------------------------------------------------------------  
---deleting the null values---
Delete from retail_sales
where
      transactions_id is null
      or
	  sale_date is null
	  or
	  sale_time is null
	  or
	  gender is null
	  or
	  category is null
	  or
	  quantiy is null
	  or
	  cogs is null
	  or
	  total_sale is null;
---------------------------------------------------------------------- 
 ---Data Exploration--- 
 
 ---How many sales we have?---
 select count(*)from retail_sales

 ---How many unique customers we have---
 select count(Distinct customer_id) from retail_sales

 ---How many unique category we have---
 select Distinct category from retail_sales

 ---------------------------------------------------------------------
 ---DATA ANALYSIS & BUSINESS KEY PROBLEMS---
 
 ---1)retrieve all coumns for sales made on '2022-11-05'---
 select *
 from retail_sales
 where sale_date='2022-11-05';

 ---2)retrieve all the transactions where the category is 'clothing' and 
 ---the quantity sold is more than 4 in the month of nov 2022---
select *
from retail_sales
where category = 'Clothing' and to_char(sale_date,'yyyy-mm')='2022-11'
and quantiy >=4

---3)calculate the total sales for each category---
select category,sum(total_sale) as net_sale,
count(*) as total_orders
from retail_sales
group by category 

---4)find the average age of customers who purchased item from "beauty category"---
select category, Round(avg(age),2) as avg_age
from retail_sales
where category='Beauty'
group by 1

---5)find all transactions where the total_sale is greater than 1000'---
select *
from retail_sales
where total_sale > 1000

---6)find the total number of transactions made by each gender in each category---
select category,gender, count(*) as total_transactions
from retail_sales
group by category,gender

---7)calculate the average sale for each month.find out best selling month in each year---
select * from
(
	select
		extract(year from sale_date) as year,
		extract(month from sale_date) as month,
		avg(total_sale) as avg_sale,
		rank()over(partition by extract (year from sale_date) order by avg(total_sale) desc) as rank
	from retail_sales
	group by 1,2
)as t1
where rank =1


---8)find the top 5 cusomers based on the highest total sales---
select customer_id,sum(total_sale) as highest_sales
from retail_sales
group by 1
order by 2 desc 
limit 5

---9)find the number of unique customers who purhased items from each category---
select count(distinct customer_id) as unique_customers,category
from retail_sales
group by 2

---10)create each shift and number of orders (example morning <= 12 , afternoon between 12 and 17, evening >17)---
with hourly_sale
as
(
select *, 
    case
		when extract(hour from sale_time)< 12  then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales
)
select shift,count(*) as total_orders from hourly_sale
group by shift

------------End of the project-------------