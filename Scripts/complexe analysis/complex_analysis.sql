-- analyse over time

SELECT 
	DATETRUNC(month,order_date) AS order_year,
	COUNT(DISTINCT customer_key) AS customers,
	SUM(sales) AS sales_amounts
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month,order_date)
ORDER BY DATETRUNC(month,order_date) DESC

-- analyse over comulations --

SELECT 
	DATETRUNC(MONTH,order_date),
	SUM(sales)
FROM gold.fact_sales
GROUP BY DATETRUNC(MONTH,order_date)
ORDER BY DATETRUNC(MONTH,order_date)


SELECT
	order_months,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_months)	 AS comutive_sales
FROM (
	SELECT 
		DATETRUNC(MONTH,order_date) AS order_months,
		SUM(sales) AS total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(MONTH,order_date)

)t

--- retype the code without see it ---

SELECT 
	row_num,
	year_date,
	month_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY row_num) AS YTD
FROM (
	SELECT 
		ROW_NUMBER() OVER(ORDER BY YEAR(order_date), MONTH(order_date))  AS row_num,
		YEAR(order_date) AS year_date,
		MONTH(order_date) AS month_date,
		SUM(sales) AS total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY YEAR(order_date) ,MONTH(order_date)
)t;


-- perfomance analysis --

SELECT 
	order_year,
	product_name,
	total_sales,
	AVG(total_sales) OVER (PARTITION BY product_name) avr_sales,
	total_sales - AVG(total_sales) OVER (PARTITION BY product_name) AS avg_diff,
	CASE 
		WHEN total_sales - AVG(total_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above AVG'
		WHEN total_sales - AVG(total_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below AVG'
		ELSE 'AVG'
	END,
	LAG(total_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS previous_year,
	total_sales - LAG(total_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS year_diff

	
FROM (
	SELECT
		YEAR(order_date) AS order_year,
		product_name,
		SUM(sales) AS total_sales 
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_products dp
	ON fs.product_key = dp.product_key
	WHERE order_date IS NOT NULL
	GROUP BY YEAR(order_date) , product_name
)t

--- one from all analysis ---
WITH category_sales AS (
SELECT 
	ROW_NUMBER() OVER (ORDER BY SUM(sales)) AS cat_rank,
	category,
	SUM(sales) AS total_sales
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
GROUP BY category

)
SELECT 
	category,
	total_sales,
	SUM(total_sales) OVER () sum_sales,
	CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ())*100,2),'%') AS persentage
FROM category_sales
ORDER BY persentage DESC

-- data segumentations --

WITH cost_range AS (
SELECT 
	product_key,
	product_name,
	SUM(cost) AS total_cost,
	CASE 
		WHEN SUM(cost) <= 500 THEN 'Below 500'
		WHEN SUM(cost) BETWEEN 500 AND 1000 THEN '1000-500'
		WHEN SUM(cost) >= 1000 THEN 'Above 1000'
	END	cost_state
FROM gold.dim_products
GROUP BY product_key, product_name
)
SELECT 
	cost_state,
	COUNT(product_name) AS state_numbers
FROM cost_range
GROUP BY cost_state
ORDER BY COUNT(product_name) DESC

-- anther quary ---
WITH customer_types AS
(
SELECT 
	cus.customer_key,
	CONCAT(first_name,' ',last_name) AS customer_name,
	MAX(order_date) AS max_ordre_date,
	MIN(order_date) AS min_order_date,
	DATEDIFF(month,MIN(order_date),MAX(order_date)) live_span,
	SUM(sales) AS sales_contributed,
	CASE
		WHEN SUM(sales) > 5000 AND DATEDIFF(month,MIN(order_date),MAX(order_date)) >= 12 
			THEN 'VIP'
		WHEN SUM(sales) < 5000 AND DATEDIFF(month,MIN(order_date),MAX(order_date)) >= 12
			THEN 'Regular'
		ELSE 'New'
	END customer_type
FROM gold.fact_sales sa
LEFT JOIN gold.dim_customers cus
ON cus.customer_key = sa.customer_key
GROUP BY cus.customer_key , CONCAT(first_name,' ',last_name)
)

SELECT 
	customer_type,
	COUNT(customer_type)
FROM customer_types
GROUP BY customer_type












