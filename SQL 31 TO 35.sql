-- 31. Top 5 Revenue-Generating Cities
-- Business Problem

-- The regional sales director wants to identify the five cities generating the highest revenue to 
-- prioritize future investments and marketing campaigns.
SELECT city,ROUND(SUM(total_amount),2) AS total_revenue
FROM data3
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 5;

-- 32. Best Performing Sales Representative in Every Region
-- Business Problem

-- Management wants to reward the best-performing salesperson in each region based on total revenue generated.

WITH sales_person AS(SELECT region ,sales_rep ,
		ROUND(SUM(total_amount),2) AS total_revenue
FROM data3
GROUP BY region,sales_rep),

 ranking AS (SELECT region,sales_rep,total_revenue,
			DENSE_RANK() OVER (PARTITION BY region
            ORDER BY total_revenue DESC) AS RK
            FROM sales_person)
            
SELECT region,sales_rep,total_revenue,RK
FROM RANKING
WHERE RK = 1;



-- 33. Average Order Value by Payment Method
-- Business Problem

-- The finance department wants to understand which payment method is associated with the highest average order value.

SELECT payment_method ,ROUND(AVG(total_amount),2) AS avg_value FROM data3
GROUP BY payment_method
ORDER BY avg_value DESC
LIMIT 1;

-- 34. Monthly Revenue Growth Percentage
-- Business Problem

-- The finance team wants to calculate the percentage growth (or decline) in revenue compared with the previous month.

WITH rev_month 
AS( SELECT
	MONTH(STR_TO_DATE(order_date, '%m/%d/%Y')) AS month_no,
    MONTHNAME(STR_TO_DATE(order_date, '%m/%d/%Y')) AS month_name,
    SUM(total_amount) AS total_sales
FROM data3
GROUP BY
    MONTH(STR_TO_DATE(order_date, '%m/%d/%Y')),
    MONTHNAME(STR_TO_DATE(order_date, '%m/%d/%Y'))
ORDER BY
    MONTH(STR_TO_DATE(order_date, '%m/%d/%Y')))
    

SELECT month_name, total_sales AS this_month_sales,
LAG(total_sales) OVER(ORDER BY month_no )AS previous_month_sales,
ROUND(((total_sales - (LAG(total_sales) OVER(ORDER BY month_no )))/(LAG(total_sales) OVER(ORDER BY month_no ))*100),2)AS growth
FROM rev_month ;



-- 35. Customers Spending Above Regional Average
-- Business Problem

-- Regional managers want to identify customers whose total spending is higher than the average customer spending within their own region.

WITH spendings as(SELECT region,customer_id,customer_name,ROUND(SUM(total_amount),2)AS total_spend
FROM data3
GROUP BY region,customer_id,customer_name),

avg_region AS(SELECT region,ROUND(AVG(total_spend),2) AS avg_region_spend
FROM spendings
GROUP BY region)

SELECT s.region,s.customer_id,s.customer_name,s.total_spend 
FROM spendings s
INNER JOIN avg_region a
ON s.region = a.region
WHERE s.total_spend > a.avg_region_spend

-- smaller version

WITH spendings AS (
    SELECT
        region,
        customer_id,
        customer_name,
        SUM(total_amount) AS total_spend
    FROM data3
    GROUP BY region, customer_id, customer_name
)
SELECT *
FROM (
    SELECT *,
           AVG(total_spend) OVER (PARTITION BY region) AS avg_region_spend
    FROM spendings
) t
WHERE total_spend > avg_region_spend;








			