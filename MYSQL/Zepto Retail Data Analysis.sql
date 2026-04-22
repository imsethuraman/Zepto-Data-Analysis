-- ============================================
-- Project: Zepto Retail Data Analysis
-- Objective: End-to-end SQL analysis for retail dataset
-- Tool: MySQL
-- ============================================

-- ============================================
--  1. Select Database
USE zepto;
-- View dataset
SELECT * FROM zepto;

-- ============================================
-- 2. Data Cleaning
-- Fix issue in column name (CSV import problem)
ALTER TABLE zepto 
RENAME COLUMN `ï»¿Category` TO category;

-- Remove leading/trailing spaces
UPDATE zepto
SET 
    name = TRIM(name),
    category = TRIM(category);

-- Standardize product names (Proper Case)
UPDATE zepto
SET name = CONCAT(
    UPPER(LEFT(name,1)),
    LOWER(SUBSTRING(name,2))
);

-- Fix missing discounted prices
UPDATE zepto
SET discountedSellingPrice = mrp * (1 - discountPercent/100)
WHERE discountedSellingPrice IS NULL;

-- Set available quantity to 0 if out of stock
UPDATE zepto
SET availableQuantity = 0
WHERE outOfStock = TRUE;

-- Remove invalid pricing rows
DELETE FROM zepto
WHERE mrp = 0;

-- Convert paise to rupees
UPDATE zepto
SET 
    mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;

-- ============================================
-- 3. Data Exploration

-- Total rows
SELECT COUNT(*) AS total_rows FROM zepto;

-- Unique categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- Stock distribution
SELECT outOfStock, COUNT(*) AS product_count
FROM zepto
GROUP BY outOfStock;

-- Duplicate products
SELECT name, COUNT(*) AS sku_count
FROM zepto
GROUP BY name
HAVING COUNT(*) > 1
ORDER BY sku_count DESC;

-- ============================================
-- 4. Data Quality Check

-- Check NULL values
SELECT * FROM zepto
WHERE name IS NULL
   OR category IS NULL
   OR mrp IS NULL
   OR discountPercent IS NULL
   OR discountedSellingPrice IS NULL
   OR weightInGms IS NULL
   OR availableQuantity IS NULL
   OR outOfStock IS NULL
   OR quantity IS NULL;

-- ============================================
-- 5. Business Analysis

-- Q1: Top 10 highest discount products
SELECT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2: High MRP but out-of-stock products
SELECT name, mrp
FROM zepto
WHERE outOfStock = TRUE 
  AND mrp > 300
ORDER BY mrp DESC;

-- Q3: High price, low discount products
SELECT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 
  AND discountPercent < 10
ORDER BY mrp DESC;

-- Q4: Top categories by avg discount
SELECT category,
       ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q5: Best value products (price per gram)
SELECT name, weightInGms, discountedSellingPrice,
       ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- Q6: Weight segmentation
SELECT name, weightInGms,
CASE 
    WHEN weightInGms < 1000 THEN 'Low'
    WHEN weightInGms < 5000 THEN 'Medium'
    ELSE 'Bulk'
END AS weight_category
FROM zepto;

-- Q7: Inventory weight per category
SELECT category,
       SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;

-- ============================================
--  6. Feature Datasets

SELECT 
    category,
    name,
    mrp,
    discountedSellingPrice,
    discountPercent,
    availableQuantity,
    quantity,

    -- Revenue
    (discountedSellingPrice * quantity) AS revenue,

    -- Profit (assumed 20% margin)
    (discountedSellingPrice * 0.2 * quantity) AS profit,

    -- Discount value
    (mrp - discountedSellingPrice) AS discount_value

FROM zepto;

-- ============================================
-- 7. Business Insights

-- Top selling products
SELECT name, SUM(quantity) AS total_sold
FROM zepto
GROUP BY name
ORDER BY total_sold DESC
LIMIT 10;

-- Revenue by category
SELECT category, 
       SUM(discountedSellingPrice * quantity) AS revenue
FROM zepto
GROUP BY category
ORDER BY revenue DESC;

-- Highest discount products
SELECT name, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Out-of-stock products
SELECT name
FROM zepto
WHERE outOfStock = TRUE;

-- Low inventory products
SELECT name, availableQuantity
FROM zepto
WHERE availableQuantity <= 2;

-- ============================================