USE DataWarehouse

--lets discover data ---

SELECT * FROM INFORMATION_SCHEMA.COLUMNS

-- dimentionnal exploration ---

SELECT DISTINCT category
FROM gold.dim_products

SELECT DISTINCT country
FROM gold.dim_customers

SELECT DISTINCT country 
FROM gold.dim_customers

-- and you can do more.....

-- lets know do some data exploration --

SELECT
MAX(order_date) AS max_order_date,
MIN(order_date) AS min_order_date,
DATEDIFF(YEAR,MIN(order_date),MAX(order_date)) AS business_age
FROM gold.fact_sales

-- The same thing

-- Which five products that generates the highest value --

SELECT TOP 5
	pr.subcategory,
	SUM(sales) AS total_revenue
FROM gold.fact_sales sa
LEFT JOIN gold.dim_products pr
ON sa.product_key = sa.product_key
GROUP BY pr.subcategory
ORDER BY total_revenue DESC

-- using anther method --
SELECT *
FROM (
	SELECT
		pr.subcategory,
		SUM(sales) AS total_revenue,
		ROW_NUMBER() OVER (ORDER BY SUM(sales) DESC ) AS ranked_products
	FROM gold.fact_sales sa
	LEFT JOIN gold.dim_products pr
	ON sa.product_key = sa.product_key
	GROUP BY pr.subcategory
	)t
WHERE ranked_products <= 5;