### 1. Create all necessary nodes and edges for a car named Ford and year 2023, with wheel diameter being 16 and engine size being 2.

```cypher
CREATE (c:CAR {name: 'Ford', year: 2023})
CREATE (e:ENGINE {size: 2})
CREATE (w1:WHEEL {diameter: 16}),
       (w2:WHEEL {diameter: 16}),
       (w3:WHEEL {diameter: 16}),
       (w4:WHEEL {diameter: 16})
CREATE (c)-[:HAS_ENGINE]->(e)
CREATE (c)-[:HAS_WHEEL]->(w1),
       (c)-[:HAS_WHEEL]->(w2),
       (c)-[:HAS_WHEEL]->(w3),
       (c)-[:HAS_WHEEL]->(w4);
```

**Explanation:**
- **CAR Node:** A `CAR` node is created with properties `name` and `year`.
- **ENGINE Node:** An `ENGINE` node is created with the property `size`.
- **WHEEL Nodes:** Four `WHEEL` nodes are created, each with the property `diameter`.
- **Relationships:** Relationships are created between the `CAR` node and the `ENGINE` node, and between the `CAR` node and each `WHEEL` node.

### 2. Change the wheel size of all cars named Ferrari to 20.

```cypher
MATCH (c:CAR {name: 'Ferrari'})-[:HAS_WHEEL]->(w:WHEEL)
SET w.diameter = 20;
```

**Explanation:**
- **Match:** The query matches `CAR` nodes with the name `Ferrari` and their related `WHEEL` nodes.
- **Set:** The diameter of all related `WHEEL` nodes is updated to 20.

### 3. Remove all nodes labelled ENGINE.

```cypher
MATCH (e:ENGINE)
DETACH DELETE e;
```

**Explanation:**
- **Match:** This matches all nodes labelled `ENGINE`.
- **Detach Delete:** This deletes the `ENGINE` nodes and automatically removes any relationships they are involved in.

### Full Example

Here's a full example with these queries combined, assuming the database is initially empty:

```cypher
// 1. Create a car named Ford
CREATE (c:CAR {name: 'Ford', year: 2023})
CREATE (e:ENGINE {size: 2})
CREATE (w1:WHEEL {diameter: 16}),
       (w2:WHEEL {diameter: 16}),
       (w3:WHEEL {diameter: 16}),
       (w4:WHEEL {diameter: 16})
CREATE (c)-[:HAS_ENGINE]->(e)
CREATE (c)-[:HAS_WHEEL]->(w1),
       (c)-[:HAS_WHEEL]->(w2),
       (c)-[:HAS_WHEEL]->(w3),
       (c)-[:HAS_WHEEL]->(w4);

// 2. Change wheel size of all Ferraris
MATCH (c:CAR {name: 'Ferrari'})-[:HAS_WHEEL]->(w:WHEEL)
SET w.diameter = 20;

// 3. Remove all ENGINE nodes
MATCH (e:ENGINE)
DETACH DELETE e;
```

This approach maintains clarity and avoids errors by performing each task step by step. Adjust the names and properties as needed to fit your specific database schema and requirements.
--- 

- 3:
- 4:

---

### 1. There is a graph representing information about **furniture** in a **Neo4J** database that has:
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
### 2. There is a graph representing information about **furniture** in a **Neo4J** database that has:
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
### 3. There is a graph representing information about **furniture** in a **Neo4J** database that has:
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
### 4. Star datawarehouse for a telecommunication company that provides secure data connections between their customers.
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

### 5. A PostgreSQL database table has been created usıng the following code: 
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


