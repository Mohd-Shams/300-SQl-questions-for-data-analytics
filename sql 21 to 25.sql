-- 21. Top Product in Every Category

-- Business Problem

-- Management wants to identify the highest-selling product in each category.

WITH TOP AS(
SELECT category,product_name,SUM(total_amount)AS total_revenue
FROM data2 
GROUP BY category,product_name)


SELECT
    category,
    product_name,
    total_revenue,
    ROW_NUMBER() OVER (
        PARTITION BY category
        ORDER BY total_revenue DESC
    ) AS rn
FROM TOP;


-- 22. Top 3 Customers by Revenue in Every Region

-- Business Problem

-- Find the top three customers generating the highest revenue in each region.
WITH top_customer AS(
SELECT region,customer_id,
customer_name,
SUM(total_amount)AS total_revenue
FROM data2 
GROUP BY region,customer_id,customer_name
),


ranked_customer AS (SELECT
    region,
    customer_id,
    customer_name,
    total_revenue,
    ROW_NUMBER() OVER (
        PARTITION BY region
        ORDER BY total_revenue DESC
        
    ) AS rn
FROM top_customer)

SELECT region,customer_id,customer_name,total_revenue,rn

FROM ranked_customer
WHERE rn<=3
ORDER BY region ,RN;

-- 23. Rank Products by Revenue

-- Business Problem

-- Rank all products by total revenue from highest to lowest.
WITH products_
AS(SELECT product_name,ROUND(SUM(total_amount),2) AS total_revenue
FROM data2 
GROUP BY product_name
)

SELECT product_name,total_revenue,
RANK() OVER(ORDER BY total_revenue DESC)AS rankings
FROM products_;


-- 24. Best-Selling Products with Dense Ranking

-- Business Problem

-- Assign rankings to products by revenue without skipping rank numbers when there are ties.

WITH products_
AS(SELECT product_name,ROUND(SUM(total_amount),2) AS total_revenue
FROM data2 
GROUP BY product_name
)

SELECT product_name,total_revenue,
DENSE_RANK() OVER(ORDER BY total_revenue DESC)AS rankings
FROM products_;

-- 25. Month-over-Month Sales Comparison

-- Business Problem

-- Compare each month's revenue with the previous month's revenue to identify growth or decline.

WITH rev_month 
AS( SELECT
	MONTH(STR_TO_DATE(order_date, '%m/%d/%Y')) AS month_no,
    MONTHNAME(STR_TO_DATE(order_date, '%m/%d/%Y')) AS month_name,
    SUM(total_amount) AS total_sales
FROM data2
GROUP BY
    MONTH(STR_TO_DATE(order_date, '%m/%d/%Y')),
    MONTHNAME(STR_TO_DATE(order_date, '%m/%d/%Y'))
ORDER BY
    MONTH(STR_TO_DATE(order_date, '%m/%d/%Y')))
    

SELECT month_name, total_sales AS this_month_sales,
LAG(total_sales) OVER(ORDER BY month_no )AS previous_month_sales
FROM rev_month 












