SELECT
cst_id,
COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

SELECT 
cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);


SELECT prd_id , count(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

SELECT *
FROM bronze.crm_prd_info
WHERE prd_start_dt > prd_end_dt --- we catch unquality problem

SELECT *
FROM bronze.crm_prd_info
WHERE prd_cost < 0 or prd_cost IS NULL -- we catch an consistancy


SELECT *
FROM bronze.crm_sales_details
WHERE sls_due_dt < sls_ship_dt

SELECT DISTINCT gen
FROM bronze.erp_cust_az12

SELECT DISTINCT cntry
FROM bronze.erp_loc_a101



