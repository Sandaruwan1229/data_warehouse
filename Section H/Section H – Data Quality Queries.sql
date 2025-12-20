CREATE TABLE orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    order_date DATE,
    customer_name VARCHAR(100),
    order_amount DECIMAL(10,2)
);

INSERT INTO orders (order_date, customer_name, order_amount) VALUES
('2024-01-01', 'Kamal Perera', 1500),
('2024-01-02', 'Kamal Perea', 2200),
('2024-01-03', 'Kamal Perara', 1800),
('2024-01-04', 'Kamal Perera', 2500),
('2024-01-05', 'Nimal Silva', 1200),
('2024-01-06', 'Nimal Silwa', 1600),
('2024-01-07', 'Nimal Silva', 2000);

select * from orders;

-- Step 2: Identify the Issue (Proof)
SELECT
    customer_name,
    SOUNDEX(customer_name) AS soundex_code
FROM orders;

-- Create Dimension Table
CREATE TABLE dim_customer (
    customer_key INT IDENTITY(1,1) PRIMARY KEY,
    canonical_name VARCHAR(100),
    soundex_code CHAR(4)
);

select * from dim_customer;

-- Load Clean Data into Dimension
;WITH name_frequency AS (
    SELECT
        customer_name,
        SOUNDEX(customer_name) AS soundex_code,
        COUNT(*) AS occurrence_count
    FROM orders
    GROUP BY customer_name
),
canonical_names AS (
    SELECT
        customer_name,
        soundex_code
    FROM (
        SELECT
            customer_name,
            soundex_code,
            occurrence_count,
            ROW_NUMBER() OVER (
                PARTITION BY soundex_code
                ORDER BY occurrence_count DESC, customer_name
            ) AS rn
        FROM name_frequency
    ) t
    WHERE rn = 1
)
INSERT INTO dim_customer (canonical_name, soundex_code)
SELECT
    customer_name,
    soundex_code
FROM canonical_names;

select * from dim_customer;

-- Load Fact Table Using Dimension Table
CREATE TABLE fact_orders (
    order_id INT,
    customer_key INT,
    customer_name VARCHAR(100),
    order_date DATE,
    order_amount DECIMAL(10,2)
);

select * from fact_orders;

-- Load Fact Data
INSERT INTO fact_orders
SELECT
    o.order_id,
    d.customer_key,
    d.canonical_name,
    o.order_date,
    o.order_amount
FROM orders o
JOIN dim_customer d
    ON SOUNDEX(o.customer_name) = d.soundex_code;

select * from fact_orders;
select * from orders;