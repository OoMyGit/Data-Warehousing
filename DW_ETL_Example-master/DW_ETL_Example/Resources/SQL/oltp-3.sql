/*
This OLTP is located in Pasuruan, that's why the OrderID start with P letter.
*/

drop database if exists dw_oltp3;
create database if not exists dw_oltp3;

use dw_oltp3;

CREATE TABLE IF NOT EXISTS Customers (
  CustomerID VARCHAR(6) PRIMARY KEY,
  CustomerName VARCHAR(75) NOT NULL,
  Gender VARCHAR(2) NOT NULL, -- FM = Female, ML = Male
  Region VARCHAR(20),
  is_warehouse BOOL DEFAULT 0 -- 0 = not yet ; 1 = already
);

CREATE TABLE IF NOT EXISTS Products (
  ProductID VARCHAR(6) PRIMARY KEY,
  ProductName VARCHAR(75) NOT NULL,
  Category VARCHAR(20) NOT NULL,
  Price DECIMAL(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS Orders (
  OrderID VARCHAR(10) PRIMARY KEY,
  CustomerID VARCHAR(6) NOT NULL,
  OrderDate DATE NOT NULL,
  TotalAmount DECIMAL(10,2) NOT NULL,
  is_warehouse BOOL DEFAULT 0, -- 0 = not yet ; 1 = already
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE IF NOT EXISTS OrderDetails (
  OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
  OrderID VARCHAR(10) NOT NULL,
  ProductID VARCHAR(6) NOT NULL,
  Quantity INT NOT NULL,
  ProductPrice DECIMAL(10,2) NOT NULL,
  Discount DECIMAL(5,2) DEFAULT 0,
  is_warehouse BOOL DEFAULT 0, -- 0 = not yet ; 1 = already
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO
  Customers (CustomerID, CustomerName, Region, Gender)
VALUES
	('C30001','Olivia Rodriguez','North America','FM'),
	('C30002','William Miller','Europe','ML'),
	('C30003','Emma Garcia','Asia','FM'),
	('C30004','Noah Brown','South America','ML'),
	('C30005','Sophia Hernandez','Africa','FM'),
	('C30006','James Moore','North America','ML'),
	('C30007','Charlotte Jackson','Europe','FM'),
	('C30008','Aiden Lewis','Asia','ML'),
	('C30009','Mia Carter','South America','FM'),
	('C30010','Benjamin Robinson','Africa','ML'),
	('C30011','Evelyn Jones','North America','FM'),
	('C30012','Daniel Walker','Europe','ML'),
	('C30013','Abigail Young','Asia','FM'),
	('C30014','Logan King','South America','ML'),
	('C30015','Madison Clark','Africa','FM'),
	('C30016','Mason Garcia','North America','ML'),
	('C30017','Chloe Hernandez','Europe','FM'),
	('C30018','Elijah Moore','Asia','ML'),
	('C30019','Isabella Lewis','South America','FM'),
	('C30020','Lucas Carter','Africa','ML');
  
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
	('PFP011', 'Kelloggs Frosted Flakes Cereal', 'Cereal', 4.95),
	('PFP012', 'Campbells Chicken Noodle Soup', 'Soup', 2.75),
	('PFP013', 'Kraft Heinz Ketchup', 'Condiment', 2.29),
	('PFP014', 'Barilla Penne Pasta', 'Pasta', 1.99),
	('PFP015', 'Uncle Bens Original Rice', 'Rice', 2.50),
	-- Beverages (BV)
	('PBV016', 'Coca-Cola Classic Soda', 'Soda', 1.75),
	('PBV017', 'Sprite Zero Sugar Lemon-Lime Soda', 'Soda', 1.50),
	('PBV018', 'Minute Maid Orange Juice', 'Juice', 4.25),
	('PBV019', 'Nescafe Instant Coffee', 'Coffee', 7.99),
	('PBV020', 'Twinings Earl Grey Tea', 'Tea', 4.50);
  
INSERT INTO
  Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES
	('P240113001','C30015','2024-01-13',33.74),
	('P240113002','C30008','2024-01-13',16),
	('P240113003','C30009','2024-01-13',7.25),
	('P240116004','C30016','2024-01-16',5.25),
	('P240116005','C30007','2024-01-16',30.04),
	('P240116006','C30011','2024-01-16',33.58),
	('P240116007','C30018','2024-01-16',35.53),
	('P240116008','C30003','2024-01-16',37.49),
	('P240117009','C30007','2024-01-17',51.96),
	('P240117010','C30017','2024-01-17',45.66),
	('P240119011','C30010','2024-01-19',23.83),
	('P240119012','C30009','2024-01-19',46.47),
	('P240123013','C30019','2024-01-23',61.45),
	('P240123014','C30008','2024-01-23',12.25),
	('P240124015','C30017','2024-01-24',180.19),
	('P240125016','C30012','2024-01-25',15.5),
	('P240125017','C30003','2024-01-25',10.5),
	('P240126018','C30018','2024-01-26',52.37),
	('P240126019','C30011','2024-01-26',130),
	('P240126020','C30006','2024-01-26',25.32);

INSERT INTO
  OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, ProductPrice)
VALUES
	('1','P240113001','PBV016',5,1.75),
	('2','P240113001','PBV019',1,7.99),
	('3','P240113001','PBV018',4,4.25),
	('4','P240113002','PFP015',5,2.5),
	('5','P240113002','PBV016',2,1.75),
	('6','P240113003','PHP010',1,4.75),
	('7','P240113003','PFP015',1,2.5),
	('8','P240116004','PBV016',3,1.75),
	('9','P240116005','PBV018',5,4.25),
	('10','P240116005','PHP007',1,8.79),
	('11','P240116006','PBV020',3,4.5),
	('12','P240116006','PFP013',2,2.29),
	('13','P240116006','PBV020',1,4.5),
	('14','P240116006','PHP006',2,5.5),
	('15','P240116007','PFP013',4,2.29),
	('16','P240116007','PHP007',3,8.79),
	('17','P240116008','PHP006',5,5.5),
	('18','P240116008','PPC002',1,9.99),
	('19','P240117009','PHP006',2,5.5),
	('20','P240117009','PBV020',2,4.5),
	('21','P240117009','PBV019',4,7.99),
	('22','P240117010','PFP013',4,2.29),
	('23','P240117010','PPC004',4,7.75),
	('24','P240117010','PFP012',2,2.75),
	('25','P240119011','PPC005',2,6.29),
	('26','P240119011','PBV017',2,1.5),
	('27','P240119011','PPC001',1,8.25),
	('28','P240119012','PPC001',2,8.25),
	('29','P240119012','PPC002',3,9.99),
	('30','P240123013','PPC002',5,9.99),
	('31','P240123013','PBV017',2,1.5),
	('32','P240123013','PBV018',2,4.25),
	('33','P240123014','PBV016',2,1.75),
	('34','P240123014','PBV016',5,1.75),
	('35','P240124015','PPC003',5,24.5),
	('36','P240124015','PBV016',1,1.75),
	('37','P240124015','PBV019',2,7.99),
	('38','P240124015','PPC002',4,9.99),
	('39','P240125016','PPC004',2,7.75),
	('40','P240125017','PFP015',2,2.5),
	('41','P240125017','PFP012',2,2.75),
	('42','P240126018','PHP006',4,5.5),
	('43','P240126018','PHP008',4,3.99),
	('44','P240126018','PFP013',4,2.29),
	('45','P240126018','PBV016',3,1.75),
	('46','P240126019','PBV017',5,1.5),
	('47','P240126019','PPC003',5,24.5),
	('48','P240126020','PPC002',1,9.99),
	('49','P240126020','PPC005',2,6.29),
	('50','P240126020','PFP012',1,2.75);
