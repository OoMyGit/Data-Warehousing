/*

*/

-- dimensional table
DROP TABLE IF EXISTS SalesFact CASCADE;
DROP TABLE IF EXISTS OrderDetails CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Products CASCADE;
DROP TABLE IF EXISTS Customers CASCADE;

CREATE TABLE IF NOT EXISTS Customers (
  CustomerID VARCHAR(6) PRIMARY KEY,
  CustomerName VARCHAR(255) NOT NULL,
  Gender VARCHAR(255) NOT NULL, 
  Region VARCHAR(255),
  CustOrigin VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Products (
  ProductID VARCHAR(6) PRIMARY KEY,
  ProductName VARCHAR(255) NOT NULL,
  ProductType VARCHAR(255) NOT NULL,
  Category VARCHAR(255) NOT NULL,
  Price DECIMAL(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS Orders (
  OrderID VARCHAR(10) PRIMARY KEY,
  CustomerID VARCHAR(6) NOT NULL,
  OrderDate DATE NOT NULL,
  TotalAmount DECIMAL(10,2) NOT NULL,
  OrderOrigin VARCHAR(255),
  is_fact BOOL DEFAULT 0,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE IF NOT EXISTS OrderDetails (
  OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
  OrderID VARCHAR(10) NOT NULL,
  ProductID VARCHAR(6) NOT NULL,
  Quantity INT NOT NULL,
  ProductPrice DECIMAL(10,2) NOT NULL,  
  Discount DECIMAL(5,2) DEFAULT 0,
  is_fact BOOL DEFAULT 0,
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE IF NOT EXISTS SalesFact (
  OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
  OrderID VARCHAR(10) NOT NULL,
  OrderDate DATE,
  OrderOrigin VARCHAR(255),
  CustomerID VARCHAR(6) NOT NULL,
  ProductID VARCHAR(6) NOT NULL,
  Quantity INT NOT NULL,
  ProductPrice DECIMAL(10,2) NOT NULL,  
  Discount DECIMAL(5,2) DEFAULT 0,
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


DROP TRIGGER IF EXISTS tUpdProductType;

DELIMITER $$
CREATE TRIGGER tUpdProductType 
BEFORE INSERT ON Products
FOR EACH ROW
BEGIN
	IF SUBSTR(new.ProductID,2,2) = 'PC' THEN SET new.ProductType = 'Personal Care Products';
  ELSEIF SUBSTR(new.ProductID,2,2) = 'HP' THEN SET new.ProductType = 'Household Products';
  ELSEIF SUBSTR(new.ProductID,2,2) = 'FP' THEN SET new.ProductType = 'Food Products';
  ELSEIF SUBSTR(new.ProductID,2,2) = 'BV' THEN SET new.ProductType = 'Beverages';
  ELSE SET new.ProductType = '-';
  END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS tUpdCustData;

DELIMITER $$
CREATE TRIGGER tUpdCustData
BEFORE INSERT ON Customers
FOR EACH ROW
BEGIN
	IF lower(new.Gender = 'm') THEN SET new.Gender = 'M'; 
  ELSEIF lower(new.Gender = 'f') THEN SET new.Gender = 'F';
  ELSEIF lower(new.Gender = 'ml') THEN SET new.Gender = 'M';
  ELSEIF lower(new.Gender = 'fm') THEN SET new.Gender = 'F';
  ELSEIF lower(new.Gender = 'male') THEN SET new.Gender = 'M';
  ELSEIF lower(new.Gender = 'female') THEN SET new.Gender = 'F';
  ELSE SET new.Gender = '-';
  END IF;
  
  IF SUBSTR(new.CustomerID,1,2) = 'C1' THEN SET new.CustOrigin = 'Nganjuk';
  ELSEIF LEFT(new.CustomerID,2) = 'C2' THEN	SET new.CustOrigin = 'Gresik';
  ELSEIF LEFT(new.CustomerID,2) = 'C3' THEN	SET new.CustOrigin = 'Pasuruan';
  END IF;
END $$
DELIMITER ;


INSERT INTO
  Products (ProductID, ProductName, Category, Price)
VALUES
	-- Personal Care Products (PC)
	('PPC001', 'Head & Shoulders Shampoo', 'Shampoo', 8.25),
	('PPC002', 'Pantene Pro-V Conditioner', 'Conditioner', 9.99),
	('PPC003', 'Oral-B Electric Toothbrush', 'Toothbrush', 24.50),
	('PPC004', 'Sensodyne Sensitivity Relief Toothpaste', 'Toothpaste', 7.75),
	('PPC005', 'Nivea Body Lotion', 'Lotion', 6.29),
	-- Household Products (HP)
	('PHP006', 'Mr. Clean Multi-Surface Cleaner', 'Cleaner', 5.50),
	('PHP007', 'Swiffer Sweeper Dry Refills', 'Refills', 8.79),
	('PHP008', 'Glad Kitchen Garbage Bags', 'Garbage Bags', 3.99),
	('PHP009', 'Scotch-Brite Heavy Duty Scrub Sponge', 'Sponge', 2.25),
	('PHP010', 'Febreze Air Freshener Spray', 'Air Freshener', 4.75),
	-- Food Products (FP)
	('PFP011', 'Kellogg\'s Frosted Flakes Cereal', 'Cereal', 4.95),
	('PFP012', 'Campbell\'s Chicken Noodle Soup', 'Soup', 2.75),
	('PFP013', 'Kraft Heinz Ketchup', 'Condiment', 2.29),
	('PFP014', 'Barilla Penne Pasta', 'Pasta', 1.99),
	('PFP015', 'Uncle Bens Original Rice', 'Rice', 2.50),
	-- Beverages (BV)
	('PBV016', 'Coca-Cola Classic Soda', 'Soda', 1.75),
	('PBV017', 'Sprite Zero Sugar Lemon-Lime Soda', 'Soda', 1.50),
	('PBV018', 'Minute Maid Orange Juice', 'Juice', 4.25),
	('PBV019', 'Nescafe Instant Coffee', 'Coffee', 7.99),
	('PBV020', 'Twinings Earl Grey Tea', 'Tea', 4.50);

