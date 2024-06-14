DROP DATABASE IF EXISTS subsif10_datawarehouse;
CREATE DATABASE IF NOT EXISTS subsif10_datawarehouse;
USE subsif10_datawarehouse;

-- Drop tables if they exist to start fresh
DROP TABLE IF EXISTS `user`;
DROP TABLE IF EXISTS fact;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS product;
DROP PROCEDURE IF EXISTS GetTotalRevenueByOrigin;
DROP PROCEDURE IF EXISTS GetBestSellingProductsByOrigin;
DROP PROCEDURE IF EXISTS GetTotalUsersByOrigin;
DROP PROCEDURE IF EXISTS GetAverageTransactionValueByOrigin;
DROP PROCEDURE IF EXISTS GetTransactionCountOverTimeByOrigin;

-- Create User table
CREATE TABLE IF NOT EXISTS `user` (
   id_user VARCHAR(10) PRIMARY KEY,
   name VARCHAR(40) NOT NULL,
   email VARCHAR(100),
   CustOrigin VARCHAR(255),
   is_fact BOOLEAN DEFAULT 0
);

-- Create Category table
CREATE TABLE IF NOT EXISTS category (
  id_category VARCHAR(10) PRIMARY KEY,
  nama_category VARCHAR(30)
);

-- Create Product table
CREATE TABLE IF NOT EXISTS product (
  id_product VARCHAR(10) PRIMARY KEY,
  id_category VARCHAR(10) NOT NULL,
  nama_product VARCHAR(100),
  price_unit DECIMAL(16, 2),
  stock INT,
  description LONGTEXT,
  sold_count INT,
  weight VARCHAR(10),
  image LONGTEXT,
  FOREIGN KEY (id_category) REFERENCES category(id_category)
);

-- Create Transaction table
CREATE TABLE IF NOT EXISTS transaction (
  id_transaction VARCHAR(10) PRIMARY KEY,
  id_product VARCHAR(10),
  id_user VARCHAR(10),
  total_price DECIMAL(16, 2),
  transaction_date DATE Not Null,
  OrderOrigin VARCHAR(100),
  is_fact BOOLEAN DEFAULT 0,
  FOREIGN KEY (id_product) REFERENCES product(id_product),
  FOREIGN KEY (id_user) REFERENCES user(id_user)
);

-- Create Fact table
CREATE TABLE IF NOT EXISTS fact (
  OrderID INT AUTO_INCREMENT PRIMARY KEY,
  id_transaction VARCHAR(10),
  id_user VARCHAR(10),
  id_product VARCHAR(10),
  TotalAmount DECIMAL(16, 2) NOT NULL,
  OrderOrigin VARCHAR(100),
  FOREIGN KEY (id_user) REFERENCES user(id_user),
  FOREIGN KEY (id_product) REFERENCES product(id_product),
  FOREIGN KEY (id_transaction) REFERENCES transaction(id_transaction)
);

-- Drop existing triggers if they exist
DROP TRIGGER IF EXISTS Cust_origin;
DROP TRIGGER IF EXISTS Orders_origin;

-- Create trigger Cust_origin
DELIMITER $$
CREATE TRIGGER Cust_origin 
BEFORE INSERT ON user
FOR EACH ROW
BEGIN
  IF SUBSTR(new.id_user, 1, 2) = 'UA' THEN SET new.CustOrigin = 'oltp_ricky';
  ELSEIF SUBSTR(new.id_user, 1, 2) = 'UB' THEN SET new.CustOrigin = 'oltp_steivan';
  ELSEIF SUBSTR(new.id_user, 1, 2) = 'UC' THEN SET new.CustOrigin = 'oltp_juan';
  ELSE SET new.CustOrigin = '-';
  END IF;
END$$
DELIMITER ;

-- Create trigger Orders_origin
DELIMITER $$
CREATE TRIGGER Orders_origin 
BEFORE INSERT ON transaction
FOR EACH ROW
BEGIN
  IF SUBSTR(new.id_transaction, 1, 2) = 'TA' THEN SET new.OrderOrigin = 'oltp_ricky';
  ELSEIF SUBSTR(new.id_transaction, 1, 2) = 'TB' THEN SET new.OrderOrigin = 'oltp_steivan';
  ELSEIF SUBSTR(new.id_transaction, 1, 2) = 'TC' THEN SET new.OrderOrigin = 'oltp_juan';
  ELSE SET new.OrderOrigin = '-';
  END IF;
END$$
DELIMITER ;


-- -- FUNCTION --------
DELIMITER $$
CREATE PROCEDURE GetTotalRevenueByOrigin()
BEGIN
    SELECT OrderOrigin, SUM(total_price) AS TotalRevenue
    FROM transaction
    GROUP BY OrderOrigin;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE GetBestSellingProductsByOrigin(IN origin VARCHAR(100))
BEGIN
    SELECT p.id_product, p.nama_product, SUM(t.total_price) AS TotalRevenue
    FROM transaction t
    JOIN product p ON t.id_product = p.id_product
    WHERE t.OrderOrigin = origin
    GROUP BY p.id_product, p.nama_product
    ORDER BY TotalRevenue DESC
    LIMIT 10;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE GetTotalUsersByOrigin()
BEGIN
    SELECT CustOrigin, COUNT(DISTINCT id_user) AS TotalUsers
    FROM user
    GROUP BY CustOrigin;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE GetAverageTransactionValueByOrigin()
BEGIN
    SELECT OrderOrigin, AVG(total_price) AS AverageTransactionValue
    FROM transaction
	GROUP BY OrderOrigin;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE GetTransactionCountOverTimeByOrigin(IN origin VARCHAR(100))
BEGIN
    SELECT transaction_date AS TransactionDate, COUNT(*) AS TransactionCount
    FROM transaction
    WHERE OrderOrigin = origin
    GROUP BY OrderOrigin
    ORDER BY TransactionDate;
END $$
DELIMITER ;

CALL GetTotalRevenueByOrigin();
CALL GetBestSellingProductsByOrigin('oltp_ricky');
CALL GetTotalUsersByOrigin();
CALL GetAverageTransactionValueByOrigin();
CALL GetTransactionCountOverTimeByOrigin('oltp_ricky');
