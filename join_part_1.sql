--- 1

SELECT 
    c.name,
    o.order_id,
    o.order_date,
    o.shipment_date,
    (o.shipment_date - o.order_date) AS waiting_time
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.shipment_date IS NOT NULL
ORDER BY waiting_time DESC
LIMIT 1;


--- 2

WITH order_summary AS (
    SELECT 
        o.customer_id,
        COUNT(o.order_id) AS total_orders,
        AVG(o.shipment_date - o.order_date) AS avg_waiting_time,
        SUM(o.order_ammount) AS total_revenue
    FROM orders o
    WHERE o.shipment_date IS NOT NULL
    GROUP BY o.customer_id
)
SELECT 
    c.name,
    os.total_orders,
    os.avg_waiting_time,
    os.total_revenue
FROM order_summary os
JOIN customers c ON os.customer_id = c.customer_id
ORDER BY os.total_revenue DESC;


--- 3

WITH customer_delays AS (
    SELECT 
        o.customer_id,
        COUNT(CASE WHEN (o.shipment_date - o.order_date) > 5 THEN 1 END) AS delayed_shipments,
        COUNT(CASE WHEN o.order_status = 'Cancel' THEN 1 END) AS cancelled_orders,
        SUM(o.order_ammount) AS total_revenue
    FROM orders o
    GROUP BY o.customer_id
)
SELECT 
    c.name,
    cd.delayed_shipments,
    cd.cancelled_orders,
    cd.total_revenue
FROM customer_delays cd
JOIN customers c ON cd.customer_id = c.customer_id
ORDER BY cd.total_revenue DESC;
