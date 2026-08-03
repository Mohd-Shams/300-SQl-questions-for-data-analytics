-- 11. Customer Retention Analysis

-- Business Problem

-- The marketing team wants to measure customer loyalty. Identify customers who made purchases in more than one calendar year.

SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT YEAR(STR_TO_DATE(order_date, '%m/%d/%Y'))) AS purchase_years
FROM data2
GROUP BY
    customer_id,
    customer_name
HAVING COUNT(DISTINCT YEAR(STR_TO_DATE(order_date, '%m/%d/%Y'))) > 1;


-- 12. Low Inventory Alert

-- Business Problem

-- The inventory team needs to replenish stock. Find products whose total quantity sold is below the average quantity sold across all products.
SELECT product_name ,SUM(quantity) AS tatal_quantity
FROM data2
GROUP BY product_name
HAVING tatal_quantity <(SELECT AVG(total_quant)

						FROM(SELECT SUM(quantity) AS total_quant
                        FROM data2 
                        GROUP BY  product_name) AS T_quantity)
ORDER BY tatal_quantity DESC



-- 13. Discount Effectiveness

-- Business Problem

-- The sales team wants to understand whether higher discounts actually increase revenue. 
-- Compare total revenue generated for different discount ranges (e.g., 0–10%, 11–20%, 21–30%, above 30%).
SELECT
CASE 
	WHEN discount BETWEEN 0 AND 10 THEN '0-10%' 
    WHEN discount BETWEEN 11 AND 20 THEN '11-20%'
    WHEN discount BETWEEN 21 AND 30 THEN '21-30%'
    ELSE 'Above 30%'
END AS discount_range,
ROUND(SUM(total_amount),2) AS total_revenue
FROM data2
GROUP BY discount_range;

-- Business Problem 14

-- The quality assurance team wants to identify categories with the highest percentage of returned products.

SELECT category ,
COUNT(quantity) AS total_orders,
SUM(CASE WHEN return_status = 'YES' THEN 1
	     ELSE 0 END ) AS return_orders,
		ROUND((SUM(CASE WHEN return_status = 'YES' THEN 1
	     ELSE 0 END )  / COUNT(*) )* 100,2) AS return_rate
FROM data2
GROUP BY category;

-- 15. Shipping Mode Performance

-- Business Problem

-- The operations team wants to understand customer shipping preferences. 
-- Determine how many orders were shipped using each shipping mode and identify
-- the most frequently used shipping method. 
SELECT shipping_mode, COUNT(shipping_mode) AS mode_frequency
FROM data2
GROUP BY shipping_mode
ORDER BY mode_frequency DESC


