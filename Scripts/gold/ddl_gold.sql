/* 
based on these tables we can dived it into 
main three objects:
 - CUSTOMERS is dimentional table (discriptive table)
 - PRODUCTS is dimentional table (discriptive table)
 - ORDERS(transactions) is a factional table (has events to analyse)

 */

 ---CUSTOMER TABLE---
IF OBJECT_ID('gold.dim_customers','V') IS NOT NULL
	DROP VIEW gold.dim_customers
GO


 CREATE VIEW gold.dim_customers AS 
 SELECT 
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	cst_id AS customer_id,
	cst_key AS customer_number,
	cst_firstname AS first_name,
	cst_lastname AS last_name,
	bdate AS birthday,
	cst_marital_status As marital_status,
	CASE
		WHEN cst_gndr != 'n/a' THEN cst_gndr
		ELSE COALESCE(gen,'n/a')
	END gender,
	
	cntry AS country,
	cst_create_date as created_date

FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 co
ON co.cid = ca.cid
GO
----PRODUCT TABLE-----
IF OBJECT_ID('gold.dim_products','V') IS NOT NULL
	DROP VIEW gold.dim_products
GO

CREATE VIEW gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY prd_id) AS product_key,
	prd_id AS product_id,
	cat_id AS catalogue_id,
	subcat AS subcatalogue,
	maintenance,
	prd_key AS product_number,
	prd_nm AS product_name,
	prd_cost AS product_cost,
	prd_line AS product_line,
	prd_start_dt AS products_starting_date
FROM silver.crm_prd_info pin
LEFT JOIN silver.erp_px_cat_g1v2 px
ON px.id = pin.cat_id
WHERE prd_end_dt IS NULL
GO
---ORDER TABLE--------
IF OBJECT_ID('gold.fact_sales','V') IS NOT NULL
	DROP VIEW gold.fact_sales
GO
CREATE VIEW gold.fact_sales AS
SELECT
	sls_ord_num AS order_number,
	sls_prd_key AS product_number,
	sls_cust_id AS customer_id,
	sls_order_dt AS order_date,
	sls_ship_dt AS shipping_date,
	sls_due_dt AS due_date,
	sls_price AS sale_price,
	sls_quantity AS sale_quantity,
	sls_sales AS sales
FROM silver.crm_sales_details sa
LEFT JOIN gold.dim_customers cus
ON cus.customer_id = sa.sls_cust_id
LEFT JOIN gold.dim_products prd
ON sa.sls_prd_key = prd.product_number

	
GO
 
