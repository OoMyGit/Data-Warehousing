CREATE DATABASE IF NOT EXISTS oltp_ricky;
USE oltp_ricky;

-- Disable foreign key checks
SET FOREIGN_KEY_CHECKS = 0;

-- Drop all tables and triggers
DROP TRIGGER IF EXISTS before_user_insert;
DROP TRIGGER IF EXISTS before_transaction_insert;
DROP TABLE IF EXISTS order_detail;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Cart;
DROP TABLE IF EXISTS wishlist;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Shipment;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Transaction;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Create User table
CREATE TABLE IF NOT EXISTS User (
  id_user VARCHAR(10) PRIMARY KEY,
  name VARCHAR(40) NOT NULL,
  birthdate DATE,
  gender VARCHAR(10),
  phone_number VARCHAR(12),
  address VARCHAR(100),
  province VARCHAR(50),
  city VARCHAR(50),
  postal_code VARCHAR(10),
  username VARCHAR(50) NOT NULL,
  email VARCHAR(100),
  password TEXT NOT NULL,
  is_warehouse BOOL DEFAULT 0
);

-- Create Category table
CREATE TABLE IF NOT EXISTS Category (
  id_category VARCHAR(10) PRIMARY KEY,
  nama_category VARCHAR(30)
);

-- Create product table
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
  FOREIGN KEY (id_category) REFERENCES Category(id_category)
);

-- Create Orders table
CREATE TABLE IF NOT EXISTS Orders (
  order_id VARCHAR(10) PRIMARY KEY,
  id_user VARCHAR(10) NOT NULL,
  subtotal DECIMAL(10,2),
  tax_amount DECIMAL(10,2),
  shipping_cost DECIMAL(10,2),
  total_amount DECIMAL(10,2),
  quantity_ordered INT,
  order_date DATE,
  paid_date TIMESTAMP,
  ship_date TIMESTAMP,
  order_status VARCHAR(30),
  FOREIGN KEY (id_user) REFERENCES User(id_user)
);

