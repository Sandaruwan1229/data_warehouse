drop table sales_fact;

CREATE TABLE sales_fact (
    sale_id       INT ,
    product_id    INT,
    region         VARCHAR(20),
    sale_date      DATE,
    sales_amount   DECIMAL(10,2)
);

WITH n AS (
    SELECT TOP (100000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS num
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO sales_fact (product_id, region, sale_date, sales_amount)
SELECT
    ABS(CHECKSUM(NEWID())) % 1000 + 1,
    CASE ABS(CHECKSUM(NEWID())) % 4
        WHEN 0 THEN 'NORTH'
        WHEN 1 THEN 'SOUTH'
        WHEN 2 THEN 'EAST'
        ELSE 'WEST'
    END,
    DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 365), GETDATE()),
    CAST(ABS(CHECKSUM(NEWID())) % 5000 / 10.0 AS DECIMAL(10,2))
FROM n;

SELECT COUNT(*) FROM sales_fact;
delete from sales_fact;

-- Baseline query (NO INDEX)
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT region, SUM(sales_amount) AS total_sales
FROM sales_fact
WHERE sale_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY region;

-- B-Tree Index
CREATE NONCLUSTERED INDEX idx_sales_date
ON sales_fact (sale_date)
INCLUDE (region, sales_amount);

-- Proof Query
SELECT 
    name AS IndexName, 
    type_desc AS IndexType 
FROM sys.indexes 
WHERE object_id = OBJECT_ID('sales_fact') 
  AND name = 'idx_sales_date';

-- Columnstore Index
CREATE CLUSTERED COLUMNSTORE INDEX cci_sales_fact
ON sales_fact;


SELECT name, type_desc
FROM sys.indexes
WHERE object_id = OBJECT_ID('sales_fact')
  AND name = 'cci_sales_fact';