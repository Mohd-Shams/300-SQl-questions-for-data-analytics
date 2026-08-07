-- 31. Top 5 Revenue-Generating Cities
-- Business Problem

-- The regional sales director wants to identify the five cities generating the highest revenue to 
-- prioritize future investments and marketing campaigns.
SELECT region,ROUND(SUM(total_amount),2) AS total_revenue
FROM data3
GROUP BY region
ORDER BY total_revenue DESC
LIMIT 5;