-- Create Shipment table
CREATE TABLE IF NOT EXISTS Shipment (
  shipment_id VARCHAR(10) PRIMARY KEY,
  order_id VARCHAR(10) NOT NULL,
  company_name VARCHAR(50),
  shipper_phonenumber VARCHAR(20),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Create Payment table
CREATE TABLE IF NOT EXISTS Payment (
  payment_id VARCHAR(12) PRIMARY KEY,
  order_id VARCHAR(10) NOT NULL,
  payment_method VARCHAR(20),
  payment_date DATE,
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Create order_detail table
CREATE TABLE IF NOT EXISTS order_detail (
  id_product VARCHAR(10),
  order_id VARCHAR(10),
  PRIMARY KEY (id_product, order_id),
  FOREIGN KEY (id_product) REFERENCES product(id_product),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Create Cart table
CREATE TABLE IF NOT EXISTS Cart (
  id_cart INT PRIMARY KEY AUTO_INCREMENT,
  id_product VARCHAR(10),
  id_user VARCHAR(10),
  quantity INT,
  FOREIGN KEY (id_product) REFERENCES product(id_product),
  FOREIGN KEY (id_user) REFERENCES User(id_user)
);

-- Create wishlist table
CREATE TABLE IF NOT EXISTS wishlist (
  id_wishlist INT PRIMARY KEY AUTO_INCREMENT,
  id_product VARCHAR(10),
  id_user VARCHAR(10),
  FOREIGN KEY (id_product) REFERENCES product(id_product),
  FOREIGN KEY (id_user) REFERENCES User(id_user)
);

-- Create Transaction table
CREATE TABLE IF NOT EXISTS transaction (
  id_transaction VARCHAR(10) PRIMARY KEY,
  id_product VARCHAR(10),
  id_user VARCHAR(10),
  total_price DECIMAL(16, 2),
  transaction_date DATE,  -- New column for transaction date
  is_warehouse BOOL DEFAULT 0,
  FOREIGN KEY (id_product) REFERENCES product(id_product),
  FOREIGN KEY (id_user) REFERENCES user(id_user)
);



-- -----------------------------------------------


-- Create trigger to format id_user
DELIMITER $$

-- Trigger to generate id_user in the format UAxxxxx
CREATE TRIGGER before_user_insert
BEFORE INSERT ON User
FOR EACH ROW
BEGIN
  DECLARE max_id INT;
  DECLARE new_id VARCHAR(10);

  -- Get the maximum numeric part of the id_user and increment
  SELECT IFNULL(MAX(CAST(SUBSTRING(id_user, 3, 5) AS UNSIGNED)), 0) + 1 INTO max_id FROM User;

  -- Create the new id in the format UA00001, UA00002, etc.
  SET new_id = CONCAT('UA', LPAD(max_id, 5, '0'));

  -- Set the new id_user
  SET NEW.id_user = new_id;
END$$

DELIMITER ;


-- --------------------------------


-- Create trigger to format id_transaction
DELIMITER $$

CREATE TRIGGER before_transaction_insert
BEFORE INSERT ON Transaction
FOR EACH ROW
BEGIN
  DECLARE max_id INT;
  DECLARE new_id VARCHAR(10);

  -- Get the maximum numeric part of the id_transaction and increment
  SELECT IFNULL(MAX(CAST(SUBSTRING(id_transaction, 3, 5) AS UNSIGNED)), 0) + 1 INTO max_id FROM Transaction;

  -- Create the new id in the format TA0001, TA0002, etc.
  SET new_id = CONCAT('TA', LPAD(max_id, 5, '0'));

  -- Set the new id_transaction
  SET NEW.id_transaction = new_id;
END$$

DELIMITER ;




-- --------------------------------



-- Create trigger to format id_product
DELIMITER $$

CREATE TRIGGER before_product_insert
BEFORE INSERT ON product
FOR EACH ROW
BEGIN
  DECLARE max_id INT;
  DECLARE new_id VARCHAR(10);

  -- Get the maximum numeric part of the id_product and increment
  SELECT IFNULL(MAX(CAST(SUBSTRING(id_product, 3, 5) AS UNSIGNED)), 0) + 1 INTO max_id FROM product;

  -- Create the new id in the format P001, P002, etc.
  SET new_id = CONCAT('PA', LPAD(max_id, 5, '0'));

  -- Set the new id_product
  SET NEW.id_product = new_id;
END$$

DELIMITER ;


-- --------------------------------------------


-- Insert data into Category table
INSERT INTO Category (id_category, Nama_Category) VALUES ('C001', 'Light');
INSERT INTO Category (id_category, Nama_Category) VALUES ('C002', 'Oils');
INSERT INTO Category (id_category, Nama_Category) VALUES ('C003', 'Air Fresheners');
INSERT INTO Category (id_category, Nama_Category) VALUES ('C004', 'Air Intake');
INSERT INTO Category (id_category, Nama_Category) VALUES ('C005', 'Gauge');
INSERT INTO Category (id_category, Nama_Category) VALUES ('C006', 'Tires');
INSERT INTO Category (id_category, Nama_Category) VALUES ('C007', 'Rims');
INSERT INTO Category (id_category, Nama_Category) VALUES ('C008', 'Interior Accessories');
INSERT INTO Category (id_category, Nama_Category) VALUES ('C009', 'Phone Holders');
INSERT INTO Category (id_category, Nama_Category) VALUES ('C010', 'Spark Plugs');
INSERT INTO Category (id_category, Nama_Category) VALUES ('C011', 'Turbo');
INSERT INTO Category (id_category, Nama_Category) VALUES ('C012', 'Brakes');
INSERT INTO Category (id_category, Nama_Category) VALUES ('C013', 'Muffler');
INSERT INTO Category (id_category, Nama_Category) VALUES ('C014', 'Detailing');
INSERT INTO Category (id_category, Nama_Category) VALUES ('C015', 'Wiper');


-- Insert data into product table
INSERT INTO product ( id_category, nama_product, price_unit, stock, description, sold_count, weight, image) VALUES 
('C003', 'Little Trees Morning Fresh', 20000, 30, 'Little Trees Morning Fresh', 0, '10g', 'ltmrngfrsh.jpeg'), 
('C003', 'Little Trees Summer Linen', 20000, 20, 'Little Trees Summer Linen', 0, '10g', 'https://down-id.img.susercontent.com/file/0be4737f680d23db90223e49a4f178fb'), 
('C003', 'Little Trees Green Apple', 20000, 25, 'Little Trees Green Apple', 0, '10g', 'https://down-id.img.susercontent.com/file/2c63f5b0f7f552a725e87a68434bb757'), 
('C003', 'Little Trees Leather', 20000, 32, 'Little Trees Leather', 0, '10g', 'https://down-id.img.susercontent.com/file/d7620713ff5a68bdb78aad70f9e50a60'), 
('C003', 'Little Trees Pina Colada', 20000, 18, 'Little Trees Pina Colada', 0, '10g', 'https://down-id.img.susercontent.com/file/cc913bde353871ff5aee987e89e8b642'), 
('C003', 'Little Trees Vanilla Strawberry XTRA STRENGTH', 20000, 10, 'Little Trees Vanilla Strawberry XTRA STRENGTH', 5, '10g', 'https://down-id.img.susercontent.com/file/id-11134207-7qukw-lhonlbgxz7mcdb'), 
('C003', 'Little Trees True North', 20000, 15, 'Little Trees True North', 0, '10g', 'https://down-id.img.susercontent.com/file/e473a2e237d98f10f65c64fd68fa64a4'), 
('C004', 'Spectre Air Intake', 3000000, 5, 'Air Intake for Honda Civic 1.5L', 0, '1300g', 'https://cdn.shopify.com/s/files/1/1889/8657/products/867acfa32f15e0b9306bd8cce367a1f1_f28ce957-9fc2-4a26-abed-bc8a08cd65d9_600x.jpg?v=1690394693'), 
('C004', 'K&N Universal Round Tapered Filter', 1030000, 9, 'K&N Universal Round Tapered Filter 6in Flange ID x 7-1/2in - RF-10200', 5, '100g', 'https://cdn.shopify.com/s/files/1/1889/8657/products/770323bf0d9bfb1342ffa7243e31b202_600x.jpg?v=1627479432'), 
('C004', 'K&N Universal Clamp On Filter', 1320000, 3, 'K&N Universal Clamp-On Air Filter 2in Flange / 6-7/8in B - RC-70018', 1, '130g', 'https://cdn.shopify.com/s/files/1/1889/8657/products/0d8139f0c18176fcda95fc8916eabd81_a3dc0bb8-01be-439e-a1c1-4763f4216e0e_600x.jpg?v=1627505593'),
('C004', 'K&N Universal Clamp-On Air Filter 6in', 1050000, 7, 'K&N Universal Clamp-On Air Filter 6in Flange / 7-1/2in Base - RU-1048XD', 10, '95g', 'https://throtl.com/cdn/shop/products/300ddb277adfba1a08e817cc8d6d7313_750x.jpg?v=1627510306'),
('C004', 'K&N Universal Round Clamp-On Air Filter', 1400000, 6, 'K&N Universal Round Clamp-On Air Filter 4-1/2in FLG, 5-7/8in B, - RU-1021', 0, '109g', 'https://throtl.com/cdn/shop/products/c4c8f46c7fea6a46dc523323bd3b0e4e_750x.jpg?v=1688045271'),
('C004', 'AEM 2.75 inch Dryflow Air Filter', 1300000, 3, 'AEM 2.75 inch Dryflow Air Filter with 9 inch Element - 21-2029DK', 2, '99g', 'https://throtl.com/cdn/shop/files/d91c3dfa61b8981f7c66dcff181fab3a_750x.jpg?v=1711882814'),
('C004', 'Injen Nanofiber Dry Air Filter', 1230000, 5, 'Injen Nanofiber Dry Air Filter - 4in Flange Dia / - X-1026-BB', 0, '102g', 'https://throtl.com/cdn/shop/files/6167da985f2cddc2b05c076af351cdf8_750x.jpg?v=1711796679'),
('C004', 'AEM X-Series Wideband UEGO AFR Sensor', 2980000, 7, 'X-Series Wideband UEGO AFR Sensor Controller Gauge with X-Digital Technology.', 0, '35g', 'https://throtl.com/cdn/shop/products/2f94eb85cadb0b78d694964be88e6514_750x.jpg?v=1690369919'),
('C004', 'AEM CD-5 Carbon Flush Digital Dash Display', 16000000, 5, 'Flat Panel Digital Dash Display, CD-5 non-logging, non-GPS racing dash.', 2, '1000g', 'https://throtl.com/cdn/shop/products/7Z0Dn6svH2__73913.1558496126_d7489ee7-bf3e-4b6b-9045-ff44d4906614_1100x.jpg?v=1695738930'),
('C005', 'Autometer Ultra-Lite 52mm 0-100 PSI Mechanical Oil Pressure Gauge', 670000, 3, 'Autometer Ultra-Lite 52mm 0-100 PSI Mechanical Oil Pressure Gauge.', 0, '120g', 'https://throtl.com/cdn/shop/products/da83184703d0a14a6c651257785ad035_750x.jpg?v=1695035089'),
('C005', 'Autometer Sport-Comp 52mm 60-170 Degree Short Sweep Electronic Oil Temperature', 730000, 7, 'Autometer Sport-Comp 52mm 60-170 Degree Short Sweep Electronic Oil Temperature Gauge', 3, '150g', 'https://throtl.com/cdn/shop/products/4fd4566a53637d63a16dabc84aa3f697_083d4104-cb7f-4645-acf4-d2d83f49024d_750x.jpg?v=1695034984'),
('C005', 'Autometer Stack Pro Control 52mm 100-260 deg F Water Temp', 3600000, 4, 'Autometer Stack Pro Control 52mm 100-260 deg F Water Temp Gauge - Black (1/8in NPTF Male).', 1, '112g', 'https://throtl.com/cdn/shop/files/b0ab088f830b560471fa4d4a4cbc890c_750x.jpg?v=1711796440'),
('C005', 'Autometer Ultra-Lite 52mm Digital Wideband Air/Fuel Ratio Street Gauge', 3250000, 9, 'Autometer Ultra-Lite 52mm Digital Wideband Air/Fuel Ratio Street Gauge', 5, '121g', 'https://throtl.com/cdn/shop/products/2fb3d664137b4e9e6e655baaa648be95_750x.jpg?v=1695035082'),
('C005', 'Autometer Sport-Comp 52.4mm 140-280 Deg F Mech Oil Temp Gauge', 1700000, 1, 'Autometer Sport-Comp 52.4mm 140-280 Deg F Mech Oil Temp Gauge', 0, '115g', 'https://throtl.com/cdn/shop/products/9b7471129c35c2ba2bb0565668117ee5_750x.jpg?v=1695035091'),
('C001', 'Bosch Gigalight H1', 300000, 40, 'Bosch Lampu Mobil Gigalight Plus 120 H1 - 12V 55W', 0, '300g', 'lampuboschh1.jpeg'), 
('C001', 'Philips Halogen 5000K', 315000, 15, 'Lampu philips Halogen 5000K', 3, '250g', 'philipshalogen.png'), 
('C001', 'Saber Sr1 Nano', 1500000, 11, 'Lampu Mini projector 1 Mata 23watt', 0, '500g', 'sabermp1.jpg'), 
('C001', 'Foglamp Aes', 1300000, 3, 'Fog lamp AES Biled 43watt', 0, '600g', 'foglampaes.jpeg');

-- Insert data into User table
INSERT INTO User (name, birthdate, gender, phone_number, address, province, city, postal_code, username, email, password) VALUES 
('Alice Johnson', '1992-01-13', 'Female', '081300112233', '789 Oak St', 'East Java', 'Surabaya', '60123', 'alicejohnson', 'alicejohnson@example.com', 'password1'),
('Bob Williams', '1987-05-21', 'Male', '081400224455', '321 Pine St', 'Bali', 'Denpasar', '80123', 'bobwilliams', 'bobwilliams@example.com', 'password1'),
('Charlie Brown', '1989-09-30', 'Male', '081500336677', '654 Birch St', 'North Sumatra', 'Medan', '20234', 'charliebrown', 'charliebrown@example.com', 'password1'),
('Daisy Miller', '1993-11-12', 'Female', '081600448899', '987 Maple St', 'West Sumatra', 'Padang', '90123', 'daisymiller', 'daisymiller@example.com', 'password1'),
('Ethan Davis', '1984-02-25', 'Male', '081700551122', '234 Cedar St', 'South Sulawesi', 'Makassar', '90234', 'ethandavis', 'ethandavis@example.com', 'password1'),
('Fiona Green', '1991-06-14', 'Female', '081800663344', '567 Walnut St', 'Lampung', 'Bandar Lampung', '70345', 'fionagreen', 'fionagreen@example.com', 'password1'),
('George White', '1988-08-23', 'Male', '081900775566', '890 Fir St', 'Riau', 'Pekanbaru', '70456', 'georgewhite', 'georgewhite@example.com', 'password1'),
('Hannah Black', '1994-12-19', 'Female', '082100887799', '112 Spruce St', 'Central Kalimantan', 'Palangkaraya', '80567', 'hannahblack', 'hannahblack@example.com', 'password1'),
('Ian Brown', '1986-04-07', 'Male', '082200990011', '334 Ash St', 'South Kalimantan', 'Banjarmasin', '80678', 'ianbrown', 'ianbrown@example.com', 'password1'),
('Jade Clark', '1995-03-16', 'Female', '082301112223', '556 Elm St', 'East Kalimantan', 'Samarinda', '80789', 'jadeclark', 'jadeclark@example.com', 'password1'),
('Kevin Walker', '1983-10-29', 'Male', '082401223344', '778 Poplar St', 'Maluku', 'Ambon', '90890', 'kevinwalker', 'kevinwalker@example.com', 'password1'),
('Laura Adams', '1996-07-05', 'Female', '082501334455', '990 Pine St', 'Papua', 'Jayapura', '90901', 'lauraadams', 'lauraadams@example.com', 'password1'),
('Mike Robinson', '1982-01-11', 'Male', '082601445566', '123 Oak St', 'West Kalimantan', 'Pontianak', '91012', 'mikerobinson', 'mikerobinson@example.com', 'password1'),
('Nina Lewis', '1997-06-22', 'Female', '082701556677', '345 Pine St', 'Central Sulawesi', 'Palu', '91123', 'ninalewis', 'ninalewis@example.com', 'password1'),
('Oscar Young', '1981-02-28', 'Male', '082801667788', '567 Oak St', 'North Sulawesi', 'Manado', '91234', 'oscaryoung', 'oscaryoung@example.com', 'password1'),
('Paula Hall', '1998-09-03', 'Female', '082901778899', '789 Maple St', 'Banten', 'Serang', '91345', 'paulahall', 'paulahall@example.com', 'password1'),
('Quinn Scott', '1980-10-10', 'Male', '083001889900', '111 Cedar St', 'Aceh', 'Banda Aceh', '91456', 'quinnscott', 'quinnscott@example.com', 'password1'),
('Rachel King', '1999-08-14', 'Female', '083101991011', '222 Pine St', 'Jambi', 'Jambi', '91567', 'rachelking', 'rachelking@example.com', 'password1'),
('Steve Wright', '1985-11-05', 'Male', '083202112223', '333 Oak St', 'South Sumatra', 'Palembang', '91678', 'stevewright', 'stevewright@example.com', 'password1'),
('Tina Edwards', '1982-03-09', 'Female', '083302223344', '444 Elm St', 'West Nusa Tenggara', 'Mataram', '91789', 'tinaedwards', 'tinaedwards@example.com', 'password1'),
('Uma Baker', '2000-04-18', 'Female', '083402334455', '555 Maple St', 'Central Java', 'Yogyakarta', '91890', 'umabaker', 'umabaker@example.com', 'password1'),
('Victor Evans', '1979-05-27', 'Male', '083502445566', '666 Cedar St', 'East Nusa Tenggara', 'Kupang', '91901', 'victorevans', 'victorevans@example.com', 'password1'),
('Wendy Turner', '1995-06-21', 'Female', '083602556677', '777 Pine St', 'Jakarta', 'Jakarta', '10120', 'wendyturner', 'wendyturner@example.com', 'password1'),
('Xavier Perez', '1993-07-08', 'Male', '083702667788', '888 Elm St', 'Bangka Belitung', 'Pangkal Pinang', '31111', 'xavierperez', 'xavierperez@example.com', 'password1'),
('Yara Cruz', '1994-08-29', 'Female', '083802778899', '999 Maple St', 'Gorontalo', 'Gorontalo', '32122', 'yaracruz', 'yaracruz@example.com', 'password1'),
('Zachary Morgan', '1989-11-17', 'Male', '083902889900', '111 Oak St', 'Bengkulu', 'Bengkulu', '33133', 'zacharymorgan', 'zacharymorgan@example.com', 'password1');

-- Insert data into Transaction table
INSERT INTO Transaction (id_product, id_user, transaction_date, total_price) VALUES
('PA00001', 'UA00001', '2024-06-01', 29000000),
('PA00002', 'UA00002', '2024-06-02', 400000),
('PA00003', 'UA00003', '2024-06-03', 2500000),
('PA00004', 'UA00004', '2024-06-04', 1500000),
('PA00005', 'UA00005', '2024-06-05', 4500000),
('PA00006', 'UA00006', '2024-06-06', 1800000),
('PA00010', 'UA00007', '2024-06-07', 7200000),
('PA00005', 'UA00008', '2024-06-08', 3000000),
('PA00008', 'UA00009', '2024-06-09', 1500000),
('PA00013', 'UA00010', '2024-06-10', 7500000),
('PA00014', 'UA00011', '2024-06-11', 4500000),
('PA00021', 'UA00012', '2024-06-12', 2400000),
('PA00025', 'UA00013', '2024-06-13', 6000000),
('PA00020', 'UA00014', '2024-06-14', 8000000),
('PA00010', 'UA00015', '2024-06-15', 2700000),
('PA00007', 'UA00016', '2024-06-16', 1800000),
('PA00009', 'UA00017', '2024-06-17', 900000),
('PA00007', 'UA00018', '2024-06-18', 1750000),
('PA00006', 'UA00019', '2024-06-19', 3000000),
('PA00001', 'UA00020', '2024-06-20', 14500000),
('PA00002', 'UA00021', '2024-06-21', 7200000),
('PA00008', 'UA00022', '2024-06-22', 3000000),
('PA00009', 'UA00023', '2024-06-23', 1200000),
('PA00010', 'UA00024', '2024-06-24', 8000000),
('PA00002', 'UA00025', '2024-06-25', 1500000);



select * from product;
select * from user;
select * from transaction