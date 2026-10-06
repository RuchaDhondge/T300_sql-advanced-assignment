-- ============================================================================
-- ADVANCED SQL ASSIGNMENT: Online Shopping Platform Database
-- ============================================================================

CREATE DATABASE IF NOT EXISTS shopping_db;
USE shopping_db;

-- Reset Tables (Child tables dropped first to avoid foreign key errors)
DROP TABLE IF EXISTS Order_Audit;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

-- ----------------------------------------------------------------------------
-- Schema Creation (DDL)
-- ----------------------------------------------------------------------------

-- Customers Table (10+ records)
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

-- Products Table (10+ records)
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    created_date DATE DEFAULT (CURRENT_DATE)
);

-- Orders Table (20+ records)
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
);

-- Order_Audit Table (For Task 19 Trigger)
CREATE TABLE Order_Audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    action_date DATETIME NOT NULL
);

-- ----------------------------------------------------------------------------
-- Sample Data Insertion (DML)
-- ----------------------------------------------------------------------------

-- 10 Customers
INSERT INTO Customers (customer_name, city, email) VALUES
('Aarav Sharma', 'Mumbai', 'aarav.s@example.com'),
('Priya Patel', 'Pune', 'priya.p@example.com'),
('Rohan Mehta', 'Bangalore', 'rohan.m@example.com'),
('Ananya Iyer', 'Chennai', 'ananya.i@example.com'),
('Vikram Singh', 'Delhi', 'vikram.s@example.com'),
('Sneha Reddy', 'Hyderabad', 'sneha.r@example.com'),
('Kabir Kapoor', 'Mumbai', 'kabir.k@example.com'),
('Neha Joshi', 'Pune', 'neha.j@example.com'),
('Amit Verma', 'Kolkata', 'amit.v@example.com'),
('Pooja Nair', 'Kochi', 'pooja.n@example.com');

-- 10 Products across multiple categories
INSERT INTO Products (product_name, category, price, created_date) VALUES
('Laptop Pro 15', 'Electronics', 85000.00, '2024-01-15'),
('Wireless Headphones', 'Electronics', 4500.00, '2024-02-10'),
('Smart Phone X', 'Electronics', 65000.00, '2024-03-05'),
('Running Shoes', 'Footwear', 3200.00, '2024-03-12'),
('Leather Jacket', 'Clothing', 5500.00, '2024-04-01'),
('Cotton T-Shirt', 'Clothing', 800.00, '2024-04-15'),
('Ergonomic Chair', 'Furniture', 12500.00, '2024-05-02'),
('Gaming Monitor', 'Electronics', 22000.00, '2024-05-20'),
('Coffee Table', 'Furniture', 4500.00, '2024-06-11'),
('Backpack', 'Accessories', 1500.00, '2024-07-01');

-- 20 Orders
INSERT INTO Orders (customer_id, product_id, quantity, order_date) VALUES
(1, 1, 1, '2024-08-01'),
(1, 2, 2, '2024-08-02'),
(2, 3, 1, '2024-08-03'),
(2, 6, 3, '2024-08-04'),
(3, 4, 1, '2024-08-05'),
(3, 7, 1, '2024-08-06'),
(4, 5, 1, '2024-08-07'),
(4, 10, 2, '2024-08-08'),
(5, 8, 1, '2024-08-09'),
(5, 9, 1, '2024-08-10'),
(6, 1, 1, '2024-08-11'),
(6, 4, 2, '2024-08-12'),
(7, 2, 1, '2024-08-13'),
(7, 3, 1, '2024-08-14'),
(8, 5, 2, '2024-08-15'),
(8, 6, 5, '2024-08-16'),
(1, 8, 1, '2024-08-17'),
(2, 10, 1, '2024-08-18'),
(3, 2, 1, '2024-08-19'),
(4, 7, 2, '2024-08-20');

-- ============================================================================
-- Section 1: Advanced Joins
-- ============================================================================

-- Task 1: Display each customer along with the products they ordered.
SELECT 
    c.customer_id,
    c.customer_name,
    p.product_name,
    p.category,
    o.quantity,
    o.order_date
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
INNER JOIN Products p ON o.product_id = p.product_id
ORDER BY c.customer_id;

