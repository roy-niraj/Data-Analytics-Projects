

CREATE TABLE flipkart_products (
	uniq_id TEXT PRIMARY KEY,
	product_name TEXT,
	product_category_tree TEXT,
	retail_price FLOAT,
	discounted_price FLOAT,
	is_FK_Advantage_product BOOLEAN,
	product_rating TEXT,
	overall_rating TEXT,
	brand TEXT,
	main_category TEXT
	);

SELECT * FROM flipkart_products;

--Total Products

SELECT COUNT(*) FROM flipkart_products;

-- Category-wise Product Count

SELECT main_category, count(*) from flipkart_products
GROUP BY main_category
ORDER BY COUNT(*) DESC;



-- First we can change the data type of product_rating and overall rating these are the form of text type of data into float.


SELECT overall_rating
FROM flipkart_products
WHERE overall_rating !~ '^[0-9.]+$';

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'flipkart_products'
AND column_name = 'overall_rating';

ALTER TABLE flipkart_products
ALTER COLUMN overall_rating TYPE FLOAT
USING overall_rating::FLOAT;



SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'flipkart_products'
AND column_name = 'product_rating';

ALTER TABLE flipkart_products
ALTER COLUMN product_rating TYPE FLOAT
USING product_rating::FLOAT;


ALTER TABLE flipkart_products
ALTER COLUMN overall_rating TYPE NUMERIC(3,2);

ALTER TABLE flipkart_products
ALTER COLUMN product_rating TYPE NUMERIC(3,2);




-- Brand-wise Avg Rating

SELECT brand, ROUND(AVG(overall_rating),2) as avg_rating from flipkart_products
GROUP BY brand
ORDER BY avg_rating DESC;


-- Average Discount

SELECT AVG(retail_price - discounted_price) as avg_discount from flipkart_products;

-- Average Selling Price

SELECT AVG(selling_price) from flipkart_products;


-- High Rated Products Count (Rating > 4)

SELECT COUNT(*) FROM flipkart_products
WHERE overall_rating >=4;


-- Products With Heavy Discount (>50%)

SELECT COUNT(*) FROM flipkart_products
where discounted_price >= 500

SELECT * FROM flipkart_products


--Top Brand by Product Count

SELECT COUNT(*) FROM flipkart_products
GROUP BY brand
ORDER BY COUNT (*) DESC
LIMIT 1;





 

