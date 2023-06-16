# DATABASES P3
- Project topic is **_Data Warehouse_** 
- Using  PostgreSQL database access method.
- OLTP and OLAP exercises are included.
## Brief for Data Warehouse
- Data warehouses offer the overarching and unique benefit of allowing organizations to analyze large amounts of variant data and extract significant value from it, as well as to keep a historical record.
- Support for SQL, machine learning, graph, and spatial processing
- [Source](https://www.oracle.com/database/what-is-a-data-warehouse/)

## Brief for OLTP System(s) and OLAP system(s).

| OLTP System | OLAP System |
| --- | --- |
|Real-time execution of large numbers of database transactions by large numbers of people | Involve querying many records in a database for analytical purposes|
| Require lightning-fast response times | Require response times that are orders of magnitude slower than those required by _OLTP_|
| Modify small amounts of data frequently and usually involve a balance of reads and writes. |Do not modify data at all; workloads are usually read-intensive|
| Use indexed data to improve response times. | Store data in columnar format to allow easy access to large numbers of records |
| Require frequent or concurrent database backups. | Require far less frequent database backup. |
| Require relatively little storage space. | Typically have significant storage space requirements, because they store large amounts of historical data. |
|Usually run simple queries involving just one or a few records.|Run complex queries involving large numbers of records. |

- [Source](https://www.oracle.com/database/what-is-oltp/)

## Projects 
- Exercise for Data Warehouse with PostgreSQL. 
- Includes 8 exercises including answers.
- Data import with using files **_init.sql_** and **_trans.sql_**

##### **Task 1: OLTP (Online Transational Processing)**
- (1) Restore sql files (init.sql and trans.sql) into your database, using a separate schema is strongly recommended to avoid name clash with existing tables.
```SQL
CREATE SCHEMA restored_schema;
-- Loading the backup files
\i /path/to/init.sql
\i /path/to/trans.sql
```
##### **Task 2: OLAP (Online Analytical Processing) **
- (2) Design an OLAP star model based on the given OLTP system. Create at least 3 dimensions.

```mermaid
    +------------+
    |   Orders   |
    +------------+
        |
        |
        v
+-------------+    +------------+      +--------------+
|  Customer   |    |    Product |      |      Address |
+-------------+    +------------+      +--------------+
  CustomerID  <------- ProductID <-----------AddressID
  CustomerPassword     ProductName           AddressName
  CustomerName         ProductDescription    AddressName
  CustomerCity         ProductPrice          AddressCity   
  CustomerZip          ProductAvailablity    AddressZip   
  CustomerAddress                            AddressAd   
  CustomerEmail
  CustomerPhone
  CustomerFax
  CustomerNip
  CustomerRegon
```

- (3) Implement OLAP as a relational database in a new schema, e.g. olap; when working with schemas, remember about setting the search_path variable, e.g.:

```SQL
CREATE SCHEMA olap;
SET search_path TO olap, public;
--   Customer dimension table
CREATE TABLE olap.customer (
    customer_id varchar(10) NOT NULL,
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
   product_price NUMERIC (7,2),
   product_available INT 
);

-- Addressee dimension table
CREATE TABLE olap.addressee (
    addressee_id integer NOT NULL,
    addressee_name varchar(40) NOT NULL,
    addressee_city varchar(40) NOT NULL,
    addressee_zip char(6) NOT NULL,
    addressee_address varchar(60) NOT NULL
);

-- Orders fact table
CREATE TABLE olap.orders (
    idorder integer NOT NULL,
    idcustomer varchar(10) NOT NULL,
    idaddressee integer NOT NULL,
    idproduct char(5) NOT NULL,
    order_date date NOT NULL,
    price numeric(7,2),
    paid boolean,
    comments varchar(200)
);
```

- (4) Implement ETL with SQL loading your OLAP model with data from the OLTP tables. Use INSERT INTO ... SELECT.
```SQL
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
SELECT idorder, idcustomer, idaddressee, idproduct, orders_date, price, paid, comments
FROM oltp.orders;
```
- (5) Write an SQL query on the OLAP model which provides aggregated values for each month for a selected year. Pick the value depending on what your fact table looks like.
```SQL
SELECT
    EXTRACT(MONTH FROM o.order_date) AS month,
    c.customer_name,  --customer dimension 
    p.product_name, -- product dimension
    a.addressee_city, --addressee dimension
    SUM(o.quantity) AS total_quantity,
    SUM(o.total_price) AS total_price
FROM
    olap.orders o
JOIN
    olap.customer c ON o.customer_id = c.customer_id
JOIN
    olap.product p ON o.product_id = p.product_id
JOIN
    olap.address a ON o.address_id = a.address_id
WHERE
    EXTRACT(YEAR FROM o.order_date) = 2023 -- replace 
GROUP BY
    month,
    c.customer_name,
    p.product_name,
    a.addressee_city
ORDER BY
    month;
```
