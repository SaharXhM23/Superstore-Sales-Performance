
CREATE TABLE superstore (
  row_id INT,
  order_id VARCHAR(50),
  order_date DATE,
  ship_date DATE,
  ship_mode VARCHAR(50),
  customer_id VARCHAR(50),
  customer_name VARCHAR(100),
  segment VARCHAR(50),
  country VARCHAR(50),
  city VARCHAR(50),
  state VARCHAR(50),
  postal_code VARCHAR(20),
  region VARCHAR(50),
  product_id VARCHAR(50),
  category VARCHAR(50),
  sub_category VARCHAR(50),
  product_name TEXT,
  sales NUMERIC(10,2),
  quantity INT,
  discount NUMERIC(5,2),
  profit NUMERIC(10,2)
);

SELECT COUNT(*) FROM superstore;

-- Check date range
SELECT 
  MIN(order_date) AS first_order,
  MAX(order_date) AS last_order
FROM superstore;

-- Check for nulls in key columns
SELECT COUNT(*) 
FROM superstore
WHERE order_date IS NULL 
   OR sales IS NULL 
   OR profit IS NULL;
   
-- Business kpi
SELECT 
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(SUM(profit), 2) AS total_profit,
  COUNT(DISTINCT order_id) AS total_orders
FROM superstore;

--sales by Region
SELECT 
  region,
  ROUND(SUM(sales), 2) AS sales
FROM superstore
GROUP BY region
ORDER BY sales DESC;


--Monthly Sales Trend
SELECT 
  TO_CHAR(order_date, 'YYYY-MM') AS month,
  ROUND(SUM(sales), 2) AS monthly_sales
FROM superstore
GROUP BY month
ORDER BY month;

--Top 10 Sub-Categories
SELECT 
  sub_category,
  ROUND(SUM(sales), 2) AS sales
FROM superstore
GROUP BY sub_category
ORDER BY sales DESC
LIMIT 10;

--Profitability by Category
SELECT 
  category,
  ROUND(SUM(sales), 2) AS sales,
  ROUND(SUM(profit), 2) AS profit,
  ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin
FROM superstore
GROUP BY category
ORDER BY profit_margin DESC;

-- Top sub-category by sales in each region
SELECT region, sub_category, sales
FROM (
  SELECT 
    region,
    sub_category,
    ROUND(SUM(sales), 2) AS sales,
    RANK() OVER (PARTITION BY region ORDER BY SUM(sales) DESC) AS rnk
  FROM superstore
  GROUP BY region, sub_category
) t
WHERE rnk = 1;







