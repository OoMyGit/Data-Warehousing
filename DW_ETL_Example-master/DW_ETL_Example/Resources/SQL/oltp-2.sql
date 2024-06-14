/*
This OLTP is located in Gresik, that's why the OrderID start with G letter.
*/

drop database if exists dw_oltp2;
create database if not exists dw_oltp2;

use dw_oltp2;

CREATE TABLE IF NOT EXISTS Customers (
  CustomerID VARCHAR(6) PRIMARY KEY,
  CustomerName VARCHAR(75) NOT NULL,
  Gender VARCHAR(1) NOT NULL,
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
	('C20001','John Doe','North America','M'),
	('C20002','Alice Smith','Europe','F'),
	('C20003','Michael Johnson','Asia','M'),
	('C20004','Emily Brown','Australia','F'),
	('C20005','William Wilson','South America','M'),
	('C20006','Sophia Lee','Africa','F'),
	('C20007','James Taylor','Europe','M'),
	('C20008','Olivia Martinez','North America','F'),
	('C20009','Daniel Anderson','Asia','M'),
	('C20010','Ava Thomas','Australia','F'),
	('C20011','Matthew White','South America','M'),
	('C20012','Emma Garcia','Africa','F'),
	('C20013','David Rodriguez','Europe','M'),
	('C20014','Isabella Lopez','North America','F'),
	('C20015','Joseph Perez','Asia','M'),
	('C20016','Mia Gonzalez','Australia','F'),
	('C20017','Andrew Hernandez','South America','M'),
	('C20018','Abigail Smith','Africa','F'),
	('C20019','Alexander Brown','Europe','M'),
	('C20020','Ella Davis','North America','F');
  
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
	('G240114001','C20017','2024-01-14',27.47),
	('G240114002','C20011','2024-01-14',73.7),
	('G240115003','C20014','2024-01-15',6),
	('G240115004','C20001','2024-01-15',46.82),
	('G240116005','C20020','2024-01-16',18.49),
	('G240116006','C20014','2024-01-16',22.5),
	('G240117007','C20015','2024-01-17',73.49),
	('G240117008','C20001','2024-01-17',14),
	('G240118009','C20015','2024-01-18',35.16),
	('G240119010','C20011','2024-01-19',48.7),
	('G240119011','C20007','2024-01-19',52),
	('G240119012','C20003','2024-01-19',31.29),
	('G240119013','C20016','2024-01-19',34.97),
	('G240119014','C20017','2024-01-19',67.45),
	('G240123015','C20008','2024-01-23',148.73),
	('G240123016','C20004','2024-01-23',68.75),
	('G240124017','C20014','2024-01-24',4.5),
	('G240125018','C20014','2024-01-25',35.37),
	('G240125019','C20012','2024-01-25',130.49),
	('G240125020','C20011','2024-01-25',19.5);
  
INSERT INTO
  OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, ProductPrice)
VALUES
	('1','G240114001','PFP012',5,2.75),
	('2','G240114001','PBV016',1,1.75),
	('3','G240114001','PHP008',3,3.99),
	('4','G240114002','PHP010',2,4.75),
	('5','G240114002','PPC002',5,9.99),
	('6','G240114002','PHP010',3,4.75),
	('7','G240115003','PBV017',4,1.5),
	('8','G240115004','PFP013',3,2.29),
	('9','G240115004','PBV019',5,7.99),
	('10','G240116005','PFP015',3,2.5),
	('11','G240116005','PHP008',1,3.99),
	('12','G240116005','PBV016',4,1.75),
	('13','G240116006','PHP009',2,2.25),
	('14','G240116006','PHP009',4,2.25),
	('15','G240116006','PHP009',4,2.25),
	('16','G240117007','PPC001',5,8.25),
	('17','G240117007','PHP009',5,2.25),
	('18','G240117007','PBV018',4,4.25),
	('19','G240117007','PHP008',1,3.99),
	('20','G240117008','PBV016',5,1.75),
	('21','G240117008','PBV016',3,1.75),
	('22','G240118009','PHP007',4,8.79),
	('23','G240119010','PHP007',5,8.79),
	('24','G240119010','PHP010',1,4.75),
	('25','G240119011','PHP010',3,4.75),
	('26','G240119011','PHP009',3,2.25),
	('27','G240119011','PPC004',4,7.75),
	('28','G240119012','PFP012',1,2.75),
	('29','G240119012','PPC005',2,6.29),
	('30','G240119012','PHP008',4,3.99),
	('31','G240119013','PHP006',2,5.5),
	('32','G240119013','PBV019',3,7.99),
	('33','G240119014','PBV019',5,7.99),
	('34','G240119014','PHP006',5,5.5),
	('35','G240123015','PFP014',2,1.99),
	('36','G240123015','PFP015',2,2.5),
	('37','G240123015','PPC003',5,24.5),
	('38','G240123015','PBV018',2,4.25),
	('39','G240123015','PBV016',5,1.75),
	('40','G240123016','PPC001',4,8.25),
	('41','G240123016','PPC001',1,8.25),
	('42','G240123016','PHP006',5,5.5),
	('43','G240124017','PBV017',3,1.5),
	('44','G240125018','PHP007',3,8.79),
	('45','G240125018','PBV020',2,4.5),
	('46','G240125019','PFP014',1,1.99),
	('47','G240125019','PBV017',4,1.5),
	('48','G240125019','PPC003',5,24.5),
	('49','G240125020','PFP015',5,2.5),
	('50','G240125020','PBV016',4,1.75);
  