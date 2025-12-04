/*
================================================
Quality checks 
================================================

Script purpose:
  This script performs various quality checks for data consistency , accuracy and standarization accross 'silver' schema.
  It includes checks for :
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields 
    - Data Standardization and consistency 
    - Invalid date range and orders 
    - Data consistency between related fields


Usage Notes :
  - Run these checks after loading silver layer
  - Investigate and resolve any discrepancies found during checks 

=================================================
*/


-- Checking silver layer  crm customer table

-- 1.Check for Nulls or Duplicates in primary key
-- Expectation : No Result

SELECT 
cst_id,
COUNT(*)
FROM 
silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL 


--2 Quality check
-- Check for unwanted spaces in string values.
-- Expectation - no results

-- TRIM() removes leading and trailing spaces

SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)


SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)


--3 Data Standardization & Consistency check

-- check consistency of values in low cardinality columns

-- In our datawarehouse we aim to store clear and meaningful values rather than using abbreviated terms 

SELECT DISTINCT cst_material_status
FROM silver.crm_cust_info

SELECT DISTINCT cst_gender
FROM silver.crm_cust_info


-- Checking silver layer  crm product table


SELECT * FROM silver.crm_prd_info

--1. Check for nulls or duplicates
-- expectation - No Result


SELECT
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

--2.Check for unwanted spaces
-- expectation - no result

SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm !=TRIM(prd_nm)

--3 Check for NULLS or Negative Numbers
-- Expectation : No Results

SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR  prd_cost IS NULL -- if NULL values are found , replace them with zero if bussiness allows.

--4.Data Standardization & Consistency

SELECT DISTINCT prd_line   -- M - Mountain , R - road , S - othersales , T - Touring
FROM silver.crm_prd_info

--5. Check for Invalid Date Orders

-- End date must not be earlier than start date

SELECT 
* 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt



-- Checking silver layer crm sales table

  
-- Invalid date - hierachy of dates

SELECT 
* 
FROM 
silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- Check Data consistency : Between Sales , Quantity and Price

-->> Sales = Quantity * Price


SELECT
sls_sales, 
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0  OR sls_price <= 0
ORDER BY sls_sales,sls_quantity,sls_price


SELECT * FROM silver.crm_sales_details



-- Checking silver layer erp cust table
  

SELECT * FROM silver.erp_cust_az12


-- 1 - length of dates

SELECT * FROM silver.erp_cust_az12   
WHERE LEN(cid) = 13


--2. Identify range of dates


SELECT DISTINCT 
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

--3. Distinct Gender 

SELECT DISTINCT
gen
FROM 
silver.erp_cust_az12


-- Checking silver layer erp loc table
  
-- Standardizing & Consistency

SELECT 
DISTINCT
cntry
FROM 
silver.erp_loc_a101


SELECT 
cid
FROM 
silver.erp_loc_a101






  

