-- 36. Most Returned Product in Every Category
-- Business Problem

-- The quality assurance team wants to identify the product with the highest number of returned orders in each product category.USE sql300;


WITH return_ AS(SELECT
        category,
        product_name,
        SUM(
            CASE
                WHEN return_status = 'YES' THEN 1
                ELSE 0
            END
        ) AS returned_orders
    FROM data3
    GROUP BY category, product_name),
    
    
rankings AS(SELECT 
				category,
                product_name,
                returned_orders,
                ROW_NUMBER() OVER (PARTITION BY category
							ORDER BY returned_orders DESC) AS rn
                            FROM return_)

SELECT category,
product_name,
returned_orders
FROM rankings
WHERE rn = 1;



-- 37. Revenue Contribution of Each Region
-- Business Problem

-- The executive team wants to determine what percentage of the company's total revenue is contributed by each region.

SELECT region,
		ROUND(SUM(total_amount),2)AS total_revenue ,
        ROUND((SUM(total_amount)/(SELECT SUM(total_amount) FROM data3)*100),2) AS rev_contribution
FROM data3
GROUP BY region


38. Customers Purchasing in Multiple Categories
Business Problem

The marketing team wants to identify customers who have purchased products from three or more
different categories for cross-selling opportunities.

from 










                    
