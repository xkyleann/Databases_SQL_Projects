### There is a graph representing information about **furniture** in a **Neo4J** database that has:
- 2 nodes labeled LEG that are connected with edges **(labelled ATTACHED)** with 1 node labeled **TABLETOP**.
- Write a Cypher language query that **matches the above** and **removes an edge** between the **TABLETOP** and the **first LEG**.
### **Solution**
```SQL 
MATCH(leg:LEG)-[r:ATTACHED]->(tabletop:TABLETOP) 
WITH leg, r , tabletop
ORDER BY id(leg)  -- Order by the internal Neop4j
LIMIT 1
DELETE r
```
---
### There is a graph representing information about **furniture** in a **Neo4J** database that has:
- 2 nodes labeled LEG that are connected with edges **(labelled ATTACHED)** with 1 node labeled **TABLETOP**.
- Write a Cypher language query that matches the **above adds** attribute **"color"** to each of the nodes **labelled with LEG** with a value of **"white"** for the first node, **"red"** for the second.
### **Solution**
```SQL 
MATCH(leg:LEG)-[ATTACHED]->(tabletop:TABLETOP)  -- find LEG connected TABLETOP node with ATTACHED relationship.
WITH leg ORDER BY id(leg) LIMIT 2  -- LEG nodes by their internal ID and limits result first two nodes.
WITH collect(leg) AS legs    -- collect two nodes into a list called "legs"
SET (legs[0]).color = "white",  (legs[1]).color = "red"  -- sets "color" attribute to "white for the first node and "red" second
```

---
### There is a graph representing information about **furniture** in a **Neo4J** database that has:
- 2 nodes labeled LEG that are connected with edges **(labelled ATTACHED)** with 1 node labeled **TABLETOP**.,
- Write a Cypher language query that matches the **above** and for each of **nodes called LEG** adds an **edge labelled EXTRA** and a node labelled **PAD** connected with it.
### **Solution**
```SQL 
MATCH(leg:LEG)-[:ATTACHED]->[tabletop:TABLETOP]
WITH leg
CREATE (pad:PAD)
CREATE (leg:LEG)-[:EXTRA]->(pad)
```
---
### Star datawarehouse for a telecommunication company that provides secure data connections between their customers.
- A single fact regards a connection contract from one customer to another with its **price**, and **duration**, hence there are the following dimensions: from (city name, zip code), to (city name, zip code), time (time and date).
- Write an SQL query that **creates** the above **warehouse schema** in a **relational database**, including **attributes**, **datatypes** and **keys**.
- Write an SQL query that calculates a **sum of prices** for **each month in 2020** for 30-059 zip code (for the outgoing connection).
### **Solution**
```SQL 
CREATE TABLE from (
from_id serial PRIMARY KEY,
city_name varchar(50),
zip_code varchar(10)
);

CREATE TABLE to (
to_id serial PRIMARY KEY,
city_name varchar(50),
zip_code varchar(10)
);

CREATE TABLE time (
time_id serial PRIMARY KEY,
connection_time timestamp
);

CREATE TABLE fact (
connection_id serial PRIMARY KEY,
from_id int REFERENCES from(from_id),
to_id int REFERENCES to(to_id),
time_id int REFERENCES time(time_id),
price numeric(10,2),
duration interval
);

SELECT
date_trunc('day', time.connection_time) AS connection_date,
SUM(fact.price) AS total_price
FROM
from
JOIN fact ON from.from_id = fact.from_id
JOIN time ON fact.time_id = time.time_id
WHERE
from.zip_code = '30-059' AND
date_trunc('year', time.connection_time) = '2022-01-01'::date
GROUP BY
connection_date
ORDER BY
connection_date;
```

---

### A PostgreSQL database table has been created usıng the following code: 
```SQL 
CREATE TABLE cities (ide serial, name character varying(30));
```
- Then some records were added. In order to make the querıes faster, an index was defined:
```SQL 
CREATE INDEX cities_name_idx ON cities (name);
SET enable_seqscan TO off;
```
- However after running "EXPLAIN" with following query:
```SQL 
SELECT * FROM cities WHERE name ILIKE "Lond%"
```
- It turned out that the index is not used - the database performs a sequential scan instead. Try to identify the problem. Explain why it occured.
- Try to fix the problem and obtain a scenerio where an index scan is performed, without changing the data structure of the table or the purpose of the query itself.
### **Solution**
- The problem is using double quotes (") instead of single quotes (') around the pattern in the ILIKE query. PostgreSQL interprets "Lond%" as an identifier, not a string literal with wildcards. Correct it to ILIKE 'Lond%' to enable PostgreSQL to use the cities_name_idx index efficiently for the query.


---


### A PostgreSQL database table has been created usıng the followıng code: 
```SQL 
CREATE TABLE cities (ide serial, name character varying(30));
```
- Then some records were added. In order to make the querıes faster, an index was defined:
```SQL 
CREATE INDEX cities_name_idx ON cities (name);
SET enable_seqscan TO off;
```
- However after running "EXPLAIN" with following query:
```SQL 
SELECT * FROM cities WHERE name LIKE "%burg"
```
- It turned out that the index is not used - the database performs a sequential scan instead.
- Try to identify the problem. Explain why it occured.
- Try to fix the problem and obtain a scenerio where an index scan is performed, without changing the data structure of the table or the purpose of the query itself.

### **Solution**
- The index **cities_name_idx** is npt used for **SELECT * FROM cities WHERE name LIKE "%burg"** because PostgreSQL cannot efficiently use indexes with a wildcard (%) at the beginning of a **LIKE** pattern due to how B-tree indexes are structured.
- To ensure index usage, modify query to
```SQL 
  SELECT * FROM cities WHERE name LIKE "burg%"
```
---


### The following PostgreSQL/PostGIS table was created:
```SQL 
CREATE TABLE cities (
  id serial PRIMARY KEY,
  name character varying(50),
  location geometry
);

-- Two records were added

INSERT INTO cities (name,location)
VALUES
  ("Krakow",ST_GeomFromText(POINT (),4326)),
  ("Warsaw",ST_GeomFromText(POINT (),4326)),

-- Then, the distance between cities was computed using:
SELECT
  ST_Distance(
    (SELECT location FROM cities WHERE name = "Krakow"),
    (SELECT location FROM cities WHERE name = "Warsaw") ) /1000 AS distance_km;
    
```
- However, it turned out that the result is nowhere near the expected value of 250km
- Fix the query without using reprojection to other reference systems and keeping ST_Distance function, so that the result is lose to the expected one.
