--- 1

SELECT 
    p.product_category,
    SUM(o.order_amount) AS total_sales
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_category;


--- 2


SELECT product_category
FROM (
    SELECT 
        p.product_category,
        SUM(o.order_amount) AS total_sales
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY p.product_category
) AS category_sales
ORDER BY total_sales DESC
LIMIT 1;



--- 3


SELECT 
    category_sales.product_category,
    category_sales.product_name,
    category_sales.max_sales
FROM (
    SELECT 
        p.product_category,
        p.product_name,
        SUM(o.order_amount) AS max_sales,
        RANK() OVER (PARTITION BY p.product_category ORDER BY SUM(o.order_amount) DESC) AS rank
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY p.product_category, p.product_name
) AS category_sales
WHERE category_sales.rank = 1;

