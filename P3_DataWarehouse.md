# DATABASES P3
- Project topic is **_Data Warehouse_** 
- Using  PostgreSQL database access method.
- OLTP and OLAP exercises are included.
## Brief for Data Warehouses 



## Brief for OLTP System(s) and OLAP system(s).


## Projects 
- Exercise for Data Warehouse with PostgreSQL. 
- Includes 8 exercises including answers.
- Data import with using files **_init.sql_** and **_trans.sql_**

##### **Task 1: OLTP (Online Transational Processing)**
- (1) Restore sql files (init.sql and trans.sql) into your database, using a separate schema is strongly recommended to avoid name clash with existing tables.
- **_Solution_** for **_Task 1_**, : 
```SQL

```
##### **Task 2: OLAP (Online Analytical Processing) **
- (2) Design an OLAP star model based on the given OLTP system. Create at least 3 dimensions.
- (3) Implement OLAP as a relational database in a new schema, e.g. olap; when working with schemas, remember about setting the search_path variable, e.g.:
```SQL
SET search_path TO olap, public;
```
- (4) Implement ETL with SQL loading your OLAP model with data from the OLTP tables. Use INSERT INTO ... SELECT.
- (5) Write an SQL query on the OLAP model which provides aggregated values for each month for a selected year. Pick the value depending on what your fact table looks like.
- **_Solution_** for **_Task 2_** : 
