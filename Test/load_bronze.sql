CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start DATETIME,@end DATETIME,@b_start DATETIME, @b_end DATETIME;
	BEGIN TRY
		TRUNCATE TABLE bronze.crm_cust_info
		SET @start = GETDATE();
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\pc\OneDrive - um5.ac.ma\ENSIAS\REAL WORK\TheCoreProject\Datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end = GETDATE();

		PRINT('it takes ' + CAST(DATEDIFF(second,@start,@end) AS NVARCHAR)+' seconds ');
		TRUNCATE TABLE bronze.crm_prd_info

		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\pc\OneDrive - um5.ac.ma\ENSIAS\REAL WORK\TheCoreProject\Datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		TRUNCATE TABLE bronze.crm_sales_details
		SET @start = GETDATE();
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\pc\OneDrive - um5.ac.ma\ENSIAS\REAL WORK\TheCoreProject\Datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end = GETDATE();
		PRINT('it takes ' + CAST(DATEDIFF(second,@start,@end) AS NVARCHAR)+' seconds ');
		TRUNCATE TABLE bronze.erp_cust_az12
		SET @start = GETDATE();
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\pc\OneDrive - um5.ac.ma\ENSIAS\REAL WORK\TheCoreProject\Datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);
		SET @end = GETDATE();
		PRINT('it takes ' + CAST(DATEDIFF(second,@start,@end) AS NVARCHAR)+' seconds ');
		TRUNCATE TABLE bronze.erp_loc_a101
		SET @start = GETDATE();
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\pc\OneDrive - um5.ac.ma\ENSIAS\REAL WORK\TheCoreProject\Datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end = GETDATE();
		PRINT('it takes ' + CAST(DATEDIFF(second,@start,@end) AS NVARCHAR)+' seconds ');
		TRUNCATE TABLE bronze.erp_px_cat_g1v2
		SET @start = GETDATE();
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\pc\OneDrive - um5.ac.ma\ENSIAS\REAL WORK\TheCoreProject\Datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end = GETDATE();
		PRINT('it takes ' + CAST(DATEDIFF(second,@start,@end) AS NVARCHAR)+' seconds ');
	END TRY
	BEGIN CATCH
		PRINT('========');
		PRINT('ahhh look look:' + ERROR_MESSAGE() + CAST(ERROR_NUMBER() AS NVARCHAR) + CAST(ERROR_STATE() AS NVARCHAR));
	END CATCH
END