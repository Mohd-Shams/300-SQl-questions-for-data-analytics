-- 6. Which states or cities contribute the highest sales?
SELECT 
city,
SUM(total_amount) AS Total_sales
FROM ecommerce_merged_dataset
GROUP BY city
ORDER BY Total_sales DESC
LIMIT 10;

-- 7.What is the average order value (AOV)?
SELECT ROUND(AVG(total_amount),2)
FROM ecommerce_merged_dataset;

-- 8.Which customers placed more than five orders?
SELECT customer_id,customer_name, COUNT(quantity)AS order_count
FROM ecommerce_merged_dataset
GROUP BY customer_id ,customer_name
HAVING order_count > 5
ORDER BY order_count DESC;


-- 9.High-Value Customers

-- Identify customers whose spending is above the average customer spending.
SELECT customer_id,customer_name,SUM(total_amount)
FROM ecommerce_merged_dataset
WHERE total_amount > (SELECT ROUND(AVG(total_amount),2)
FROM ecommerce_merged_dataset)
GROUP BY customer_id ,customer_name;

-- 10. Repeat Purchase Rate

-- Find customers who bought the same product more than once.
SELECT customer_id,
       customer_name,
       product_name,
       COUNT(product_name) AS purchase_count 
FROM ecommerce_merged_dataset

GROUP BY customer_id,
       customer_name,
       product_name
HAVING  purchase_count>1
