SELECT 
    p.name AS Product,
    SUM(f.qty_ordered) AS TotalQtyOrdered,
    SUM(f.extended_cost) AS TotalSpend,
    COUNT(DISTINCT v.vendor_alt_id) AS SupplierCount
FROM FactPurchaseOrder f
JOIN DimProduct p ON f.product_sk = p.product_sk
JOIN DimVendor v ON f.vendor_sk = v.vendor_sk
GROUP BY p.name
ORDER BY TotalQtyOrdered DESC;

SELECT 
    p.name AS Product,
    p.category AS ProductCategory,
    SUM(f.qty_ordered) AS TotalQtyOrdered,
    SUM(f.extended_cost) AS TotalSpend,
    COUNT(DISTINCT f.vendor_sk) AS SupplierCount,
    ROUND(SUM(f.extended_cost) / NULLIF(SUM(f.qty_ordered),0), 2) AS AvgUnitCost
FROM FactPurchaseOrder f
JOIN DimProduct p ON f.product_sk = p.product_sk
GROUP BY p.name, p.category
ORDER BY TotalQtyOrdered DESC;

SELECT 
    p.name AS Product,
    l.name AS Location,
    ROUND(SUM(f.extended_cost) / NULLIF(SUM(f.qty_ordered),0), 2) AS AvgUnitPrice,
    COUNT(DISTINCT f.vendor_sk) AS VendorCount
FROM FactPurchaseOrder f
JOIN DimProduct p ON f.product_sk = p.product_sk
JOIN DimLocation l ON f.location_sk = l.location_sk
GROUP BY p.name, l.name
ORDER BY p.name, l.name;

SELECT 
    CASE 
        WHEN f.is_approved_vendor = 1 THEN 'Contract Purchase'
        ELSE 'Maverick Spend' 
    END AS SpendType,
    COUNT(*) AS Orders,
    SUM(f.extended_cost) AS TotalSpend,
    ROUND(100.0 * SUM(f.extended_cost) / SUM(SUM(f.extended_cost)) OVER(), 2) AS SpendPercent
FROM FactPurchaseOrder f
GROUP BY f.is_approved_vendor;

SELECT 
    v.name AS Vendor,
    p.name AS Product,
    f.unit_price AS ActualPrice,
    f.agreed_price_amount AS AgreedPrice,
    (f.unit_price - ISNULL(f.agreed_price_amount, 0)) AS PriceVariance
FROM FactPurchaseOrder f
JOIN DimVendor v ON f.vendor_sk = v.vendor_sk
JOIN DimProduct p ON f.product_sk = p.product_sk
WHERE f.agreed_price_amount IS NOT NULL;

SELECT 
    v.name AS Vendor,
    COUNT(*) AS TotalReceipts,
    SUM(CASE WHEN r.on_time_flag = 1 THEN 1 ELSE 0 END) AS OnTimeDeliveries,
    ROUND(100.0 * SUM(CASE WHEN r.on_time_flag = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS OnTimePercent,
    ROUND(100.0 * SUM(r.qty_rejected) / NULLIF(SUM(r.qty_received),0), 2) AS RejectionRatePercent
FROM FactReceiptOrder r
JOIN DimVendor v ON r.vendor_sk = v.vendor_sk
GROUP BY v.name;