-- creating the product report --

-- base cte --
IF OBJECT_ID('gold.product_report','V') IS NOT NULL
    DROP VIEW gold.product_report

GO
CREATE VIEW gold.product_report AS 
WITH product_base AS(
SELECT
	order_number,
	order_date,
	sale_quantity,
	sales,
    pd.product_key,
	product_number,
	product_name,
    category,
    subcategory,
    maintenance,
    cost,
    DATEDIFF(YEAR,start_date,GETDATE()) product_age
FROM gold.fact_sales sf
LEFT JOIN gold.dim_products pd
ON sf.product_key = pd.product_key
),
product_aggregations AS (
SELECT 
    product_key,
	product_number,
	product_name,
    category,
    subcategory,
    maintenance,
    product_age,
    SUM(sales) total_sales,
    COUNT(DISTINCT order_number) total_orders,
    SUM(cost) total_cost,
    SUM(sale_quantity) total_quantity,
    AVG(SUM(sales)) OVER (PARTITION BY product_name) avg_sales
FROM product_base
GROUP BY 
    product_key,
	product_number,
	product_name,
    category,
    subcategory,
    maintenance,
    product_age
)

SELECT
    product_key,
	product_number,
	product_name,
    category,
    subcategory,
    maintenance,
    product_age,
    total_sales,
    CASE 
		WHEN total_sales - avg_sales > 0 THEN 'Above AVG'
		WHEN total_sales - avg_sales < 0 THEN 'Below AVG'
		ELSE 'AVG'
	END sale_state,
    total_orders,
    total_cost,
    CASE 
		WHEN total_cost <= 500 THEN 'Below 500'
		WHEN total_cost BETWEEN 500 AND 1000 THEN '1000-500'
		WHEN total_cost >= 1000 THEN 'Above 1000'
	END	cost_state,
    total_quantity 
FROM product_aggregations