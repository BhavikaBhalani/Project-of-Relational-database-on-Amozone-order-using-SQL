CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(255),
    DescriptionText TEXT
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(255),
    ContactName VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(255),
    PostalCode VARCHAR(10),
    Country VARCHAR(255)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    LastName VARCHAR(255),
    FirstName VARCHAR(255),
    BirthDate DATE,
    Photo VARCHAR(255),
    Notes TEXT
);


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    EmployeeID INT,
    OrderDate DATE,
    ShipperID INT
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT
);



CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255),
    SupplierID INT,
    CategoryID INT,
    Unit VARCHAR(50),
    Price DECIMAL(10, 2)
);

CREATE TABLE Shippers (
    ShipperID INT PRIMARY KEY,
    ShipperName VARCHAR(255),
    Phone VARCHAR(20)
);

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(255),
    ContactName VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(255),
    PostalCode VARCHAR(20),
    Country VARCHAR(255),
    Phone VARCHAR(20)
);


Copy Categories(CategoryID,CategoryName, DescriptionText)
FROM 'E:\Amazon orders\categories.csv'
DELIMITER ',' CSV HEADER;

Copy Customers(CustomerID,CustomerName,ContactName,Address,City,PostalCode,Country)
FROM 'E:\Amazon orders\customer.csv'
DELIMITER ',' CSV HEADER
ENCODING 'ISO-8859-1';

Copy Employees(EmployeeID,LastName,FirstName,BirthDate,Photo,Notes)
FROM 'E:\Amazon orders\employees.csv'
DELIMITER ',' CSV HEADER;

Copy Orders(OrderID,CustomerID,EmployeeID,OrderDate,ShipperID)
FROM 'E:\Amazon orders\Orders.csv'
DELIMITER ',' CSV HEADER;


Copy OrderDetails(OrderDetailID,OrderID,ProductID,Quantity)
FROM 'E:\Amazon orders\ordersdetails.csv'
DELIMITER ',' CSV HEADER;



Copy Products(ProductID,ProductName,SupplierID,CategoryID,Unit,Price)
FROM 'E:\Amazon orders\Products.csv'
DELIMITER ',' CSV HEADER
ENCODING 'ISO-8859-1';
    
copy Shippers(ShipperID,ShipperName,Phone)
FROM 'E:\Amazon orders\shippers.csv'
DELIMITER ',' CSV HEADER;    
    
copy Suppliers(SupplierID,SupplierName,ContactName,Address,City,PostalCode,Country,Phone)
FROM 'E:\Amazon orders\suppliers.csv'
DELIMITER ',' CSV HEADER     
ENCODING 'ISO-8859-1';    
    
    
1--Which products have the highest total sales (quantity) across all orders?
SELECT p.ProductName, SUM(od.Quantity) AS TotalQuantitySold
FROM OrderDetails od
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalQuantitySold DESC;

2--Which customers place the most orders?
SELECT c.CustomerName, COUNT(o.OrderID) AS NumberOfOrders
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName
ORDER BY NumberOfOrders DESC;

3--What is the average value of orders placed?
SELECT AVG(order_totals.TotalOrderPrice) AS AverageOrderValue
FROM (
    SELECT o.OrderID, SUM(od.Quantity * p.Price) AS TotalOrderPrice
    FROM Orders o
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY o.OrderID
) AS order_totals;

4--Which customers have generated the highest total revenue?
SELECT c.CustomerName, SUM(od.Quantity * p.Price) AS TotalRevenue
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerName
ORDER BY TotalRevenue DESC;

5-- Which employees handle the most orders?
SELECT e.FirstName, e.LastName, COUNT(o.OrderID) AS NumberOfOrders
FROM Employees e
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.FirstName, e.LastName
ORDER BY NumberOfOrders DESC;

6--What are the total sales for each product category?
SELECT c.CategoryName, SUM(od.Quantity * p.Price) AS TotalSales
FROM Categories c
INNER JOIN Products p ON c.CategoryID = p.CategoryID
INNER JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY c.CategoryName
ORDER BY TotalSales DESC;

7--How have monthly sales changed over time?
SELECT DATE_TRUNC('month', o.OrderDate) AS Month, SUM(od.Quantity * p.Price) AS MonthlySales
FROM Orders o
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY DATE_TRUNC('month', o.OrderDate)
ORDER BY Month;

8--Which suppliers provide the highest revenue products?
SELECT s.SupplierName, SUM(od.Quantity * p.Price) AS TotalRevenue
FROM Suppliers s
INNER JOIN Products p ON s.SupplierID = p.SupplierID
INNER JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY s.SupplierName
ORDER BY TotalRevenue DESC;

9-- How many customers are there in each country?
SELECT c.Country, COUNT(*) AS NumberOfCustomers
FROM Customers c
GROUP BY c.Country
ORDER BY NumberOfCustomers DESC;

10--Which shippers deliver the highest number of orders?
SELECT s.ShipperName, COUNT(o.OrderID) AS NumberOfOrders
FROM Shippers s
INNER JOIN Orders o ON s.ShipperID = o.ShipperID
GROUP BY s.ShipperName
ORDER BY NumberOfOrders DESC;


11-- What is the average price of products in each category?
SELECT c.CategoryName,Round(AVG(p.Price),2) AS AveragePrice
FROM Categories c
INNER JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName
ORDER BY AveragePrice DESC;








 
    
    