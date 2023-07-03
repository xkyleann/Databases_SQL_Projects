-- P3_DataWarehouse -  LAB 3 
-- Main Topic: Datawarehouse project via using OLTP and OLAP 
-- The following files contain a backup of a transactional database system: init.sql, trans.sql.
-- ---------------------------------------------------------------------------------------------------

\o exercise1.txt -- Restore them into your database, using a separate schema is strongly recommended to avoid name clash with existing tables.
-- Create a new schema in  database to avoid any name clashes with existing tables. Assume the schema name is "restored_schema".
CREATE SCHEMA restored_schema;
-- Loading the backup files
\i /path/to/init.sql
\i /path/to/trans.sql
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
\o exercise2.txt -- Design an OLAP star model based on the given OLTP system. Create at least 3 dimensions.
-- 1. Customer Dimension 
-- 2. Product Dimension 
-- 2. Address Dimension 

    +------------+
    |   Orders   |
    +------------+
        |
        |
        v
+-------------+    +------------+      +--------------+
|  Customer   |    |    Product |      |      Address |
+-------------+    +------------+      +--------------+
- CustomerID  <------- ProductID <-----------AddressID
- CustomerPassword     ProductName           AddressName
- CustomerName         ProductDescription    AddressName
- CustomerCity         ProductPrice          AddressCity   
- CustomerZip          ProductAvailablity    AddressZip   
- CustomerAddress                            AddressAd   
- CustomerEmail
- CustomerPhone
- CustomerFax
- CustomerNip
- CustomerRegon


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
\o exercise3.txt -- To implement OLAP as a relational database in a new schema named "olap" and set the search_path variable
CREATE SCHEMA olap;
SET search_path TO olap, public;
--   Customer dimension table
CREATE TABLE olap.customer (
    customer_id VARCHAR PRIMARY KEY, -- Primary key in the olap.customer added
    customer_password varchar(10) NOT NULL,
    customer_name varchar(40) NOT NULL,
    customer_city varchar(40) NOT NULL,
    customer_zip char(6) NOT NULL,
    customer_address varchar(40) NOT NULL,
    customer_email varchar(40),
    customer_phone varchar(16) NOT NULL,
    customer_fax varchar(16),
    customer_nip char(13),
    customer_regon char(9)
);

-- Product dimension table
CREATE TABLE olap.product (
   product_id INT PRIMARY KEY,
   product_name VARCHAR (100),
   product_description VARCHAR (100),
);

-- Addressee dimension table
CREATE TABLE olap.addressee ( -- Profuct available deleted (2)
    addressee_id INT PRIMARY KEY, -- Primary key olap.addressee added
    addressee_name varchar(40) NOT NULL,
    addressee_city varchar(40) NOT NULL,
    addressee_zip char(6) NOT NULL,
    addressee_address varchar(60) NOT NULL
);

-- Orders fact table 
CREATE TABLE olap.orders (
    idorder integer NOT NULL, -- product_price, product_available deleted (3)
    idcustomer integer NOT NULL, -- in the fact table should be numerical (4)
    idaddressee integer NOT NULL,
    idproduct integer NOT NULL,
    order_date integer NOT NULL,
);

-- Time dimension table (5)
CREATE TABLE olap.time_dimension (
    date_id date PRIMARY KEY,
    year integer,
    month integer,
    day integer,
    hour integer,
    minute integer,
    second integer,
);

\o 

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
\o exercise4.txt -- Implement ETL with SQL loading your OLAP model with data from the OLTP tables. Use INSERT INTO ... SELECT.

INSERT INTO olap.customer (customer_id,  customer_password, customer_name, customer_city, customer_zip,customer_address, customer_email, customer_phone,customer_fax, customer_nip, customer_regon)
SELECT customer_id,  customer_password, customer_name, customer_city, customer_zip,customer_address, customer_email, customer_phone,customer_fax, customer_nip, customer_regon
FROM oltp.customer;

INSERT INTO olap.product (product_id, product_name, product_description, product_price, product_available)
SELECT product_id, product_name, product_description, product_price, product_available
FROM oltp.product;


INSERT INTO olap.address (addressee_id , addressee_name, addressee_city, addressee_zip, addressee_address )
SELECT addressee_id , addressee_name, addressee_city, addressee_zip, addressee_address
FROM oltp.address;

-- Load data from sales_oltp table into olap.sales table
INSERT INTO olap.orders (idorder, idcustomer, idaddressee, idproduct, orders_date, price, paid, comments)
SELECT idorder, idcustomer, idaddressee, idproduct, -- (product_price and product available deleted)
FROM oltp.orders;

\o 

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
\o exercise5.txt -- Write an SQL query on the OLAP model which provides aggregated values for each month for a selected year. Pick the value depending on what your fact table looks like. 
SELECT
    ORDER_DATE ('MONTH', o.order_date) AS month,  -- Extract changed as Date
    c.customer_name,
    p.product_name,
    a.addressee_city,
    SUM(o.quantity) AS total_quantity,
    SUM(o.total_price) AS total_price
FROM
    olap.orders o
JOIN
    olap.customer c ON o.idcustomer = c.customer_id
JOIN
    olap.product p ON o.idproduct = p.product_id
JOIN
    olap.addressee a ON o.idaddressee = a.addressee_id
WHERE -- WHERE clause filters the orders by the year 2023
    ORDER_DATE ('YEAR', o.order_date) = 2023 --used instead of EXTRACT to extract the month from the "order_date" column
GROUP BY
    month,
    c.customer_name,
    p.product_name,
    a.addressee_city
ORDER BY
    month;

\o 