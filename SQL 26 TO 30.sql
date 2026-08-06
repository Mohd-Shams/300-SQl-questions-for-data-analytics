-- 26. Forecast Next Month's Revenue

-- Business Problem

-- Display each month's revenue alongside the following month's revenue to support planning.

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
LEAD(total_sales) OVER(ORDER BY month_no )AS previous_month_sales
FROM rev_month ;

-- 27. Running Sales Total
-- Business Problem

-- The management team wants to monitor business growth over time by calculating the cumulative (running) sales for each month.
WITH month_sales AS (
	SELECT
	MONTH(STR_TO_DATE(order_date, '%m/%d/%Y')) AS month_no,
    MONTHNAME(STR_TO_DATE(order_date, '%m/%d/%Y')) AS month_name,
    SUM(total_amount) AS total_sales
FROM data2
GROUP BY
    MONTH(STR_TO_DATE(order_date, '%m/%d/%Y')),
    MONTHNAME(STR_TO_DATE(order_date, '%m/%d/%Y'))
ORDER BY
    MONTH(STR_TO_DATE(order_date, '%m/%d/%Y')))
    
SELECT month_no ,
month_name,
ROUND(SUM(total_sales) OVER (ORDER BY month_no),2) AS cumulative_sales
FROM month_sales;

-- 29. Percentage Contribution by Category

-- Business Problem

-- Determine what percentage of the company's total revenue comes from each product category.

WITH category_sales AS (
    SELECT
        category,
        SUM(total_amount) AS category_revenue
    FROM data2
    GROUP BY category
)

SELECT
    category,
    category_revenue,
    ROUND(
        (category_revenue / SUM(category_revenue) OVER()) * 100,
        2
    ) AS revenue_percentage
FROM category_sales
ORDER BY revenue_percentage DESC;

-- Question 29 – Highest Revenue Order per Customer
-- Business Problem

-- Find the single highest-value order placed by each customer.

WITH ranked_orders AS (
    SELECT
        customer_id,
        customer_name,
        order_id,
        total_amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY total_amount DESC
        ) AS rn
    FROM data2
)

SELECT
    customer_id,
    customer_name,
    order_id,
    total_amount
FROM ranked_orders
WHERE rn = 1
ORDER BY total_amount DESC;


-- Question 30 – Customer Lifetime Value (CLV) Ranking
-- Business Problem

-- The management team wants to identify the most valuable customers based on their total lifetime spending.
--  Rank customers from highest to lowest lifetime revenue and display the top-performing customers.

WITH customer_revenue AS (
    SELECT
        customer_id,
        customer_name,
        ROUND(SUM(total_amount), 2) AS lifetime_revenue
    FROM data2
    GROUP BY
        customer_id,
        customer_name
)

SELECT
    customer_id,
    customer_name,
    lifetime_revenue,
    DENSE_RANK() OVER (
        ORDER BY lifetime_revenue DESC
    ) AS customer_rank
FROM customer_revenue
ORDER BY customer_rank;









