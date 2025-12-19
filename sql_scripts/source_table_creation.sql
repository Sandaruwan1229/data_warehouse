CREATE TABLE Vendor (
    vendor_id INT PRIMARY KEY,
    name VARCHAR(200),
    legal_name VARCHAR(200),
    country VARCHAR(80),
    email VARCHAR(200),
    status VARCHAR(20),
    created_at DATETIME2,
    updated_at DATETIME2
);

select * from Vendor;

CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    name VARCHAR(200),
    category VARCHAR(100),
    uom VARCHAR(20),
    created_at DATETIME2,
    updated_at DATETIME2
);

select * from Product;

CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    name VARCHAR(200),
    dept VARCHAR(100),
    email VARCHAR(200)
);

select * from Employee;

CREATE TABLE Location (
    location_id INT PRIMARY KEY,
    name VARCHAR(200),
    address VARCHAR(400)
);

select * from Location;

CREATE TABLE ContractHeader (
    contract_header_id INT PRIMARY KEY,
    vendor_id INT REFERENCES Vendor(vendor_id),
    start_date DATE,
    end_date DATE,
    currency VARCHAR(10),
    contract_owner_emp_id INT REFERENCES Employee(employee_id),
    status VARCHAR(20)
);

select * from ContractHeader;

CREATE TABLE Contract (
    contract_id INT PRIMARY KEY,
    contract_header_id INT REFERENCES ContractHeader(contract_header_id),
    product_id INT REFERENCES Product(product_id),
    agreed_price_amount DECIMAL(18,4),
    price_uom VARCHAR(20)
);

select * from Contract;

CREATE TABLE OrderHeader (
    order_header_id INT PRIMARY KEY,
    vendor_id INT REFERENCES Vendor(vendor_id),
    requested_by_emp_id INT REFERENCES Employee(employee_id),
    created_date DATE,
    required_by_date DATE,
    currency VARCHAR(10),
    location_id INT REFERENCES Location(location_id),
    status VARCHAR(20)
);

select * from OrderHeader;

CREATE TABLE OrderDetails(
    order_id INT PRIMARY KEY,
    order_header_id INT REFERENCES OrderHeader(order_header_id),
    product_id INT REFERENCES Product(product_id),
    qty_ordered DECIMAL(18,4),
    unit_price DECIMAL(18,4),
    currency VARCHAR(10),
    contract_id INT NULL REFERENCES Contract(contract_id),
    is_approved_vendor BIT,
    created_date DATETIME2
);

select * from OrderDetails;

CREATE TABLE ReceiptHeader (
    receipt_header_id INT PRIMARY KEY,
    order_header_id INT REFERENCES OrderHeader(order_header_id),
    receipt_date DATE,
    received_by_emp_id INT REFERENCES Employee(employee_id),
    location_id INT REFERENCES Location(location_id),
    status VARCHAR(20)
);

select * from  ReceiptHeader;

CREATE TABLE Receipt (
    receipt_id INT PRIMARY KEY,
    receipt_header_id INT REFERENCES ReceiptHeader(receipt_header_id),
    order_id INT REFERENCES OrderDetails(order_id),
    qty_received DECIMAL(18,4),
    qty_accepted DECIMAL(18,4),
    qty_rejected DECIMAL(18,4),
    inspection_result VARCHAR(50),
    delivery_date DATE
);

select * from Receipt;