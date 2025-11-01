IF OBJECT_ID('gold.customer_report','V') IS NOT NULL
    DROP VIEW gold.customer_report

GO
CREATE VIEW gold.customer_report AS 
WITH base_cte AS (
    SELECT 
        order_number,
        product_key,
        order_date,
        sales,
        sale_quantity,
        cr.customer_key,
        cr.customer_number,
        CONCAT(first_name,' ',last_name) AS customer_name, 
        DATEDIFF(YEAR,birthdate,GETDATE()) AS age
    FROM gold.fact_sales sa
    LEFT JOIN gold.dim_customers cr
        ON cr.customer_key = sa.customer_key
),
customer_aggregation AS (
    SELECT
        customer_key,
        customer_number,
        customer_name, 
        age,
        COUNT(DISTINCT order_number) AS total_order,
        SUM(sales) AS total_sales,
        SUM(sale_quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        MIN(order_date) AS first_order_date,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS livespan
    FROM base_cte 
    GROUP BY
        customer_key,
        customer_number,
        customer_name,
        age
)
SELECT
    customer_key,
    customer_number,
    customer_name, 
    age,
    CASE 
        WHEN age BETWEEN 15 AND 30 THEN 'Young'
        WHEN age BETWEEN 31 AND 50 THEN 'Middle Age'  -- Fixed spelling
        WHEN age > 50 THEN 'Old'
        ELSE 'Unknown'  -- Handle NULLs or out-of-range values
    END AS age_states,
    total_order,
    total_sales,
    total_quantity,
    livespan,
    last_order_date,
    CASE
        WHEN total_sales > 5000 AND DATEDIFF(MONTH, first_order_date, last_order_date) >= 12 
            THEN 'VIP'
        WHEN total_sales < 5000 AND DATEDIFF(MONTH, first_order_date, last_order_date) >= 12
            THEN 'Regular'
        ELSE 'New'
    END AS customer_type,
    total_products,
    CASE WHEN total_order = 0 THEN 0
        ELSE total_sales / total_order
    END avg_sale_order,
    CASE WHEN livespan = 0 THEN total_sales
        ELSE total_sales / livespan
    END avg_sale_livespan

FROM customer_aggregation;


