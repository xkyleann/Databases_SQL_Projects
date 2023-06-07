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