### 6. A PostgreSQL database table has been created usıng the followıng code: 
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
SELECT * FROM cities WHERE name LIKE '%burg';
```
- It turned out that the index is not used - the database performs a sequential scan instead.
- Try to identify the problem. Explain why it occured.
- Try to fix the problem and obtain a scenerio where an index scan is performed, without changing the data structure of the table or the purpose of the query itself.

### **Solution**
- The problem that the index not being used is because the query uses a wildcard at the beginning of the pattern in the LIKE clause.
- PostgreSQL cannot use an index for patterns starting with a wildcard.
- To fix this issue, we can use the `pg_trgm` extension to create a trigram index, which can be used for wildcard searches :

```SQL 
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX cities_name_trgm_idx ON cities USING gin(name gin_trgm_ops);
```

- After running the **EXPLAIN** command, we should see the index is being used :

```SQL 
EXPLAIN SELECT * FROM cities WHERE name LIKE '%burg';
```

---

### 7. The following PostgreSQL/PostGIS table was created:
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
### **Solution**
To fix the distance calculation query, we will need to transform the geometries to a different spatial reference system that uses meters as
the unit of measurement.
We can use the 'ST_Transform' function to achieve this:

```SQL 
SELECT
ST_Distance(
ST_Transform((SELECT location FRO
M cities WHERE name = 'Krakow'), 3857),
ST_Transform((SELECT location FRO
M cities WHERE name = 'Warsaw'), 3857)
) / 1000 AS distance_km;
```

- This query will give a result close to the expected distance of approximately 250 km.

---

### 8. The following PostgreSQL/PostGIS table was created:
- Write down a Cypher query (or queries) that create a family tree consisting of at least 3 generations.
- You must include information who is a boy, girl, father, mother.
- Consider at least 3 families with children.
- Write down a Cypher query that finds grandfathers.
- Write down a Cypher query that finds grandfathers.
```SQL
// Create nodes for the first family
CREATE (john:Person {name: 'John', gender: 'male'})
CREATE (mary:Person {name: 'Mary', gender: 'female'})
CREATE (paul:Person {name: 'Paul', gender: 'male'})
CREATE (susan:Person {name: 'Susan', gender: 'female'})
CREATE (david:Person {name: 'David', gender: 'male'})
CREATE (lisa:Person {name: 'Lisa', gender: 'female'})

// Create relationships for the first family
CREATE (john)-[:FATHER]->(paul)
CREATE (john)-[:FATHER]->(susan)
CREATE (mary)-[:MOTHER]->(paul)
CREATE (mary)-[:MOTHER]->(susan)
CREATE (paul)-[:FATHER]->(david)
CREATE (paul)-[:FATHER]->(lisa)

// Create nodes for the second family
CREATE (michael:Person {name: 'Michael', gender: 'male'})
CREATE (sarah:Person {name: 'Sarah', gender: 'female'})
CREATE (kevin:Person {name: 'Kevin', gender: 'male'})
CREATE (amy:Person {name: 'Amy', gender: 'female'})
CREATE (robert:Person {name: 'Robert', gender: 'male'})
CREATE (emily:Person {name: 'Emily', gender: 'female'})

// Create relationships for the second family
CREATE (michael)-[:FATHER]->(kevin)
CREATE (michael)-[:FATHER]->(amy)
CREATE (sarah)-[:MOTHER]->(kevin)
CREATE (sarah)-[:MOTHER]->(amy)
CREATE (kevin)-[:FATHER]->(robert)
CREATE (kevin)-[:FATHER]->(emily)

// Create nodes for the third family
CREATE (william:Person {name: 'William', gender: 'male'})
CREATE (jessica:Person {name: 'Jessica', gender: 'female'})
CREATE (chris:Person {name: 'Chris', gender: 'male'})
CREATE (emma:Person {name: 'Emma', gender: 'female'})
CREATE (mark:Person {name: 'Mark', gender: 'male'})
CREATE (sophie:Person {name: 'Sophie', gender: 'female'})

// Create relationships for the third family
CREATE (william)-[:FATHER]->(chris)
CREATE (william)-[:FATHER]->(emma)
CREATE (jessica)-[:MOTHER]->(chris)
CREATE (jessica)-[:MOTHER]->(emma)
CREATE (chris)-[:FATHER]->(mark)
CREATE (chris)-[:FATHER]->(sophie)

