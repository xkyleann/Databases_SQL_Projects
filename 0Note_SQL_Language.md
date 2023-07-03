# Note 0 | SQL Language
- Main topic is **_SQL Recap and Introduction to PostegreSQL_** 

## The Relational Data Model
- Model data as a collection of predicates over a finite sat of variables.

## The SQL Language
- _SQL stands for Structured Query Language_. 

1. **_SQL: Creating Relations_**
	- Relations are created using **CREATE TABLE** function 
	```SQL
	CREATE TABLE weather (
		city 		varchar(80),
		temp_lo	int,				-- low temperature
		temp_hi	int,				-- high temperature 
		prcp		real,			-- precipitation 
		date		date
	```

	- To delete a table, use **DROP TABLE**:
	```SQL
	DROP TABLE weather ;
	```

2. **_SQL: Inserting Data_** 
	- Data is inserted using **INSERT**  statement:
	```SQL
	INSERT INTO weather VALUES (‘San Francisco’,46, 50,0.25,’1994-11-27’);
	```

	- If the set or order of columns is different than the table structure, they need to be specified in the query: 
	```SQL
	INSERT INTO weather (city, temp_lo, temp_hi, prcp, date)
		VALUES (‘San Francisco’, 43,57,0.0, ‘1994-11-29’);
	```


3. **_Basic Operations_** 
	- **Selection** and **Projection** are two fundamental operations in SQL. 
	- **Selection** chooses which columns are included in the result set of a **SELECT** query:
	```SQL
	SELECT surname, age FROM employees;
	SELECT * FROM employees;
	```
	- **Projection** chooses which rows are returned by means of the **WHERE** clause:
	```SQL
	SELECT * FROM employees WHERE age > 30 ;


4. **_Aggregate Functions_**
	- **Aggregate Functions** combine a set of values into a single one. They include functions such as **SUM, AVG, MIN, MAX, COUNT** etc.
	```SQL
	SELECT AVG(age) FROM employees;
	```

	- Aggregates may be computed for groups of rows instead of all records; these groups need to be explicit defined.
	```SQL
	SELECT AVG(age), department FROM employees GROUP BY department;
	```

5. **_Filtering in Groups_**
	- The **WHERE** clause always applies to individual records. To perform selection on groups, one uses **HAVING** clause.
	```SQL
	SELECT AVG(age), department FROM employees GROUP BY department
		WHERE age > 30; -- use only people older than 30 for averages
	SELECT AVG(age), department FROM employees GROUP BY department
		HAVING AVG(age) > 30; -- only show septs where average is over 30
	```

6. **_Inner Joins_**
	- _Joins merge_ **two sets of records**, creating a single result set. 
	- _Inner joins_ include only records which match both source sets. 
	```SQL
	SELECT * FROM weather, cities WHERE weather.city = cities.name;
	SELECT * FROM weather INNER JOIN cities IN (weather.city = cities.name);
	SELECT * FROM weather JOIN cities ON (weather.city = cities.name);
	```

7. **_Outer Joins_**
	- _Outer joins_ take all records from left, right or both source sets:
	```SQL
	SELECT * FROM weather LEFT OUTER JOIN cities ON (weather.city = cities.name);
	SELECT * FROM weather LEFT JOIN cities ON (weather.city = cities.name);
	```

8. **_JOIN Syntax_**
	- The most general syntax uses the ON clause with any logical expression:
	```SQL
	SELECT * FROM employees JOIN departments ON
		(employees.dept_id = departments.dept_id);
	```

	- If matching is performed using the equals operator, and matching attributes have the same names in both data sets the USING clause may be employed:
	```SQL
	SELECT * FROM employees JOIN departments USING (dept_id);
	```
	- In addition, if all attributes with identical names are to be matched, we have a natural join: 
	```SQL
	SELECT * FROM employees NATURAL JOIN department;
	```

9. **_Set Operations_** 
	- Query results may be combined using the following operators: 
	    - UNION: appends results of second query to those of the first one,
	    - INTERSECT: return all rows that are in both sets,
	    - EXCEPT: remove rows in the second result set from the first one. 
	- All operators remove duplicates unless used with the ALL modifier. 


10. **_Subqueries_**
	- SQL queries may contain subqueries in various places - pay attention attributes and rows expected. Subqueries are often used with the set operators:
	    - EXISTS: returns true if subquery has at least one row, 
	    - IN/NOT IN: checks if value belongs/doesn’t belong to set returned by subquery,
	    - ANY/SOME/ALL: similar to the above, but use arbitrary operators (instead of = and <>)


## Designing Databases 

1. **_Good practices for Database Design_**
	- Every real-world object = one entity = one relation.
	- Every attribute occurs once, with its own object.
	- Decompose non-atomic attributes.
	- 1:n relationships: take primary key of “1”, migrate to “n” relation as foreign key. 
	- m:n relationships: create associative entity, use sum of primary keys from “m” and “n” as primary key. 

2. **_Implemanting “Inheritance”_**
	- The notion of subclassing is difficult to implement in a relational database, and leads to trade-offs.
	- Possible approaches:
	    - one table for superclass (and common attributes), one table for each subclass. 
		- one table for each subclass; common attributes replicated in each one. Must  	   use **UNION** to obtain a set on superclass level. 
		- one table for all; each row contains attributes of all subclasses (and those of 	   the superclass). This leads to many NULLs. 


#PostgreSQL 
1. **_PostgreSQL Basics_**
	- PostgreSQL is a __relational database management system__ 
	- _Cross-platform & open-source_
	- Client-server architecture:
	    - server listens on 5432/tcp by default
	    - clients use **libpq** to connect 


2. **_PostgreSQL Schema_**
	- Creating a schema: 
	```SQL
	CREATE SCHEMA my_othe_schema;
	```
	- Objects in schemas can be referred to by schema.object.
	- Otherwise, the DB looks in schemas listed in search_path, which act much like the PATH system environment variable. 

	- To set search_path:
	```SQL
	SET search_path TO public, my_other_schema;
	SET search_path TO my_other_schema, public;
	SET search_path TO my_other_schema;
	```

3. **_PostgreSQL Clients_**
	- Collection of __command-line utilities, including **psql** and several helper programs. 
	- Any application can use **libpq**, usually via some wrapper.
	- GUI apps: phppgadmin, Adminer, pgAdmin

4. **_Using psql Command-line Switches_**
	- psql [option...] [dbname [username]]
	- Useful switches: 
	    - **-d dbname** –> specify database name 
	    - **-h hostname** –> Specify host to connect to; if omitted, it will connect to local UNIX domain socket specified in the config 
	    - **-U username** –> specify username 
	    - **-l** – list databases 
	    - **-c command** –> run specified command and exit 
	    - **-f filename** –> run commands from file and exit

5. **_Using psql: Interactive Shell**_
	- Some useful meta-commands: 
	    - **\l** –> list databases 
	    - **\d** –> list objects 
	    - **\dE, \di, \dm, \ds, \dt, \dv** –> list objects of specific type: foreign table, index, materialized view, sequence, table, and view 
	    - **\i** –> read commands from file
	    - **\q** –> quit 


<details>
<summary>Documentation</summary>
<a href= "https://github.com/Kyleann/AGH_Databeses_2/files/11012274/01-recap-sql-postgres-latest.pdf"> Documentation 1 </a>
</details>

