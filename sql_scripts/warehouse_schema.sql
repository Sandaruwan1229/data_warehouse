CREATE TABLE DimVendor (
    vendor_sk INT IDENTITY(1,1) PRIMARY KEY, 
    vendor_alt_id INT,                       
    name VARCHAR(200),
    legal_name VARCHAR(200),
    country VARCHAR(80),
    effective_from DATE,
    effective_to DATE,
    is_current BIT
);

CREATE TABLE DimProduct (
    product_sk INT IDENTITY(1,1) PRIMARY KEY,
    product_alt_id INT,
    name VARCHAR(200),
    category VARCHAR(100),
    uom VARCHAR(20)
);

CREATE TABLE DimEmployee (
    employee_sk INT IDENTITY(1,1) PRIMARY KEY,
    employee_alt_id INT,
    name VARCHAR(200),
    dept VARCHAR(100),
    email VARCHAR(200)
);

CREATE TABLE DimLocation (
    location_sk INT IDENTITY(1,1) PRIMARY KEY,
    location_alt_id INT,
    name VARCHAR(200),
    address VARCHAR(400)
);

CREATE TABLE DimContract (
    contract_sk INT IDENTITY(1,1) PRIMARY KEY,
    contract_alt_id INT,
    start_date DATE,
    end_date DATE,
    currency VARCHAR(10),
    status VARCHAR(20),
    agreed_price_amount DECIMAL(18,4)
);

-- 3. CREATE Facts using Surrogate Keys
CREATE TABLE FactPurchaseOrder (
    purchase_order_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    date_ordered_key INT, 
    vendor_sk INT,       
    product_sk INT,      
    employee_sk INT,     
    location_sk INT,     
    contract_sk INT NULL,
    purchase_method_id INT,
    qty_ordered DECIMAL(18,4),
    unit_price DECIMAL(18,4),
    agreed_price_amount DECIMAL(18,4) NULL,
    extended_cost AS (qty_ordered * unit_price) PERSISTED,
    currency VARCHAR(10),
    is_approved_vendor BIT
);

CREATE TABLE FactReceiptOrder (
    receipt_order_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    date_received_key INT,
    vendor_sk INT,
    product_sk INT,
    employee_sk INT,
    location_sk INT,
    receipt_no VARCHAR(100),
    qty_received DECIMAL(18,4),
    qty_accepted DECIMAL(18,4),
    qty_rejected DECIMAL(18,4),
    unit_price_at_receipt DECIMAL(18,4),
    extended_cost_received AS (qty_received * unit_price_at_receipt) PERSISTED,
    required_by_date_key INT NULL,
    delivery_lateness_days INT,
    on_time_flag BIT,
);
