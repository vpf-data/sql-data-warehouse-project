
/* 
=================================

Create Database and Schemas

=================================

Script purpose:
 This script creates a new database named 'DataWarehouse' after checking if it already exists.
 If the database exists,it is dropped and recreated. Additionally , script sets three schemas
 within the database : 'bronze','silver','gold'

 WARNING:
	Running this script will drop the entire 'Datawarehouse' database if it exists.
	All data in the database will be permenanetly deleted . Proceed with caution 
	and ensure you have proper backups before running this script 
*/

USE master;
GO

--Drop and recreate the 'DataWarehouse'database

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO


CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

CREATE SCHEMA Bronze;
GO

CREATE SCHEMA Silver;
GO

CREATE SCHEMA Gold;
GO

