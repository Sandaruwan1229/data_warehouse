select * from DimVendor;


select * from DimContract;
select * from DimProduct;
select * from DimEmployee;
select * from DimLocation;
select * from DimVendor;

select * from FactPurchaseOrder;
select * from FactReceiptOrder;


DELETE FROM FactReceiptOrder;
DELETE FROM FactPurchaseOrder;

DELETE FROM DimContract;
DELETE FROM DimProduct;
DELETE FROM DimEmployee;
DELETE FROM DimLocation;
DELETE FROM DimVendor;