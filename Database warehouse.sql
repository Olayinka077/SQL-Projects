
CREATE DATABASE SalesDataWarehouse;

USE SalesDataWarehouse;

-- CLIENT Table
CREATE TABLE CLIENT (
    idcli INT PRIMARY KEY IDENTITY(1,1),
    city VARCHAR(100),
    region VARCHAR(100),
    country VARCHAR(100)
);

-- PRODUCT Table
CREATE TABLE PRODUCT (
    idproduct INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(255),
    category VARCHAR(100),
    cost_price DECIMAL(10,2),
    sale_price DECIMAL(10,2),
    supplier VARCHAR(100)
);

-- DATE Table
CREATE TABLE DATE (
    idDate INT PRIMARY KEY IDENTITY(1,1),
    month INT,
    monthName VARCHAR(20),
    quarter VARCHAR(10),
    year INT
);

-- SALES Table
CREATE TABLE SALES (
    idSales INT PRIMARY KEY IDENTITY(1,1),
    idproduct INT,
    idDate INT,
    idcli INT,
    delivery_date DATE,
    quantity INT,
    amount DECIMAL(12,2),
    FOREIGN KEY (idproduct) REFERENCES PRODUCT(idproduct),
    FOREIGN KEY (idDate) REFERENCES DATE(idDate),
    FOREIGN KEY (idcli) REFERENCES CLIENT(idcli)
);

-- Insert Clients
INSERT INTO CLIENT (city, region, country) VALUES
('Lagos', 'Southwest', 'Nigeria'),
('Abuja', 'Central', 'Nigeria'),
('Nairobi', 'Central', 'Kenya'),
('Cape Town', 'Western Cape', 'South Africa'),
('Johannesburg', 'Gauteng', 'South Africa');

-- Insert Products
INSERT INTO PRODUCT (name, category, cost_price, sale_price, supplier) VALUES
('22-inch Screen', 'Electronics', 150.00, 200.00, 'TechSupplier Ltd'),
('Laptop', 'Computers', 500.00, 700.00, 'TechSupplier Ltd'),
('Smartphone', 'Electronics', 300.00, 450.00, 'MobileCorp'),
('Headphones', 'Accessories', 20.00, 50.00, 'SoundTech'),
('Keyboard', 'Accessories', 15.00, 40.00, 'CompWare');

-- Insert Date Records
INSERT INTO DATE (month, monthName, quarter, year) VALUES
(1, 'January', 'Q1', 2024),
(2, 'February', 'Q1', 2024),
(3, 'March', 'Q1', 2024),
(4, 'April', 'Q2', 2024),
(5, 'May', 'Q2', 2024),
(6, 'June', 'Q2', 2024),
(7, 'July', 'Q3', 2024),
(8, 'August', 'Q3', 2024),
(9, 'September', 'Q3', 2024),
(10, 'October', 'Q4', 2024),
(11, 'November', 'Q4', 2024),
(12, 'December', 'Q4', 2024);

-- Insert Sales Data
INSERT INTO SALES (idproduct, idDate, idcli, delivery_date, quantity, amount) VALUES
(1, 1, 1, '2024-01-10', 10, 2000.00),
(1, 3, 2, '2024-03-15', 5, 1000.00),
(2, 5, 3, '2024-05-20', 3, 2100.00),
(3, 7, 4, '2024-07-25', 7, 3150.00),
(4, 10, 5, '2024-10-30', 15, 750.00),
(5, 12, 1, '2024-12-05', 20, 800.00),
(1, 2, 3, '2024-02-08', 8, 1600.00),
(2, 4, 5, '2024-04-12', 4, 2800.00),
(3, 6, 2, '2024-06-18', 6, 2700.00),
(4, 9, 4, '2024-09-22', 10, 500.00);


---Verify Data
SELECT * FROM CLIENT;
SELECT * FROM PRODUCT;
SELECT * FROM DATE;
SELECT * FROM SALES;

--Run Queries

--checking total sales by country:
SELECT c.country, SUM(s.amount) AS total_sales
FROM SALES s
JOIN CLIENT c ON s.idcli = c.idcli
GROUP BY c.country;

---Total sales by product category
SELECT p.category, SUM(s.amount) AS total_sales
FROM SALES s
JOIN PRODUCT p ON s.idproduct = p.idproduct
GROUP BY p.category
ORDER BY total_sales DESC;

