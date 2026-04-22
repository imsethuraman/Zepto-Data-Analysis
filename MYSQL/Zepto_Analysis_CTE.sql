/* =====================================================
   PROJECT: ZEPTO DATA ANALYSIS (PORTFOLIO)
   DESCRIPTION:
   This script performs:
   1. Data Exploration
   2. Data Cleaning
   3. Data Analysis
   4. Business Insights

   AUTHOR: Sethuraman
===================================================== */

-- =====================================================
-- STEP 0: USE DATABASE
-- =====================================================
USE zepto;

-- =====================================================
-- STEP 1: DATA EXPLORATION
-- =====================================================

-- Preview dataset
SELECT * FROM zepto;

-- Total number of rows
SELECT COUNT(*) AS total_rows FROM zepto;

-- Fix column name issue (encoding problem)
ALTER TABLE zepto 
RENAME COLUMN `ï»¿Category` TO category;

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

-- Unique product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- Stock availability distribution
SELECT outOfStock, COUNT(*) AS product_count
FROM zepto
GROUP BY outOfStock;

-- Duplicate products (same name multiple SKUs)
SELECT name, COUNT(*) AS sku_count
FROM zepto
GROUP BY name
HAVING COUNT(*) > 1
ORDER BY sku_count DESC;

-- =====================================================
-- STEP 2: DATA CLEANING
-- =====================================================

-- 1. Remove extra spaces
UPDATE zepto
SET 
    name = TRIM(name),
    category = TRIM(category);

-- 2. Standardize product names (Proper Case)
UPDATE zepto
SET name = CONCAT(
    UPPER(LEFT(name,1)),
    LOWER(SUBSTRING(name,2))
);

-- 3. Fix missing discounted price
UPDATE zepto
SET discountedSellingPrice = mrp * (1 - discountPercent/100)
WHERE discountedSellingPrice IS NULL;

-- 4. Handle out-of-stock inventory
UPDATE zepto
SET availableQuantity = 0
WHERE outOfStock = TRUE;

-- 5. Remove invalid pricing (MRP = 0)
DELETE FROM zepto
WHERE mrp = 0;

-- 6. Convert paise to rupees
UPDATE zepto
SET 
    mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;

-- Verify pricing conversion
SELECT mrp, discountedSellingPrice FROM zepto;

-- =====================================================
-- STEP 3: DATA ANALYSIS (BUSINESS QUESTIONS)
-- =====================================================

-- Q1: Top 10 highest discount products
SELECT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2: Expensive products out of stock
SELECT name, mrp
FROM zepto
WHERE outOfStock = TRUE 
  AND mrp > 300
ORDER BY mrp DESC;

-- Q3: Premium products with low discount
SELECT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 
  AND discountPercent < 10
ORDER BY mrp DESC;

-- Q4: Top 5 categories with highest average discount
SELECT category,
       ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q5: Best value products (price per gram)
SELECT name, weightInGms, discountedSellingPrice,
       ROUND(discountedSellingPrice / weightInGms, 2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram ASC;

-- Q6: Product segmentation by weight
SELECT name, weightInGms,
       CASE 
           WHEN weightInGms < 1000 THEN 'Low'
           WHEN weightInGms < 5000 THEN 'Medium'
           ELSE 'Bulk'
       END AS weight_category
FROM zepto;

-- Q7: Total inventory weight per category
SELECT category,
       SUM(weightInGms * availableQuantity) AS total_inventory_weight
FROM zepto
GROUP BY category
ORDER BY total_inventory_weight DESC;

-- =====================================================
-- STEP 4: ADVANCED ANALYSIS TABLE
-- =====================================================
/* with Zepto_BI as (*/ 
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

    -- Estimated Profit (20% margin assumption)
    (discountedSellingPrice * 0.2 * quantity) AS profit,

    -- Discount Value
    (mrp - discountedSellingPrice) AS discount_value

FROM zepto;

-- select * from Zepto_BI;

-- =====================================================
-- STEP 5: BUSINESS INSIGHTS
-- =====================================================

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

-- Out of stock products
SELECT name
FROM zepto
WHERE outOfStock = TRUE;

-- Low inventory risk products
SELECT name, availableQuantity
FROM zepto
WHERE availableQuantity <= 2;

-- =====================================================
-- END OF SCRIPT
-- =====================================================