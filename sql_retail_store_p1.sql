
drop table if exists retail_store;
CREATE TABLE retail_store
(
	transactions_id	INT primary key,
	sale_date	date,
	sale_time	time,
	customer_id	INT,
	gender Varchar(15),	
	age	INT,
	category Varchar(15),	
	quantiy	INT,
	price_per_unit FLOAT,	
	cogs FLOAT,
	total_sale FLOAT
	
);

select count(*) from retail_store;

select * from retail_store
where sale_date is NULL
or
sale_time is NULL
or
transactions_id is NULL
or
quantiy is NULL;

delete from retail_store
where sale_date is NULL
or
sale_time is NULL
or
transactions_id is NULL
or
quantiy is NULL;


-- Data Exploration
-- How many sales we have
select count(*) from retail_store;

-- How many unique customers we have
select count(distinct customer_id) from retail_store;

select distinct category from retail_store;

-- Data Analysis and Business Key problems ---


--Retrieve column for sales on 2022-11-05
select * from retail_store
where sale_date = '2022-11-05';

--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022--
select * from retail_store
where category = 'Clothing' 
and quantiy >= 4 
and to_char(sale_date, 'YYYY-MM') ='2022-11';

--Write a SQL query to calculate the total sales (total_sale) for each category
select category, sum(total_sale),
count(*) as total_orders from retail_store
group by 1;

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
select Round(avg(age),2) as avg_age from retail_store
where category = 'Beauty';

--Write a SQL query to find all transactions where the total_sale is greater than 1000
select *
from retail_store
where total_sale > 1000;

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
select count(*), gender, category from retail_store
group by gender, category;

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select * from(
select extract(year from sale_date) as year,
extract(month from sale_date) as month,
rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc),
avg(total_sale) as avg_total_sale
from retail_store
group by 1,2
--order by 1,3 desc;
) as t1
where rank = 1;

--Write a SQL query to find the top 5 customers based on the highest total sales
select sum(total_sale), customer_id from retail_store
group by customer_id
order by sum(total_sale) desc
limit 5;

--Write a SQL query to find the number of unique customers who purchased items from each category
select 
count(distinct customer_id), category from retail_store
group by 2;

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
with hourly_sales
as
(
select *,
case 
	when extract(hour from sale_time) <= 12 then 'Morning'
	when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
	else 'Evening'
end as shift
from retail_store
)
select shift,count(*) from hourly_sales
group by shift
order by 2;


---END of Project1
