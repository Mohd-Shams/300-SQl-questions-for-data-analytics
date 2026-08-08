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
GROUP BY region;


-- 38. Customers Purchasing in Multiple Categories
-- Business Problem

-- The marketing team wants to identify customers who have purchased products from three or more
-- different categories for cross-selling opportunities.

SELECT customer_id ,customer_name,COUNT(DISTINCT category)AS diff_categories
FROM data3
GROUP BY customer_id,customer_name
HAVING diff_categories >=3;

-- 39. Most Popular Shipping Mode by Region
-- Business Problem

-- The logistics team wants to identify the most frequently used shipping mode in each region.
WITH ship AS(SELECT
        region,
        shipping_mode,
		COUNT(shipping_mode) AS mode_count
    FROM data3
    GROUP BY region,shipping_mode),
    
frequently AS(SELECT region,
				shipping_mode,
				mode_count,
                ROW_NUMBER() OVER (PARTITION BY region 
									ORDER BY mode_count DESC) AS rn
				FROM ship )
                                    
SELECT region,shipping_mode,mode_count
FROM frequently
WHERE rn  = 1;

-- 40. Revenue Trend by Quarter
-- Business Problem

-- The finance department wants to analyze quarterly revenue trends to understand seasonal business performance.

SELECT
    YEAR(STR_TO_DATE(order_date, '%m/%d/%Y')) AS year,
    QUARTER(STR_TO_DATE(order_date, '%m/%d/%Y')) AS quarter,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM data3
GROUP BY
    YEAR(STR_TO_DATE(order_date, '%m/%d/%Y')),
    QUARTER(STR_TO_DATE(order_date, '%m/%d/%Y'))
ORDER BY
    year,
    quarter;
    






                    