MATCH (grandfather:Person)-[:FATHER]->(parent:Person)-[:FATHER|MOTHER]->(grandchild:Person)
RETURN DISTINCT grandfather.name AS Grandfather
```
---


### 9. Correct all mistakes in the following datawarehouse star schema by rewriting the DDL queries.
- Assume that there should be 2 dimensions.
- Correct all mistakes in the following datawarehouse star schema by rewriting the DDL queries.

```SQL 
CREATE TABLE fact (
idfact integer PRIMARY KEY,
employee_id integer REFERENCES employee,
amount numeric(10,2),
);
CREATE TABLE employee (
employee_id varchar(30),
name varchar(30) PRIMARY KEY,
);
```
- Write an SQL query that delivers a total amount for each month of each year.
---


## All Possible Questions with Answers 
<img width="623" alt="Ekran Resmi 2024-06-16 01 12 23" src="https://github.com/xkyleann/Databases_SQL_Projects/assets/128597547/29e9c6cd-7f7e-4683-8691-f29b9a19b278">
---
<img width="8
  31" alt="Ekran Resmi 2024-06-16 01 16 15" src="https://github.com/xkyleann/Databases_SQL_Projects/assets/128597547/78a67b87-3cbd-4a9e-97c0-82af614e0c1e">
---

<img width="606" alt="Ekran Resmi 2024-06-16 01 16 53" src="https://github.com/xkyleann/Databases_SQL_Projects/assets/128597547/1e20d059-a397-431f-adfe-fa7e99853846">

---
<img width="632" alt="Ekran Resmi 2024-06-16 01 12 45" src="https://github.com/xkyleann/Databases_SQL_Projects/assets/128597547/9b97bb6e-8708-45d0-86d5-2fd9282c53e0">
---
<img width="585" alt="Ekran Resmi 2024-06-16 01 13 01" src="https://github.com/xkyleann/Databases_SQL_Projects/assets/128597547/36f26d34-1481-416d-bdeb-ef15fcfdecf1">

---
  
<img width="627" alt="Ekran Resmi 2024-06-16 01 15 01" src="https://github.com/xkyleann/Databases_SQL_Projects/assets/128597547/da6ff3b6-6644-4335-9936-434862bc32e4">

---
<img width="887" alt="Ekran Resmi 2024-06-16 01 17 53" src="https://github.com/xkyleann/Databases_SQL_Projects/assets/128597547/a58bd531-320a-4481-9464-e8b010267597">

--- 
### Final 

<img width="599" alt="Screenshot 2024-06-20 at 10 32 29" src="https://github.com/xkyleann/Databases_SQL_Projects/assets/128597547/3a1c0431-6914-4061-a4f3-f75156054311">

---
<img width="582" alt="Screenshot 2024-06-20 at 10 32 47" src="https://github.com/xkyleann/Databases_SQL_Projects/assets/128597547/822e437f-c186-48e5-bc2e-47fe710e5318">

<img width="847" alt="points1-1" src="https://github.com/xkyleann/Databases_SQL_Projects/assets/128597547/b83bf238-b2af-441d-a0b1-ab719ca2b958">

<img width="844" alt="points2" src="https://github.com/xkyleann/Databases_SQL_Projects/assets/128597547/a4742838-5441-4494-85e7-cd52df0ad4c3">

---
<img width="591" alt="Screenshot 2024-06-20 at 10 33 26" src="https://github.com/xkyleann/Databases_SQL_Projects/assets/128597547/3b1502c9-e3d3-4a46-8df7-baac07da3204">

---
<img width="596" alt="Screenshot 2024-06-20 at 10 33 46" src="https://github.com/xkyleann/Databases_SQL_Projects/assets/128597547/7d962cd0-24c5-4f2d-847b-e69216a0a6b7">

<img width="617" alt="Screenshot 2024-06-20 at 10 33 53" src="https://github.com/xkyleann/Databases_SQL_Projects/assets/128597547/9bafc1c5-868f-479c-b0c6-d4b1e3cf3a0b">


