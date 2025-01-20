# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE Sql_Project_1;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Cleaning
**checking for null values**
'''sql
SELECT * FROM retail_sales
where transactions_id is null;
'''
'''sql
SELECT * FROM retail_sales
where sale_date is null;
'''
'''sql
SELECT * FROM retail_sales
where sale_time is null;
'''
**so,instead of checking null values for every column,can write in single code as below**
'''sql
SELECT * FROM retail_sales
where 
    transactions_id is null or sale_date is null 
    or sale_time is null or gender is null or category is null 
    or quantiy is null or cogs is null or total_sale is null;
'''
**deleting the null values**
'''sql
Delete from retail_sales
where
      transactions_id is null or sale_date is null
      or sale_time is null or gender is null
	  or category is null or quantiy is null or 
      cogs is null or total_sale is null;
'''

### 3.Data Exploration

 1.**How many sales we have?**
 '''sql
select count(*)from retail_sales;
'''

2.**How many unique customers we have**
 '''sql
select count(Distinct customer_id) from retail_sales;
'''

3. **How many unique category we have**
 '''sql
select Distinct category from retail_sales;
'''

### 4.Data Analysis & Business key problems

1. **retrieve all coumns for sales made on '2022-11-05'**:
```sql
select *
 from retail_sales
 where sale_date='2022-11-05';
```

2. **Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
select *
from retail_sales
where category = 'Clothing' and to_char(sale_date,'yyyy-mm')='2022-11'
and quantiy >=4
```

3. **calculate the total sales for each category**:
```sql
select category,sum(total_sale) as net_sale,
count(*) as total_orders
from retail_sales
group by category 
```

4. **find the average age of customers who purchased item from "beauty category"**:
```sql
select category, Round(avg(age),2) as avg_age
from retail_sales
where category='Beauty'
group by 1
```

5. **find all transactions where the total_sale is greater than 1000**:
```sql
select *
from retail_sales
where total_sale > 1000
```

6. **find the total number of transactions made by each gender in each category**:
```sql
select category,gender, count(*) as total_transactions
from retail_sales
group by category,gender
```

7. **calculate the average sale for each month.find out best selling month in each year**:
```sql
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
```

8. **find the top 5 cusomers based on the highest total sales**:
```sql
select customer_id,sum(total_sale) as highest_sales
from retail_sales
group by 1
order by 2 desc 
limit 5
```

9. **find the number of unique customers who purhased items from each category**:
```sql
select count(distinct customer_id) as unique_customers,category
from retail_sales
group by 2
```

10. **10)create each shift and number of orders (example morning <= 12 , afternoon between 12 and 17, evening >17)**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## Author - Bhavani Manney

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles.
