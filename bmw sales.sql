/*=====================================================
  BMW SALES ANALYSIS PROJECT
=====================================================*/

CREATE TABLE bmw_sales (
    Model VARCHAR,
    Year INT,
    Region VARCHAR,
    Color VARCHAR,
    Fuel_Type VARCHAR,
    Transmission VARCHAR,
    Engine_Size_L DECIMAL,
    Mileage_KM INT,
    Price_USD INT,
    Sales_Volume INT,
    Sales_Classification VARCHAR
);


-- Q1. Top Selling BMW Models

SELECT
    Model,
    SUM(Sales_Volume) AS Total_Sales
FROM bmw_sales
GROUP BY Model
ORDER BY Total_Sales DESC;


-- Q2. Top 5 Regions by Total Sales

SELECT
    Region,
    SUM(Sales_Volume) AS Total_Sales
FROM bmw_sales
GROUP BY Region
ORDER BY Total_Sales DESC
LIMIT 5;


-- Q3. Average Price of Electric BMWs


SELECT
    ROUND(AVG(Price_USD), 2) AS Average_Price
FROM bmw_sales
WHERE Fuel_Type = 'Electric';




-- Q4. Total Sales and Average Price in 2017



SELECT
    SUM(Sales_Volume) AS Total_Sales,
    ROUND(AVG(Price_USD), 2) AS Average_Price
FROM bmw_sales
WHERE Year = 2017;





-- Q5. Best Selling BMW Model in Each Region






WITH Regional_Model_Sales AS
(
    SELECT
        Region,
        Model,
        SUM(Sales_Volume) AS Total_Sales,

        ROW_NUMBER() OVER
        (
            PARTITION BY Region
            ORDER BY SUM(Sales_Volume) DESC
        ) AS Rank_Number

    FROM bmw_sales
    GROUP BY
        Region,
        Model
)

SELECT
    Region,
    Model,
    Total_Sales
FROM Regional_Model_Sales
WHERE Rank_Number = 1
ORDER BY Total_Sales DESC;





-- Q6. High vs Low Sales Classification by Region






SELECT
    Region,

    SUM(
        CASE
            WHEN Sales_Classification = 'High'
                THEN 1
            ELSE 0
        END
    ) AS High_Sales_Count,

    SUM(
        CASE
            WHEN Sales_Classification = 'Low'
                THEN 1
            ELSE 0
        END
    ) AS Low_Sales_Count

FROM bmw_sales
GROUP BY Region
ORDER BY Region;






-- Q7. Price Difference Between Automatic and Manual BMWs





SELECT
  ROUND(
  (
    SELECT AVG(Price_USD)
    FROM bmw_sales
    WHERE Transmission = 'Automatic'
  )
  -
  (
    SELECT AVG(Price_USD)
    FROM bmw_sales
    WHERE Transmission = 'Manual'
  ), 2
 )
AS Price_Difference;





-- Q8. Average Sales Volume by Engine Size




SELECT
    Engine_Size_L,
   ROUND( AVG(Sales_Volume), 2) AS Average_Sales_Volume
FROM bmw_sales
GROUP BY Engine_Size_L
ORDER BY Engine_Size_L;





-- Q9. Engine Size Category Analysis





SELECT
    CASE
        WHEN Engine_Size_L >= 4.0
            THEN 'Large (4.0L - 5.0L)'

        WHEN Engine_Size_L >= 2.5
            THEN 'Medium (2.5L - 3.9L)'

        ELSE 'Small (< 2.5L)'
    END AS Engine_Size_Category,

    COUNT(*) AS Total_Cars,

    AVG(Sales_Volume) AS Average_Sales_Volume

FROM bmw_sales
GROUP BY Engine_Size_Category
ORDER BY Engine_Size_Category;





-- Q10. Most Profitable Region for Each BMW Model




WITH Model_Region_Prices AS
(
    SELECT
        Model,
        Region,
        AVG(Price_USD) AS Average_Price,

        ROW_NUMBER() OVER
        (
            PARTITION BY Model
            ORDER BY AVG(Price_USD) DESC
        ) AS Rank_Number

    FROM bmw_sales
    GROUP BY
        Model,
        Region
)

SELECT
    Model,
    Region AS Most_Profitable_Region,
    ROUND(Average_Price, 2) AS Average_Price
FROM Model_Region_Prices
WHERE Rank_Number = 1;

