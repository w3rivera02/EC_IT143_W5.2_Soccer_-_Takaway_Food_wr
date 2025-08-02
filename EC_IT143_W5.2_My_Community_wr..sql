/***********************************************************************************
******************************
NAME: UEFA EURO
-- Script: Takeaway_Food_Analysis.sql
-- Purpose: To analyze sales data for identifying top products, sales trends, and pricing opportunities to boost restaurant revenue.
-- Database: TakeawayOrdersDB
DESCRIPTION- First four questions were made by me, the last one by roni rolando ñahui bolivar
Ver     Date       Author 
----- ----------
-------------------------------------------------------------------------------
1.0   01/08/2025    WRIVERA 

***********************************************************************************
*******************************/
-- Q1: what are the top 5 most popular items by number of items ordered and their total revenue?
-- A1: The top five most popular items by quantity ordered are Plain Papadum, Pilau Rice, Naan, Garlic Naan
--     and Mango Chutney, generating total revenues of approximately 22,963, 53,457, 21,825, 23,975,
--     and and 3,314 respectively

USE TakeawayOrdersDB;
GO

SELECT Item_Name, Quantity, Product_Price
FROM [dbo].[restaurant-1-orders]

UNION ALL

SELECT Item_Name, Quantity, Product_Price
FROM [dbo].[restaurant-2-orders];

--

WITH AllOrders AS (
    SELECT Item_Name, Quantity, Product_Price
    FROM [dbo].[restaurant-1-orders]
    
    UNION ALL
    
    SELECT Item_Name, Quantity, Product_Price
    FROM [dbo].[restaurant-2-orders]
)

SELECT 
    Item_Name,
    SUM(Quantity) AS Total_Quantity_Ordered,
    SUM(Quantity * Product_Price) AS Total_Revenue
FROM AllOrders
GROUP BY Item_Name;
-- 
WITH AllOrders AS (
    SELECT Item_Name, Quantity, Product_Price
    FROM [dbo].[restaurant-1-orders]
    
    UNION ALL
    
    SELECT Item_Name, Quantity, Product_Price
    FROM [dbo].[restaurant-2-orders]
),

ItemStats AS (
    SELECT 
        Item_Name,
        SUM(Quantity) AS Total_Quantity_Ordered,
        SUM(Quantity * Product_Price) AS Total_Revenue
    FROM AllOrders
    GROUP BY Item_Name
)

SELECT TOP 5
    Item_Name,
    Total_Quantity_Ordered,
    Total_Revenue
FROM ItemStats
ORDER BY Total_Quantity_Ordered DESC;

-- Q2: are there ordering patters based on the day of the week? Which days bring the highest sales?
-- A2: Ordering patterns show that weekends, especially Saturday and Friday, have the highest sales in both total
--     orders and revenue, with Saturday leading the way. Sales tend to be lower on weekdays, with Tuesday
--     having the least orders and revenue.

SELECT 
    DATENAME(WEEKDAY, Order_Date) AS DayOfWeek,
    Item_Name, Quantity, Product_Price
FROM [dbo].[restaurant-1-orders]

UNION ALL

SELECT 
    DATENAME(WEEKDAY, Order_Date) AS DayOfWeek,
    Item_Name, Quantity, Product_Price
FROM [dbo].[restaurant-2-orders];

WITH AllOrders AS (
    SELECT Order_Date, Quantity, Product_Price
    FROM [dbo].[restaurant-1-orders]
    
    UNION ALL
    
    SELECT Order_Date, Quantity, Product_Price
    FROM [dbo].[restaurant-2-orders]
)

SELECT 
    DATENAME(WEEKDAY, Order_Date) AS DayOfWeek,
    COUNT(*) AS Total_Orders,
    SUM(Quantity * Product_Price) AS Total_Revenue,
    SUM(Quantity) AS Total_Items_Ordered
FROM AllOrders
GROUP BY DATENAME(WEEKDAY, Order_Date);
--
WITH AllOrders AS (
    SELECT Order_Date, Quantity, Product_Price
    FROM [dbo].[restaurant-1-orders]
    
    UNION ALL
    
    SELECT Order_Date, Quantity, Product_Price
    FROM [dbo].[restaurant-2-orders]
)

SELECT 
    DATENAME(WEEKDAY, Order_Date) AS DayOfWeek,
    COUNT(*) AS Total_Orders,
    SUM(Quantity * Product_Price) AS Total_Revenue,
    SUM(Quantity) AS Total_Items_Ordered
FROM AllOrders
GROUP BY DATENAME(WEEKDAY, Order_Date)
ORDER BY Total_Revenue DESC;

-- Q3: which menu itmes generate low renvenue but are ordered frequently? Should we consider changing their prices?
-- A3: Items like Plain Rice, Bengal Salad, and Dahi are ordered frequently but generate relatively low revenue due, 
--     to their low prices. It might be worth considering a price review to improve profitability without significantly
--     affecting demand.

WITH AllOrders AS (
    SELECT Item_Name, Quantity, Product_Price
    FROM [dbo].[restaurant-1-orders]
    
    UNION ALL
    
    SELECT Item_Name, Quantity, Product_Price
    FROM [dbo].[restaurant-2-orders]
)

SELECT TOP 10 * FROM AllOrders;