-- Task 2: Display all possible combinations of customers and products using a CROSS JOIN.
SELECT 
    c.customer_id,
    c.customer_name,
    p.product_id,
    p.product_name
FROM Customers c
CROSS JOIN Products p
ORDER BY c.customer_id, p.product_id;

-- Task 3: Display all customers and their orders, including customers who have not placed any orders.
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    o.order_id,
    o.product_id,
    o.order_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- ============================================================================
-- Section 2: Subqueries
-- ============================================================================

-- Task 4: Find customers who spent more than the average order value.
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.quantity * p.price) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Products p ON o.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
HAVING total_spent > (
    SELECT AVG(o_inner.quantity * p_inner.price)
    FROM Orders o_inner
    JOIN Products p_inner ON o_inner.product_id = p_inner.product_id
)
ORDER BY total_spent DESC;

-- Task 5: List products that have never been ordered.
SELECT 
    product_id,
    product_name,
    category,
    price
FROM Products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id 
    FROM Orders
);

-- Task 6: List products whose price is greater than the average price of products in the same category.
SELECT 
    p1.product_id,
    p1.product_name,
    p1.category,
    p1.price
FROM Products p1
WHERE p1.price > (
    SELECT AVG(p2.price)
    FROM Products p2
    WHERE p2.category = p1.category
)
ORDER BY p1.category;

-- ============================================================================
-- Section 3: Set Operations
-- ============================================================================

-- Task 7: Combine products from two different categories using UNION.
SELECT 
    product_id,
    product_name,
    category,
    price
FROM Products
WHERE category = 'Electronics'
UNION
SELECT 
    product_id,
    product_name,
    category,
    price
FROM Products
WHERE category = 'Clothing';

-- Task 8: Write MySQL alternatives for INTERSECT and EXCEPT using INNER JOIN and LEFT JOIN.

-- Alternative for INTERSECT (Find products that exist in both category 'Electronics' and are priced above 10000)
SELECT DISTINCT 
    p1.product_id,
    p1.product_name,
    p1.category,
    p1.price
FROM Products p1
INNER JOIN Products p2 ON p1.product_id = p2.product_id
WHERE p1.category = 'Electronics' 
  AND p2.price > 10000;

-- Alternative for EXCEPT (Find all products EXCEPT those belonging to category 'Clothing')
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.price
FROM Products p
LEFT JOIN Products p_excl ON p.product_id = p_excl.product_id AND p_excl.category = 'Clothing'
WHERE p_excl.product_id IS NULL;

-- ============================================================================
-- Section 4: Window Functions
-- ============================================================================

-- Task 9: Rank products by price within each category.
SELECT 
    product_id,
    product_name,
    category,
    price,
    RANK() OVER (PARTITION BY category ORDER BY price DESC) AS price_rank
FROM Products;

-- Task 10: Display the previous product price (LAG) and a running total of product prices using window functions.
SELECT 
    product_id,
    product_name,
    category,
    price,
    LAG(price, 1) OVER (ORDER BY product_id) AS previous_price,
    SUM(price) OVER (ORDER BY product_id) AS running_total_price
FROM Products;

-- ============================================================================
-- Section 5: Common Table Expressions (CTEs)
-- ============================================================================

-- Task 11: Create a CTE to display customers whose total purchase amount is above the average.
WITH CustomerPurchases AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        SUM(o.quantity * p.price) AS total_purchase
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    JOIN Products p ON o.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT 
    customer_id,
    customer_name,
    total_purchase
FROM CustomerPurchases
WHERE total_purchase > (SELECT AVG(total_purchase) FROM CustomerPurchases);

-- Task 12: Create a recursive CTE to generate a sequence of numbers from 1 to 10.
WITH RECURSIVE NumberSequence AS (
    SELECT 1 AS number
    UNION ALL
    SELECT number + 1
    FROM NumberSequence
    WHERE number < 10
)
SELECT number
FROM NumberSequence;

-- ============================================================================
-- Section 6: Views
-- ============================================================================

-- Task 13: Create a view that displays products priced above ₹1,000 and retrieve data from the view.
CREATE OR REPLACE VIEW HighValueProducts AS
SELECT 
    product_id,
    product_name,
    category,
    price
FROM Products
WHERE price > 1000;

-- Retrieve data from the view
SELECT * FROM HighValueProducts;

