
SELECT * FROM superstore_sales_final;

-- 1. Total sales ?

SELECT SUM(sales) as total_sales from superstore_sales_final;

-- 2. Total profit calculate

SELECT SUM(profit) as total_profit from superstore_sales_clean;

--3. Total orders count 

SELECT COUNT(DISTINCT "order_id") as total_orders from superstore_sales_clean;

-- 4. How many unique customers ?

SELECT COUNT(DISTINCT "customer_id") from superstore_sales_clean;

-- 5. Saw all unique categories 
SELECT DISTINCT category from superstore_sales_clean;

-- 6. Region-wise total sales

SELECT region , sum(sales) as total_sales from superstore_sales_clean
GROUP BY region;

-- 7. Category-wise total profit

SELECT category, SUM(profit) as total_profit FROM superstore_sales_clean
GROUP BY category

--8. Top 5 highest sales records

SELECT * from superstore_sales_clean order by sales desc
LIMIT 5;

-- 9. Saw Loss-making orders.

SELECT * FROM superstore_sales_clean
WHERE profit < 0 order by sales desc
limit 5;

-- 10. Payment modes list karo.

SELECT DISTINCT payment_mode FROM superstore_sales_clean;


SELECT payment_mode, COUNT(*) AS total_orders FROM superstore_sales_clean
GROUP BY payment_mode
order by total_orders desc;



SELECT payment_mode, COUNT(*) total_orders,
ROUND( 
	COUNT(*) * 100/SUM(COUNT(*)) OVER(),2
	) AS percentage
FROM superstore_sales_clean
GROUP BY payment_mode
ORDER BY total_orders desc;



-- 11. City-wise total sales

SELECT city , SUM(sales) AS total_sales from superstore_sales_clean
GROUP BY city;


--12. Total quantity sold.

SELECT SUM(quantity) FROM superstore_sales_clean;

--13. Technology category ke records


SELECT * FROM superstore_sales_clean
WHERE category = 'Technology' order by sales desc
LIMIT 10;


-- 14. Standard Class ship mode ke orders.

SELECT COUNT(*) as total_standard_class FROM superstore_sales_clean
WHERE ship_mode = 'Standard Class';

--15. top 5 Sabse zyada profit wala product.

SELECT product_name, category, profit from superstore_sales_clean
ORDER BY profit DESC 
LIMIT 5;

-- 16. Sabse kam sales wala product.

SELECT product_name , sales, profit FROM superstore_sales_clean
ORDER BY sales ASC
LIMIT 5;

-- 17. Region list karo.

SELECT DISTINCT region FROM superstore_sales_clean;


-- 18. Consumer segment ke orders.

SELECT COUNT(*) FROM superstore_sales_clean
WHERE segment = 'Consumer';


-- 19. Online payment se hui sales.

SELECT SUM(sales) FROM superstore_sales_clean
WHERE payment_mode = 'Online';


-- 20. January month ke orders.

SELECT * FROM superstore_sales_clean
WHERE EXTRACT(MONTH FROM "order_date") = 1
order by sales desc
limit 5;


--< INTERMEDIATE LEVEL (20 Query.) -->


-- 1. Year-wise total sales.

SELECT EXTRACT(YEAR FROM "order_date") AS year, SUM(sales) as total_sales
FROM superstore_sales_clean
GROUP BY year;


--2. Region-wise profit margin.

SELECT region, SUM(profit)/SUM(sales) *100 as profit_margin from superstore_sales_clean
group by region;


-- 3. Category + Sub-category wise sales.

SELECT category , sub_category, sum(sales) as total_sales from superstore_sales_clean
group by category, sub_category;


-- 4. Top 5 customers by sales.


SELECT customer_name, sum(sales) as total_sales from superstore_sales_clean
group by customer_name
order by total_sales desc
limit 5;


-- 5. Average order sales.

SELECT AVG(sales) from superstore_sales_clean;


-- 6. State-wise profit.

SELECT state, sum(profit) as total_profit from superstore_sales_clean
group by state;


-- 7. ship mode-wise order count.

SELECT ship_mode, count(*) from superstore_sales_clean 
group by ship_mode;


-- 8. Orders with sales above average.

SELECT * FROM superstore_sales_clean
WHERE sales > (select avg(sales) from superstore_sales_clean);


-- 9. Top 3 cities by sales.

SELECT City, SUM(Sales) AS total_sales
FROM superstore_sales
GROUP BY City
ORDER BY total_sales DESC
LIMIT 3;

SELECT city , sum(sales) as total_sales from superstore_sales_clean
group by city
order by total_sales desc 
limit 5;


-- 10. Loss-making sub-categories.

select sub_category, sum(profit) as total_loss from superstore_sales_clean
group by sub_category
HAVING SUM(profit) < 0;


-- 11. Month-wise sales trend.

SELECT  EXTRACT(MONTH FROM "order_date") as month_sale_trend from superstore_sales_clean
group by  month_sale_trend;


-- 12. Customer-wise total orders.

SELECT customer_name , COUNT(DISTINCT "order_id") from superstore_sales_clean
group by customer_name
order by count desc;


