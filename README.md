# Zepto-Data-Analysis
The project analyses Zepto product dataset using MySQL &amp; Power BI to uncover key business insights around pricing, discounts, inventory, and revenue.

The goal is to simulate a real-world e-commerce analytics use case and demonstrate strong SQL skills in:

Data Cleaning
Data Exploration
Business Analysis
Insight Generation

🎯 Business Objective

Identify high-value products
Analyze discount strategies
Detect inventory risks
Understand category-level performance

🧰 Tech Stack

SQL (MySQL)
Data Cleaning & Transformation
Aggregations & Business Logic
Case-based segmentation

🧹 Data Cleaning Steps

✔ Removed null values
✔ Trimmed unwanted spaces
✔ Standardized product names
✔ Fixed missing discounted prices
✔ Removed invalid records (MRP = 0)
✔ Converted pricing (paise → rupees)
✔ Handled out-of-stock logic

🔍 Key Analysis Performed

1️⃣ Product & Pricing Insights
Top products with the highest discounts
Premium products with low discounts
Best value products (₹ per gram)
2️⃣ Category-Level Insights
Average discount by category
Revenue contribution by category
Inventory weight distribution
3️⃣ Inventory Analysis
Out-of-stock products
Low inventory risk items
Stock distribution trends
4️⃣ Sales & Revenue Insights
Top-selling products
Revenue generation
Profit estimation (assumed 20% margin)

📊 Key Insights

💡 Pricing & Discounts
High discounts drive visibility but may impact margins
Some premium products (>₹500) have low discount → opportunity to optimize pricing
📦 Inventory
Several high-MRP products are out of stock → potential revenue loss
Low stock items (≤2 units) indicate supply chain risk
🛍️ Product Strategy
Best-value products (low ₹/gram) can be highlighted in marketing
Duplicate SKUs suggest catalog inefficiency
💰 Revenue
A few categories contribute the majority of revenue (Pareto effect)
Discount-heavy categories attract higher sales volume

📈 Sample Business Metrics Created

Revenue = Price × Quantity
Profit = 20% of Revenue
Discount Value = MRP - Selling Price
Price Efficiency = ₹ / gram

🧠 SQL Concepts Used

GROUP BY, HAVING
CASE WHEN
Aggregations (SUM, AVG)
Data Cleaning (TRIM, UPDATE)
Conditional filtering
Derived metrics

# 📷 Dashboard Preview

<img width="1252" height="706" alt="Zepto Retail Analysis" src="https://github.com/user-attachments/assets/d2872723-9352-4013-9d3d-b358305e0528" />


<img width="808" height="293" alt="Zepto Retail Analysis ii" src="https://github.com/user-attachments/assets/8f5e6258-f7c4-477a-b2fe-29f4502d8472" />

