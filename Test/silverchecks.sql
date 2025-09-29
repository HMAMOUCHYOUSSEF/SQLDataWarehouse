SELECT
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id


SELECT 
cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info


 