--- Monthly sales trend
SELECT d.year, d.month, SUM(s.amount) AS total_sales
FROM SALES s
JOIN DATE d ON s.idDate = d.idDate
GROUP BY d.year, d.month
ORDER BY d.year, d.month;

--Top performing client
SELECT c.idcli, c.city, c.country, SUM(s.amount) AS total_sales
FROM SALES s
JOIN CLIENT c ON s.idcli = c.idcli
GROUP BY c.idcli, c.city, c.country
ORDER BY total_sales DESC;


---Product Profitability analysis
SELECT p.name, SUM(s.amount - (p.cost_price * s.quantity)) AS total_profit
FROM SALES s
JOIN PRODUCT p ON s.idproduct = p.idproduct
GROUP BY p.name
ORDER BY total_profit DESC;

---Quarterly sales by Region
SELECT d.year, d.quarter, c.region, SUM(s.amount) AS total_sales
FROM SALES s
JOIN DATE d ON s.idDate = d.idDate
JOIN CLIENT c ON s.idcli = c.idcli
GROUP BY d.year, d.quarter, c.region
ORDER BY d.year, d.quarter, c.region;


---Year over Year Growth
WITH yearly_sales AS (
    SELECT d.year, SUM(s.amount) AS total_sales
    FROM SALES s
    JOIN DATE d ON s.idDate = d.idDate
    GROUP BY d.year
)
SELECT 
    y1.year AS current_year,
    y1.total_sales AS current_sales,
    y2.total_sales AS previous_sales,
    ((y1.total_sales - y2.total_sales) / y2.total_sales * 100) AS growth_percentage
FROM yearly_sales y1
JOIN yearly_sales y2 ON y1.year = y2.year + 1;

---Sales Performance by Supplier
SELECT p.supplier, SUM(s.amount) AS total_sales
FROM SALES s
JOIN PRODUCT p ON s.idproduct = p.idproduct
GROUP BY p.supplier
ORDER BY total_sales DESC;

---Average Order value
SELECT AVG(amount) AS average_order_value
FROM SALES;

--- Product sales distribution
SELECT p.name, COUNT(s.idSales) AS number_of_sales, SUM(s.amount) AS total_sales
FROM SALES s
JOIN PRODUCT p ON s.idproduct = p.idproduct
GROUP BY p.name
ORDER BY total_sales DESC;


---Client Purchase frequency
SELECT c.idcli, c.city, c.country, COUNT(s.idSales) AS purchase_count
FROM SALES s
JOIN CLIENT c ON s.idcli = c.idcli
GROUP BY c.idcli, c.city, c.country
ORDER BY purchase_count DESC;

Database Structure
I created a sales database with four tables:
CLIENT: Stores customer information (city, region, country)
PRODUCT: Contains product details (name, category, prices, supplier)
DATE: A calendar reference table with months, quarters, and years
SALES: Records each sale transaction linking products, dates, and clients
    
What the Queries Tell You;
Total sales by product category: This shows you which product categories are making the most money. For example, you might see that Electronics brings in more revenue than Accessories.
Monthly sales trend: This shows how your sales have changed month by month throughout the year. You can spot seasonal patterns, like whether you sell more in December or during summer months.
Top performing client: This identifies which customers are spending the most money with you. The query ranks clients by total purchases, showing their location and total spend.
Product Profitability analysis: This reveals which products are most profitable, not just which ones sell the most. It calculates actual profit by subtracting the cost from the selling price for each product.
Quarterly sales by Region: This breaks down sales by geographic region for each quarter, helping you understand which regions perform best during different times of the year.
Year over Year Growth: This compares this year's sales to last year's and calculates the percentage increase or decrease, giving you a clear picture of your business growth.
Sales Performance by Supplier: This shows which suppliers' products are generating the most revenue, which could help with negotiating better terms with high-performing suppliers.
Average Order value: This calculates how much a typical order is worth. Useful for understanding customer spending habits and setting promotional thresholds.
Product sales distribution: This tells you both how many times each product was sold and how much total revenue it generated, helping identify both popular and high-value products.
Client Purchase frequency: This shows how often each customer buys from you, identifying your most loyal customers even if they don't spend the most money per order.

