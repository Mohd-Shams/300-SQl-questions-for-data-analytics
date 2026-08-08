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
WHERE rn = 1




                    