-- 13. Technology category ka total quantity.


SELECT SUM(quantity) from superstore_sales_clean
where category = 'Technology';

-- 14. Region-wise average sales.

-- 15. Returned orders.


SELECT * FROM superstore_sales_clean
where RETURNS is NOT null;


-- 16. Payment mode-wise sales.

SELECT Payment_Mode, SUM(Sales)
FROM superstore_sales_clean
GROUP BY Payment_Mode;


--17. Top 5 profitable products.


SELECT product_name, sum(profit) as total_profit from superstore_sales_clean
group by product_name
order by total_profit desc 
limit 4;



-- 18. Segment-wise total sales.


SELECT segment, sum(sales) from superstore_sales_clean
group by segment;




-- 19. Orders shipped after order date gap > 3 days.


SELECT * FROM superstore_sales_clean
where ship_date - order_date < 3 ;


-- 20. Highest selling sub-category.


SELECT sub_category , sum(sales) from superstore_sales_clean
group by sub_category
order by sum(sales) desc 
limit 3;





---  ADVANCED LEVEL (20 Query)


-- 1. Rank products by sales (window function).


SELECT product_name, SUM(sales), 
RANK() OVER (ORDER BY SUM(sales) desc) sales_rank
from superstore_sales_clean
group by product_name;


-- 2. Running total of sales.

SELECT order_date, sales,
sum(sales) over (order by "order_date") as running_sales
from superstore_sales_clean;


-- 3. Region-wise top product.

SELECT region, product_name, sum(sales) from superstore_sales_clean
group by region, product_name
 QUALIFY RANK() OVER (PARTITION BY region order by sum(sales) desc) = 1;


-- 4. Month-over-month sales growth.

SELECT month,
	total_sales,
	total_sales - LAG(total_sales) OVER (ORDER BY month) as growth
from( 
	SELECT EXTRACT(MONTH FROM "order_date") as month, sum(sales) as total_sales
	from superstore_sales_clean
	group by month
) ;



---5. Top customer per region.


SELECT * FROM(
			SELECT region, customer_name, sum(sales) as total_sales,
			rank() over (PARTITION BY region ORDER BY SUM(sales) desc) rnk
			from superstore_sales_clean
			group by region, customer_name
		) 
		where rnk = 1;


--6.Profit percentage per order.

select order_id,
		(profit / sales) * 100 as profit_percentage
from superstore_sales_clean;


--7  Orders contributing top 20% sales.


select * from superstore_sales_clean
where sales >= (
			select percentile_cont(0.8)
			within group (order by sales)
			from superstore_sales_clean
);

--8. Category-wise cumulative sales.

SELECT category, sales, 
sum(sales) over (PARTITION BY category ORDER BY order_date)
from superstore_sales;

-- 9. Customers with repeat purchases.


select product_name, count(distinct order_id) from superstore_sales_clean
group by product_name
having count(distinct order_id) > 1
order by count;


-- 10. Worst performing region by profit.

select region, sum(profit) from superstore_sales_clean
group by region
order by sum(profit)
limit 5;

-- 11. Average delivery time.

select avg(ship_date - order_date) from superstore_sales_clean;


-- 12. High sales but low profit orders.

SELECT * FROM superstore_sales_clean
where sales > 500 and profit < 50;


-- 13 Sub-category contribution % in sales.

SELECT Sub_Category,
SUM(Sales) * 100 / SUM(SUM(Sales)) OVER () AS contribution_pct
FROM superstore_sales_clean
GROUP BY Sub_Category;


-- 14. Region-wise profit rank.

SELECT Region, SUM(Profit),
RANK() OVER (ORDER BY SUM(Profit) DESC)
FROM superstore_sales_clean
GROUP BY Region;


-- 15. Customer lifetime value (sales).

SELECT Customer_Name, SUM(Sales) AS lifetime_value
FROM superstore_sales_clean
GROUP BY Customer_Name;


--16 Most returned category.

SELECT Category, COUNT(*)
FROM superstore_sales_clean
WHERE Returns IS NOT NULL
GROUP BY Category;


--17 Top 3 months by sales.

SELECT EXTRACT(MONTH FROM Order_Date) AS month, SUM(Sales)
FROM superstore_sales_clean
GROUP BY month
ORDER BY SUM(Sales) DESC
LIMIT 3;


--18 Profit trend using window avg.

SELECT Order_Date, 
AVG(Profit) OVER (ORDER BY Order_Date ROWS 6 PRECEDING)
FROM superstore_sales_clean;


-- 19. Identify outlier sales.

SELECT *
FROM superstore_sales_clean
WHERE Sales > (SELECT AVG(Sales) + 3*STDDEV(Sales) FROM superstore_sales_clean);


--20 Category-wise best performing region.

SELECT *
FROM (
  SELECT Category, Region, SUM(Sales) AS total_sales,
  RANK() OVER (PARTITION BY Category ORDER BY SUM(Sales) DESC) rnk
  FROM superstore_sales_clean
  GROUP BY Category, Region
) 
WHERE rnk = 1;











