CREATE DATABASE assessment;

EXEC sys.sp_cdc_enable_db;

SELECT name, is_cdc_enabled FROM sys.databases WHERE name = 'assessment';

EXEC sys.sp_cdc_disable_table
    @source_schema = N'dw',
    @source_name   = N'DimVendor',
    @capture_instance = N'dw_DimVendor';
GO

EXEC sys.sp_cdc_enable_table
    @source_schema = N'dw',
    @source_name   = N'DimVendor',
    @role_name     = NULL;

SELECT name, is_tracked_by_cdc
FROM sys.tables
WHERE name = 'DimVendor';


SELECT *
FROM cdc.dw_DimVendor_CT;

select * from dw.DimVendor;


INSERT INTO dw.DimVendor VALUES (11, 'XYZ Vendor', 'XYZ Pvt Ltd','Sri Lanka', '2024-01-01', '2024-05-01', 1);
UPDATE dw.DimVendor
SET name = 'Global Supplies Pvt Ltd'
WHERE vendor_id = 11;

SELECT *
FROM cdc.dw_DimVendor_CT;


