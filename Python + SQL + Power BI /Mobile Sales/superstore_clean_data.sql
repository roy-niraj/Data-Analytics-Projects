

CREATE TABLE superstore_sales_raw AS
SELECT * FROM superstore_sales;

SELECT * FROM superstore_sales_raw;

CREATE TABLE superstore_sales_clean AS
SELECT * FROM superstore_sales_raw;


--#### Duplicate records remove (order_id + product_id)


DELETE FROM superstore_sales_clean
where ctid not in (
	SELECT MIN(ctid)
	from superstore_sales_clean
	GROUP BY order_id, product_id
);


SELECT order_id, product_id, COUNT(*) AS cnt
FROM superstore_sales
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;


SELECT *
FROM superstore_sales
WHERE (order_id, product_id) IN (
    SELECT order_id, product_id
    FROM superstore_sales
    GROUP BY order_id, product_id
    HAVING COUNT(*) > 1
)
ORDER BY order_id, product_id;

--### check NULL values 



SELECT 	
	COUNT(*) FILTER (WHERE order_id IS NULL ) AS order_id_nulls,
	COUNT(*) FILTER (WHERE order_date is NULL) AS order_date_nulls,
	COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_nulls,
	COUNT(*) FILTER (WHERE sales IS NULL) AS sales_nulls,
	COUNT(*) FILTER (WHERE profit IS NULL) AS profit_nulls
FROM superstore_sales_clean;


--### Handle NULL values (Mandatory columns → delete)


DELETE FROM superstore_sales_clean
WHERE order_id IS NULL 
	OR order_date IS NULL
	OR product_id IS NULL


UPDATE superstore_sales_clean
SET profit = 0
WHERE profit IS NULL;


--###  Date validation (wrong dates)


DELETE FROM superstore_sales_clean
WHERE ship_date < order_date;


SELECT * FROM superstore_sales_clean

--##  Data type & value validation(Negative values remove)

DELETE FROM superstore_sales_clean
WHERE sales < 0 OR quantity <= 0;

--###   Trim & clean text columns


UPDATE superstore_sales_clean
SET
	product_name = TRIM(product_name),
	customer_name = TRIM(customer_name),
	city = TRIM(city),
	state = trim(state),
	category = trim(category),
	sub_category = trim(sub_category);
	
--- ### Standardize categorical values

UPDATE superstore_sales_clean
SET returns = 'No'
WHERE returns IS NULL;


--- ### Final ANALYTICS-READY table


CREATE TABLE superstore_sales_final AS
SELECT
    order_id,
    order_date,
    ship_date,
    EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month,
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    sales,
    quantity,
    profit,
    returns,
    payment_mode
FROM superstore_sales_clean;



--   Final checks


SELECT COUNT(*) FROM superstore_sales_raw;

SELECT COUNT(*) FROM superstore_sales_clean;

SELECT COUNT(*) FROM superstore_sales_final;





