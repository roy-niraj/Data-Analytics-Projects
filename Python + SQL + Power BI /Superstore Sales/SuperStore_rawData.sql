
DROP TABLE IF EXISTS superstore_sales;


CREATE TABLE superstore_sales (
    order_id TEXT,
    order_date DATE,
    ship_date DATE,
    ship_mode TEXT,
    customer_id TEXT,
    customer_name TEXT,
    segment TEXT,
    country TEXT,
    city TEXT,
    state TEXT,
    region TEXT,
    product_id TEXT,
    category TEXT,
    sub_category TEXT,
    product_name TEXT,
    sales NUMERIC(10,2),
    quantity INT,
    profit NUMERIC(10,2),
    returns TEXT,
    payment_mode TEXT
);


copy public.superstore_sales
FROM 'D:/SQL_PYTHON_DATASET/superstore_sales_data.csv'
CSV HEADER;


SELECT COUNT(*) FROM superstore_sales;

SELECT * FROM superstore_sales;


CREATE TABLE superstore_sales_raw AS
SELECT * FROM superstore_sales;















