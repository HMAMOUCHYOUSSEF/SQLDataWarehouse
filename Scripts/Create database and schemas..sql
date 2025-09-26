/* 
	So here i created a script that creates
	our database and its schemas to start work

	WARNING: 
	do not execute this code if you are already build
	many tables on this database otherwise you will 
	deleted.

*/

USE master;
go
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse');
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;

go
CREATE DATABASE DataWarehouse;
go
USE DataWarehouse;
go
create schema bronze;
go 
create schema silver;
go
create schema gold;

