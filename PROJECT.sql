WITH CustomerStats AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS full_name,
        COUNT(o.order_id) AS total_orders,
        SUM(o.total_amount) AS total_spent,
        MAX(o.order_date) AS last_purchase_date
    FROM 
        customers c
    LEFT JOIN 
        orders o ON c.customer_id = o.customer_id
    GROUP BY 
        c.customer_id, full_name
)

SELECT 
    full_name,
    total_orders,
    total_spent,
    last_purchase_date,
    CASE 
        WHEN last_purchase_date < CURRENT_DATE - INTERVAL '6 months' THEN 'At Risk (Churn)'
        WHEN total_spent > 1000 AND total_orders > 5 THEN 'VIP Customer'
        ELSE 'Active Customer'
    END AS customer_segment
FROM 
    CustomerStats
ORDER BY 
    total_spent DESC;