-- 1. Setup Static Data (Vendor, Product, Employee, Location)
INSERT INTO Vendor (vendor_id, name, legal_name, country, email, status, created_at, updated_at) VALUES
(1, 'TechSource', 'TechSource Solutions Ltd', 'Sri Lanka', 'contact@techsource.lk', 'Active', SYSDATETIME(), SYSDATETIME()),
(2, 'OfficeMart', 'Office Mart Global', 'USA', 'sales@officemart.com', 'Active', SYSDATETIME(), SYSDATETIME());

INSERT INTO Product (product_id, name, category, uom, created_at, updated_at) VALUES
(101, 'Dell Latitude Laptop', 'IT Equipment', 'Unit', SYSDATETIME(), SYSDATETIME()),
(102, 'Ergonomic Chair', 'Furniture', 'Unit', SYSDATETIME(), SYSDATETIME());

INSERT INTO Employee (employee_id, name, dept, email) VALUES
(501, 'Sandaruwan', 'Engineering', 'sandaruwan@abc.com'),
(502, 'Manager John', 'Procurement', 'john@abc.com');

INSERT INTO Location (location_id, name, address) VALUES
(1, 'Colombo HQ', '123 Galle Road, Colombo'),
(2, 'Kandy Branch', '45 Hill Street, Kandy');

-- 2. Setup Contracts (TechSource gives us Laptops at 150,000)
INSERT INTO ContractHeader (contract_header_id, vendor_id, start_date, end_date, currency, contract_owner_emp_id, status) VALUES
(1001, 1, '2024-01-01', '2025-12-31', 'LKR', 502, 'Active');

INSERT INTO Contract (contract_id, contract_header_id, product_id, agreed_price_amount, price_uom) VALUES
(2001, 1001, 101, 150000.00, 'Unit'); 

-- 3. Create Orders 
-- Order A: Buying Laptops within contract (Good)
INSERT INTO OrderHeader (order_header_id, vendor_id, requested_by_emp_id, created_date, required_by_date, currency, location_id, status) VALUES
(5001, 1, 501, '2025-01-10', '2025-01-20', 'LKR', 1, 'Approved');

INSERT INTO OrderDetails (order_id, order_header_id, product_id, qty_ordered, unit_price, currency, contract_id, is_approved_vendor, created_date) VALUES
(1, 5001, 101, 10, 150000.00, 'LKR', 2001, 1, '2025-01-10');

-- Order B: Maverick Spend! Buying Chairs from OfficeMart without contract (Bad)
INSERT INTO OrderHeader (order_header_id, vendor_id, requested_by_emp_id, created_date, required_by_date, currency, location_id, status) VALUES
(5002, 2, 501, '2025-02-01', '2025-02-10', 'USD', 2, 'Approved');

INSERT INTO OrderDetails (order_id, order_header_id, product_id, qty_ordered, unit_price, currency, contract_id, is_approved_vendor, created_date) VALUES
(2, 5002, 102, 5, 200.00, 'USD', NULL, 0, '2025-02-01');

-- 4. Create Receipts
-- Receipt A: Laptops received LATE (Required 20th, Received 25th)
INSERT INTO ReceiptHeader (receipt_header_id, order_header_id, receipt_date, received_by_emp_id, location_id, status) VALUES
(6001, 5001, '2025-01-25', 501, 1, 'Closed');

INSERT INTO Receipt (receipt_id, receipt_header_id, order_id, qty_received, qty_accepted, qty_rejected, inspection_result, delivery_date) VALUES
(7001, 6001, 1, 10, 9, 1, '1 Damaged Screen', '2025-01-25');