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














			