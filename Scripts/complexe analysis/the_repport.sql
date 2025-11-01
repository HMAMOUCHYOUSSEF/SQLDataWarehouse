
-- les create our customer report --

-- create the CTE base -- 

SELECT 
	order_number,
	product_key,
	cr.customer_key,
	order_date,
	sales,
	sale_quantity,
	birthdate
FROM gold.fact_sales sa
LEFT JOIN gold.dim_customers cr
ON cr.customer_key = sa.customer_key