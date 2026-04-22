use zepto;

-- data exploration
-- sample data

select * from zepto;

-- count of rows
select count(*) from zepto;

ALTER TABLE zepto 
RENAME COLUMN `ï»¿Category` TO category;

-- null values

SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

-- different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- products in stock vs out of stock
SELECT outOfStock, count(*)
FROM zepto
GROUP BY outOfStock;

-- product names present multiple times
SELECT name, COUNT(*) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(*) > 1
ORDER BY count(*) DESC;

-- data cleaning

-- 1. Remove leading/trailing spaces
UPDATE zepto
SET 
    name = TRIM(name),
    category = TRIM(category);

-- 2. Standardize names (Proper case)
UPDATE zepto
SET name = CONCAT(
    UPPER(LEFT(name,1)),
    LOWER(SUBSTRING(name,2))
);

-- 3. Fix pricing inconsistency
UPDATE zepto
SET discountedSellingPrice = mrp * (1 - discountPercent/100)
WHERE discountedSellingPrice IS NULL;

-- 4. Handle out of stock
UPDATE zepto
SET availableQuantity = 0
WHERE outOfStock = TRUE;

-- products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

-- convert paise to rupees
UPDATE zepto
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice FROM zepto;

-- data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2.What are the Products with High MRP but Out of Stock

SELECT DISTINCT name,mrp
FROM zepto
WHERE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

-- Q8.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;

-- Create Analysis Table
SELECT 
    category,
    `name`,
    mrp,
    discountedSellingPrice,
    discountPercent,
    availableQuantity,
    quantity,
    
    -- Revenue
    (discountedSellingPrice * quantity) AS revenue,
    
    -- Profit (assume 20% cost margin)
    (discountedSellingPrice * 0.2 * quantity) AS profit,
    
    -- Discount Value
    (mrp - discountedSellingPrice) AS discount_value

FROM zepto;

-- 3. Insights
-- Top Selling Products

SELECT name, SUM(quantity) AS total_sold
FROM zepto
GROUP BY name
ORDER BY total_sold DESC
LIMIT 10;

-- Revenue by Category

SELECT category, 
       SUM(discountedSellingPrice * quantity) AS revenue
FROM zepto
GROUP BY category
ORDER BY revenue DESC;

-- High Discount Impact
SELECT name, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Out of Stock Products
SELECT name
FROM zepto
WHERE outOfStock = TRUE;

-- Inventory Risk (Low Stock)
SELECT name, availableQuantity
FROM zepto
WHERE availableQuantity <= 2;

