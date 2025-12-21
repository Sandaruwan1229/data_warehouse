CREATE TABLE Sales (
    TransactionID VARCHAR(50),
    DateKey INT,
    StoreKey INT,
    ProductKey INT,
    Quantity INT,
    Amount DECIMAL(18,2)
);


-- TRANSACTION 101: The "Classic Pair" (Milk & Bread)
-- Expectation: 1 Row in Fact table (10 & 20)
INSERT INTO Sales (TransactionID, DateKey, StoreKey, ProductKey, Quantity, Amount) VALUES
('T101', 20251221, 100, 10, 1, 5.00), -- Product 10
('T101', 20251221, 100, 20, 2, 8.00); -- Product 20

-- TRANSACTION 102: The "Three Item Basket" (A, B, C)
-- Expectation: 3 Rows in Fact table (30-40, 30-50, 40-50)
INSERT INTO Sales (TransactionID, DateKey, StoreKey, ProductKey, Quantity, Amount) VALUES
('T102', 20251221, 100, 30, 1, 12.00), -- Product 30
('T102', 20251221, 100, 40, 1, 4.00),  -- Product 40
('T102', 20251221, 100, 50, 5, 20.00); -- Product 50

-- TRANSACTION 103: The "Loner" (Single Item)
-- Expectation: 0 Rows (Cannot make a pair with itself)
INSERT INTO Sales (TransactionID, DateKey, StoreKey, ProductKey, Quantity, Amount) VALUES
('T103', 20251222, 200, 60, 1, 100.00);

-- TRANSACTION 104: The "Big Basket" (4 Items)
-- Expectation: 6 Rows (Combinations of 4 items taken 2 at a time)
INSERT INTO Sales (TransactionID, DateKey, StoreKey, ProductKey, Quantity, Amount) VALUES
('T104', 20251222, 200, 10, 1, 5.00),
('T104', 20251222, 200, 20, 1, 8.00),
('T104', 20251222, 200, 30, 1, 12.00),
('T104', 20251222, 200, 40, 1, 4.00);

-- TRANSACTION 105: Same products as T101 but different date/store
-- Expectation: 1 Row (10 & 20), distinct from the first transaction
INSERT INTO Sales (TransactionID, DateKey, StoreKey, ProductKey, Quantity, Amount) VALUES
('T105', 20250101, 500, 10, 2, 10.00),
('T105', 20250101, 500, 20, 2, 8.00);

-- Fact table

CREATE TABLE FactMarketBasket (
    DateKey INT,
    StoreKey INT,
    ProductKey_A INT,
    ProductKey_B INT,
    Qty_A INT,
    Qty_B INT,
    Amt_A DECIMAL(18,2),
    Amt_B DECIMAL(18,2)
);

select * from Sales;
select * from FactMarketBasket;

delete from FactMarketBasket;