-- ============================================================================
-- Section 7: Indexes and Query Performance
-- ============================================================================

-- Task 14: Create an index on the category column of the Products table.
CREATE INDEX idx_products_category ON Products(category);

-- Task 15: Use EXPLAIN to analyze a query that filters products by category.
EXPLAIN SELECT 
    product_id,
    product_name,
    price
FROM Products
WHERE category = 'Electronics';

-- ============================================================================
-- Section 8: Stored Procedures and Functions
-- ============================================================================

-- Task 16: Create a stored procedure to retrieve products by category.
DROP PROCEDURE IF EXISTS GetProductsByCategory;

DELIMITER //

CREATE PROCEDURE GetProductsByCategory(
    IN p_category VARCHAR(100)
)
BEGIN
    SELECT
        product_id,
        product_name,
        category,
        price
    FROM Products
    WHERE category = p_category;
END //

DELIMITER ;

CALL GetProductsByCategory('Electronics');

-- Task 17: Create a function to calculate the total price of an order (price * quantity).
DROP FUNCTION IF EXISTS CalculateOrderTotal;

DELIMITER //

CREATE FUNCTION CalculateOrderTotal(
    p_price DECIMAL(10,2),
    p_quantity INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN p_price * p_quantity;
END //

DELIMITER ;

-- Test the function
SELECT 
    o.order_id,
    p.product_name,
    o.quantity,
    p.price,
    CalculateOrderTotal(p.price, o.quantity) AS total_order_price
FROM Orders o
JOIN Products p ON o.product_id = p.product_id;

-- ============================================================================
-- Section 9: Transactions
-- ============================================================================

-- Task 18: Write a transaction that updates a product's price and demonstrate the use of COMMIT and ROLLBACK.
-- Check price before transation
SELECT product_id, product_name, price FROM Products WHERE product_id = 1;

-- Part A: Rollback Demonstration
START TRANSACTION;

UPDATE Products
SET price = price * 1.10
WHERE product_id = 1;

-- Verify change during transaction
SELECT product_id, product_name, price FROM Products WHERE product_id = 1;

-- Revert changes
ROLLBACK;

-- Verify price restored
SELECT product_id, product_name, price FROM Products WHERE product_id = 1;

-- Part B: Commit Demonstration
START TRANSACTION;

UPDATE Products
SET price = price * 1.05
WHERE product_id = 1;

-- Save changes permanently
COMMIT;

-- Verify final committed price
SELECT product_id, product_name, price FROM Products WHERE product_id = 1;

-- Reset price for consistency
UPDATE Products
SET price = 85000.00
WHERE product_id = 1;
SELECT product_id, product_name, price FROM Products WHERE product_id = 1;

-- ============================================================================
-- Section 10: SQL Triggers
-- ============================================================================

-- Task 19: Create a trigger that automatically records new orders in an Order_Audit table whenever a new order is inserted.
DROP TRIGGER IF EXISTS after_order_insert;

DELIMITER //

CREATE TRIGGER after_order_insert
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO Order_Audit (order_id, action_date)
    VALUES (NEW.order_id, NOW());
END //

DELIMITER ;

-- Test the trigger by inserting a new order
INSERT INTO Orders (customer_id, product_id, quantity, order_date)
VALUES (1, 3, 2, CURRENT_DATE);

-- Verify record created in audit table
SELECT * FROM Order_Audit;

-- ============================================================================
-- Section 11: Performance Tuning
-- ============================================================================

-- Task 20: Optimize the queries by applying SQL performance tuning best practices:
-- Original Query:
-- SELECT DISTINCT *
-- FROM Products
-- WHERE YEAR(created_date) = 2024
-- AND category = 'Electronics';

-- Optimized Version:
-- 1. Avoid SELECT * (Explicitly list required columns).
-- 2. Remove unnecessary DISTINCT (product_id is PRIMARY KEY, guaranteeing uniqueness).
-- 3. Avoid functions on indexed columns (Replaced YEAR(created_date) = 2024 with a range condition to allow index utilization).
-- 4. Use an index-friendly query.

SELECT 
    product_id,
    product_name,
    category,
    price,
    created_date
FROM Products
WHERE category = 'Electronics'
  AND created_date >= '2024-01-01' 
  AND created_date <= '2024-12-31';

  