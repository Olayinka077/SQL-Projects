

CREATE DATABASE SalesDB;
USE SalesDB;

CREATE TABLE Product (
    Product_ID INT PRIMARY KEY IDENTITY(1,1),
    Product_Name VARCHAR(255) NOT NULL
);
select *from Product

CREATE TABLE Dealer (
    Dealer_ID INT PRIMARY KEY IDENTITY(1,1),
    Dealer_Name VARCHAR(255) NOT NULL
);
select *from Dealer

CREATE TABLE DateDim (
    Date_ID INT PRIMARY KEY IDENTITY(1,1),
    Month VARCHAR(20) NOT NULL,
    Quarter VARCHAR(5) NOT NULL,
    Year INT NOT NULL
);
select *from DateDim

CREATE TABLE Revenue (
    Revenue_ID INT PRIMARY KEY IDENTITY(1,1),
    Product_ID INT FOREIGN KEY REFERENCES Product(Product_ID),
    Dealer_ID INT FOREIGN KEY REFERENCES Dealer(Dealer_ID),
    Date_ID INT FOREIGN KEY REFERENCES DateDim(Date_ID),
    Revenue DECIMAL(18,2) NOT NULL,
    Units_Sold INT NOT NULL
);
select *from Revenue


 Insert Products
INSERT INTO Product (Product_Name) VALUES ('Laptop'), ('Smartphone'), ('Tablet');

Insert Dealers
INSERT INTO Dealer (Dealer_Name) VALUES ('Best Buy'), ('Amazon'), ('Walmart');

Insert Date Data (Last Quarter - Q4)
INSERT INTO DateDim (Month, Quarter, Year) 
VALUES ('October', 'Q4', 2024), ('November', 'Q4', 2024), ('December', 'Q4', 2024);

 Insert Revenue Data
INSERT INTO Revenue (Product_ID, Dealer_ID, Date_ID, Revenue, Units_Sold) 
VALUES 
(1, 1, 1, 50000, 20), 
(1, 2, 2, 75000, 30), 
(2, 3, 3, 100000, 40), 
(3, 1, 1, 25000, 10), 
(2, 2, 2, 90000, 35);

-- Query 1: Total Revenue by Month and Product
SELECT p.Product_Name, d.Month, SUM(r.Revenue) AS Total_Revenue
FROM Revenue r
JOIN Product p ON r.Product_ID = p.Product_ID
JOIN DateDim d ON r.Date_ID = d.Date_ID
GROUP BY p.Product_Name, d.Month;


-- Query 2: Top Dealers by Units Sold in Q4
SELECT TOP 1 de.Dealer_Name, p.Product_Name, SUM(r.Units_Sold) AS Total_Units
FROM Revenue r
JOIN Dealer de ON r.Dealer_ID = de.Dealer_ID
JOIN Product p ON r.Product_ID = p.Product_ID
JOIN DateDim d ON r.Date_ID = d.Date_ID
WHERE d.Quarter = 'Q4'
GROUP BY de.Dealer_Name, p.Product_Name
ORDER BY Total_Units DESC;


--Best-Selling Product by Revenue
Question: Which product generated the highest revenue?

SELECT TOP 1 p.Product_Name, SUM(r.Revenue) AS Total_Revenue
FROM Revenue r
JOIN Product p ON r.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Total_Revenue DESC

Insight: Identifies the top-earning product overall.
  
 ---Most Profitable Month
Question: Which month had the highest total revenue?

SELECT TOP 1 d.Month, SUM(r.Revenue) AS Total_Revenue
FROM Revenue r
JOIN DateDim d ON r.Date_ID = d.Date_ID
GROUP BY d.Month
ORDER BY Total_Revenue DESC

Insight: Helps identify peak sales periods.


---Dealer Performance Analysis
Question: Which dealer sold the most products in total?

SELECT TOP 1 de.Dealer_Name, SUM(r.Units_Sold) AS Total_Units
FROM Revenue r
JOIN Dealer de ON r.Dealer_ID = de.Dealer_ID
GROUP BY de.Dealer_Name
ORDER BY Total_Units DESC

Insight: Shows the top-performing dealer.


---Average Monthly Revenue per Product
Question: What is the average revenue per product per month?

SELECT p.Product_Name, AVG(r.Revenue) AS Avg_Monthly_Revenue
FROM Revenue r
JOIN Product p ON r.Product_ID = p.Product_ID
GROUP BY p.Product_Name;
Insight: Helps in predicting future revenue.


---Seasonal Trends in Sales
Question: How does revenue vary by quarter?

SELECT d.Quarter, SUM(r.Revenue) AS Total_Revenue
FROM Revenue r
JOIN DateDim d ON r.Date_ID = d.Date_ID
GROUP BY d.Quarter
ORDER BY Total_Revenue DESC;
Insight: Helps in seasonal forecasting.

---Dealer Contribution to Revenue
Question: Which dealer contributed the most revenue?

SELECT de.Dealer_Name, SUM(r.Revenue) AS Total_Revenue
FROM Revenue r
JOIN Dealer de ON r.Dealer_ID = de.Dealer_ID
GROUP BY de.Dealer_Name
ORDER BY Total_Revenue DESC

Insight: Identifies the highest revenue-generating dealer.


---Monthly Sales Growth Rate
Question: How has sales revenue changed month-over-month?

SELECT d.Month, 
       SUM(r.Revenue) AS Total_Revenue, 
       LAG(SUM(r.Revenue)) OVER (ORDER BY d.Month) AS Prev_Month_Revenue,
       (SUM(r.Revenue) - LAG(SUM(r.Revenue)) OVER (ORDER BY d.Month)) / 
       LAG(SUM(r.Revenue)) OVER (ORDER BY d.Month) * 100 AS Growth_Percentage
FROM Revenue r
JOIN DateDim d ON r.Date_ID = d.Date_ID
GROUP BY d.Month
ORDER BY d.Month;
Insight: Helps track month-over-month growth.