--
WITH AllOrders AS (
    SELECT Item_Name, Quantity, Product_Price
    FROM [dbo].[restaurant-1-orders]
    
    UNION ALL
    
    SELECT Item_Name, Quantity, Product_Price
    FROM [dbo].[restaurant-2-orders]
),
ItemStats AS (
    SELECT 
        Item_Name,
        SUM(Quantity) AS Total_Quantity_Ordered,
        SUM(Quantity * Product_Price) AS Total_Revenue,
        AVG(Product_Price) AS Average_Price
    FROM AllOrders
    GROUP BY Item_Name
)

SELECT * FROM ItemStats;

WITH AllOrders AS (
    SELECT Item_Name, Quantity, Product_Price
    FROM [dbo].[restaurant-1-orders]
    
    UNION ALL
    
    SELECT Item_Name, Quantity, Product_Price
    FROM [dbo].[restaurant-2-orders]
),
ItemStats AS (
    SELECT 
        Item_Name,
        SUM(Quantity) AS Total_Quantity_Ordered,
        SUM(Quantity * Product_Price) AS Total_Revenue,
        AVG(Product_Price) AS Average_Price
    FROM AllOrders
    GROUP BY Item_Name
)
SELECT 
    Item_Name,
    Total_Quantity_Ordered,
    Total_Revenue,
    Average_Price
FROM ItemStats
WHERE Total_Quantity_Ordered > 50       
  AND Total_Revenue < 300               
ORDER BY Total_Quantity_Ordered DESC;

-- Q4: Using the restaurant-1-orders and restaurant-1-products-price tables, 
--     which item generated the highest total revenue across all orders?
-- A4: Chicken Tikka Masala generated the highest total revenue across all orders, with approximately 22,133.35 in 
--     sales

SELECT TOP 1
    o.Item_Name,
    SUM(o.Quantity * p.Product_Price) AS Total_Revenue
FROM [dbo].[restaurant-1-orders] o
JOIN [dbo].[restaurant-1-products-price] p
    ON o.Item_Name = p.Item_Name
GROUP BY o.Item_Name
ORDER BY Total_Revenue DESC;
/**************************************
--- End of Script 1 ---
**************************************/


/***********************************************************************************
******************************
NAME: UEFA EURO
-- Script: UEFA_EURO_Analysis.sql
-- Purpose: Analyze UEFA EURO data to uncover trends in goals, attendance, finalists, and red card frequency over time.
-- Database: UEFAEURODB
DESCRIPTION- First four questions were made by me, the last one by roni rolando ñahui bolivar
Ver     Date       Author 
----- ----------
-------------------------------------------------------------------------------
1.0 01/08/2025    WRIVERA 
RUNTIME:
Xm Xs
***********************************************************************************
*******************************/
-- Q1: How have average goals per match changed over the last five tournaments? More offensive or defensive overall?
-- A1: Over the last five tournaments, the average goals per match have steadily decreased, 
--     indicating that the games have become more defensive overall.

SELECT GETDATE() AS my_date;


USE UEFAEURODB;
GO

SELECT TOP 5
    year,
    goals,
    matches,
    goals_avg
FROM euro_summary
ORDER BY year DESC;

WITH LastFiveTournaments AS (
    SELECT TOP 5
        year,
        goals_avg
    FROM euro_summary
    ORDER BY year DESC
)
SELECT *
FROM LastFiveTournaments
ORDER BY year ASC;

SELECT TOP 5
    year,
    goals,
    matches,
    goals_avg
FROM euro_summary
ORDER BY year DESC;

-- Q2: What are the top 3 years with the highest total match attendance, and which countries were in the finals those years?
-- A2: The top three years with the highest total match attendance were 2024, 2016, and 2012. 
--     The finals featured Spain vs. England in 2024, Portugal vs. France in 2016, and Spain vs. Italy in 2012

SELECT TOP 3
    year,
    attendance,
    final, 
    winner
FROM euro_summary
ORDER BY attendance DESC;

-- Q3: Are red cards becoming more or less frequent over time? What is the average for each decade?
-- A3: The average goes up and down over the decades. There was an increase in the 2000s but there is no
--     consistent trend over time. On average, the number of red cards per match ranges from about 0.07 to 0.38 
--     depending on the decade.

SELECT
    (year / 10) * 10 AS decade,
    COUNT(*) AS tournaments_count,
    AVG(red_cards) AS avg_red_cards_per_tournament,
    AVG(red_cards_avg) AS avg_red_cards_per_match
FROM euro_summary
GROUP BY (year / 10) * 10
ORDER BY decade;

-- Q4: Based on the euro_summary table, which tournament year had the highest average number of goals per match, 
-- and how does that compare to the year with the highest attendance?
-- A4: The tournament year with the highest average number of goals per match was 1976, with an average of
--     4.75 goals. In comparison, the year with the highest attendance was 2024, attracting 2,681,288 spectators.

SELECT TOP 1
    year AS highest_goals_year,
    goals_avg AS highest_goals_avg
FROM euro_summary
ORDER BY goals_avg DESC;

SELECT TOP 1
    year AS highest_attendance_year,
    attendance AS highest_attendance
FROM euro_summary
ORDER BY attendance DESC;