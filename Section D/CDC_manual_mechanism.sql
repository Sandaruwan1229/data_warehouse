CREATE TABLE DimVendor_Audit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    VendorID INT,
    OperationType NVARCHAR(10),
    ChangedDate DATETIME DEFAULT GETDATE(),
    OldVendorName NVARCHAR(100),
    NewVendorName NVARCHAR(100)
);

CREATE TRIGGER trg_DimVendor_Insert
ON dw.DimVendor
AFTER INSERT
AS
BEGIN
    INSERT INTO DimVendor_Audit (VendorID, OperationType, NewVendorName)
    SELECT vendor_id, 'INSERT', name
    FROM inserted;
END;

select * from dw.DimVendor;


CREATE TRIGGER trg_DimVendor_Update
ON dw.DimVendor
AFTER UPDATE
AS
BEGIN
    INSERT INTO DimVendor_Audit (VendorID, OperationType, OldVendorName, NewVendorName)
    SELECT d.vendor_id, 'UPDATE', d.name, i.name
    FROM deleted d
    JOIN inserted i ON d.vendor_id = i.vendor_id;
END;


CREATE TRIGGER trg_DimVendor_Delete
ON dw.DimVendor
AFTER DELETE
AS
BEGIN
    INSERT INTO DimVendor_Audit (VendorID, OperationType, OldVendorName)
    SELECT vendor_id, 'DELETE', name
    FROM deleted;
END;

INSERT INTO dw.DimVendor VALUES
 (101, 'Alpha Supplies','Alpha Supplies Pvt Ltd', 'Sri Lanka','2024-05-01', '2026-01-01', 1);
UPDATE dw.DimVendor SET name = 'Alpha and ABC Supplies Pvt Ltd' WHERE vendor_id = 101;
DELETE FROM dw.DimVendor WHERE vendor_id = 101;

SELECT * FROM DimVendor_Audit;