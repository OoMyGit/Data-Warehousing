/*
This OLTP is located in Nganjuk, that's why the OrderID start with N letter.
*/

drop database if exists dw_oltp1;
create database if not exists dw_oltp1;

use dw_oltp1;

CREATE TABLE IF NOT EXISTS Customers (
  CustomerID VARCHAR(6) PRIMARY KEY,
  CustomerName VARCHAR(75) NOT NULL,
  Gender VARCHAR(6) NOT NULL,
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
  is_warehouse BOOL DEFAULT 0,-- 0 = not yet ; 1 = already
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
	('C10001','John Doe','North America','Male'),
	('C10002','Alice Smith','Europe','Female'),
	('C10003','Michael Johnson','Asia','Male'),
	('C10004','Emily Brown','Australia','Female'),
	('C10005','William Wilson','South America','Male'),
	('C10006','Sophia Lee','Africa','Female'),
	('C10007','James Anderson','Europe','Male'),
	('C10008','Olivia Martinez','North America','Female'),
	('C10009','Daniel Taylor','Asia','Male'),
	('C10010','Ava Garcia','Australia','Female'),
	('C10011','David Rodriguez','South America','Male'),
	('C10012','Emma Hernandez','Africa','Female'),
	('C10013','Joseph Lopez','Europe','Male'),
	('C10014','Mia Gonzalez','North America','Female'),
	('C10015','Alexander Perez','Asia','Male'),
	('C10016','Charlotte Moore','Australia','Female'),
	('C10017','Ethan Davis','South America','Male'),
	('C10018','Amelia Clark','Africa','Female'),
	('C10019','Benjamin Lewis','Europe','Male'),
	('C10020','Harper Adams','North America','Female');
 
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
	('N240113001','C10012','2024-01-13',22.79),
	('N240113002','C10002','2024-01-13',52.7),
	('N240113003','C10010','2024-01-13',27),
	('N240116004','C10004','2024-01-16',135.75),
	('N240116005','C10014','2024-01-16',86.86),
	('N240116006','C10014','2024-01-16',64.7),
	('N240116007','C10008','2024-01-16',7.79),
	('N240116008','C10020','2024-01-16',20.75),
	('N240117009','C10014','2024-01-17',19.85),
	('N240117010','C10020','2024-01-17',88.95),
	('N240119011','C10008','2024-01-19',64.82),
	('N240119012','C10015','2024-01-19',3),
	('N240119013','C10017','2024-01-19',34.75),
	('N240119014','C10001','2024-01-19',23.48),
	('N240120015','C10012','2024-01-20',144.59),
	('N240120016','C10005','2024-01-20',11.25),
	('N240120017','C10007','2024-01-20',17),
	('N240121018','C10005','2024-01-21',42.24),
	('N240121019','C10010','2024-01-21',6.24),
	('N240121020','C10018','2024-01-21',19.72);

INSERT INTO
  OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, ProductPrice)
VALUES
	('1','N240113001','PPC001',2,8.25),
	('2','N240113001','PPC005',1,6.29),
	('3','N240113002','PFP013',5,2.29),
	('4','N240113002','PPC001',5,8.25),
	('5','N240113003','PBV020',1,4.5),
	('6','N240113003','PBV020',5,4.5),
	('7','N240116004','PPC003',5,24.5),
	('8','N240116004','PHP009',1,2.25),
	('9','N240116004','PHP006',2,5.5),
	('10','N240116005','PBV019',4,7.99),
	('11','N240116005','PBV020',2,4.5),
	('12','N240116005','PFP014',5,1.99),
	('13','N240116005','PFP013',5,2.29),
	('14','N240116005','PPC003',1,24.5),
	('15','N240116006','PBV019',4,7.99),
	('16','N240116006','PBV019',1,7.99),
	('17','N240116006','PPC001',3,8.25),
	('18','N240116007','PBV017',1,1.5),
	('19','N240116007','PPC005',1,6.29),
	('20','N240116008','PBV020',4,4.5),
	('21','N240116008','PFP012',1,2.75),
	('22','N240117009','PFP011',3,4.95),
	('23','N240117009','PFP015',2,2.5),
	('24','N240117010','PPC004',1,7.75),
	('25','N240117010','PBV019',5,7.99),
	('26','N240117010','PPC001',5,8.25),
	('27','N240119011','PPC001',2,8.25),
	('28','N240119011','PFP013',3,2.29),
	('29','N240119011','PBV017',1,1.5),
	('30','N240119011','PBV019',5,7.99),
	('31','N240119012','PBV017',2,1.5),
	('32','N240119013','PFP015',4,2.5),
	('33','N240119013','PFP011',5,4.95),
	('34','N240119014','PFP015',3,2.5),
	('35','N240119014','PBV019',2,7.99),
	('36','N240120015','PPC003',3,24.5),
	('37','N240120015','PPC005',4,6.29),
	('38','N240120015','PPC002',3,9.99),
	('39','N240120015','PHP008',4,3.99),
	('40','N240120016','PHP009',5,2.25),
	('41','N240120017','PPC004',2,7.75),
	('42','N240120017','PBV017',1,1.5),
	('43','N240121018','PPC005',5,6.29),
	('44','N240121018','PBV017',3,1.5),
	('45','N240121018','PPC005',1,6.29),
	('46','N240121019','PBV018',1,4.25),
	('47','N240121019','PFP014',1,1.99),
	('48','N240121020','PHP008',3,3.99),
	('49','N240121020','PFP012',1,2.75),
	('50','N240121020','PFP015',2,2.5);
