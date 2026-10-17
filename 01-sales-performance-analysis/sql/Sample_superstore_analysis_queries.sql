-- =============================================
-- Sales Performance Analysis - Superstore Dataset
-- Author: Oghenyerhovwo Oruma
-- =============================================


-- 1. Overall Summary
SELECT 
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Sales), 2) AS Average_Sales,
    SUM(Quantity) AS Total_Quantity
FROM [Sample-superstore-data_Cleaned];


-- 2. Sales & Profit by Region
SELECT 
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(*) AS Number_of_Orders
FROM [Sample-superstore-data_Cleaned]
GROUP BY Region
ORDER BY Total_Sales DESC;


-- 3. Sales & Profit by Category
SELECT 
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS Profit_Margin_Percent
FROM [Sample-superstore-data_Cleaned]
GROUP BY Category
ORDER BY Total_Sales DESC;


-- 4. Sales by Sub-Category
SELECT 
    Category,
    Sub_Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM [Sample-superstore-data_Cleaned]
GROUP BY Category, Sub_Category
ORDER BY Total_Sales DESC;


-- 5. Monthly Sales Trend
SELECT 
    YEAR(Order_Date) AS Order_Year,
    MONTH(Order_Date) AS Order_Month,
    ROUND(SUM(Sales), 2) AS Monthly_Sales,
    ROUND(SUM(Profit), 2) AS Monthly_Profit
FROM [Sample-superstore-data_Cleaned]
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Order_Year, Order_Month;


-- 6. Top 10 Products by Sales
SELECT TOP 10
    Product_Name,
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM [Sample-superstore-data_Cleaned]
GROUP BY Product_Name, Category
ORDER BY Total_Sales DESC;


-- 7. Performance by Customer Segment
SELECT 
    Segment,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT Customer_ID) AS Number_of_Customers
FROM [Sample-superstore-data_Cleaned]
GROUP BY Segment
ORDER BY Total_Sales DESC;