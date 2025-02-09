-- Project : SQL Retail Sales Analysis

-- creating Database
create database SQL_Project1;

-- CREATE TAble --
create table retail_sales
             (
             transaction_id INT PRIMARY KEY,
             sale_date DATE,
             sale_time TIME,
             customer_id INT,
             gender VARCHAR (15),
             age INT,
             category VARCHAR(15),
             quantity int,
             price_per_unit float,
             cogs float,
             total_sales float
             );
             
select * from retail_sales
limit 10;

select 
   count(*)
   from retail_sales;
   
-- DATA CLEANING --

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sales IS NULL;
    
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sales IS NULL;
   
-- Data Exploration

-- 1. How many sales we have?
select count(*) as total_sale from retail_sales;

-- 2. How many unique customers we have?
select count(distinct customer_id) from retail_sales;

-- 3. Names of the unique category 
select distinct category from retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings --

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * from retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
SELECT * 
FROM retail_sales 
WHERE category = 'Clothing' 
  AND quantity >= 4 
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category,
    SUM(total_sales) AS net_sales,
    COUNT(*) AS total_orders
FROM
    retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
    ROUND(AVG(age), 2) AS avg_age
FROM
    retail_sales
WHERE
    category = 'beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
    *
FROM
    retail_sales
WHERE
    total_sales > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    category, gender, COUNT(*) AS total_trans
FROM
    retail_sales
GROUP BY category , gender
ORDER BY category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
WITH MonthlySales AS (
    SELECT 
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        SUM(total_sales) AS total_monthly_sales,
        round(AVG(total_sales),2) AS avg_monthly_sales
    FROM retail_sales
    GROUP BY sale_year, sale_month
),
BestSellingMonth AS (
    SELECT 
        sale_year,
        sale_month,
        total_monthly_sales,
        RANK() OVER (PARTITION BY sale_year ORDER BY total_monthly_sales DESC) AS rnk
    FROM MonthlySales
)
SELECT 
    m.sale_year,
    m.sale_month,
    m.avg_monthly_sales,
    b.sale_month AS best_selling_month,
    b.total_monthly_sales
FROM MonthlySales m
JOIN BestSellingMonth b ON m.sale_year = b.sale_year
WHERE b.rnk = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
    customer_id, SUM(total_sales) AS Total
FROM
    retail_sales
GROUP BY customer_id
ORDER BY Total DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category, COUNT(DISTINCT customer_id) AS cnt_uni_custid
FROM
    retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift


-- End of Project --

   