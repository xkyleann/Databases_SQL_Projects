
- Project topic is **_Neo4J_** 
- There is a map of the AGH Campus. Create cypher codes, and make queries.
  
## Tasks 
### **Task 1: Create a graph using Cypher and load it into Neo4J** 
**Task 1.1:** Create buildings: S-1, S-2, D-1, U-2, A-4, A-3, C-4, C-3, C-2, U-1, H-A2, H-A1, A-2, A-1, C-1,A-0, B-1, B-2, B-3, B-4, H-B3B4, H-B1B2; use nodes and property "name"
  
```Cypher
CREATE (:Building {name: 'S-1'})
CREATE (:Building {name: 'S-2'})
CREATE (:Building {name: 'D-1'})
CREATE (:Building {name: 'U-2'})
CREATE (:Building {name: 'A-4'})
CREATE (:Building {name: 'A-3'})
CREATE (:Building {name: 'C-4'})
CREATE (:Building {name: 'C-3'})
CREATE (:Building {name: 'C-2'})
CREATE (:Building {name: 'U-1'})
CREATE (:Building {name: 'H-A2'})
CREATE (:Building {name: 'H-A1'})
CREATE (:Building {name: 'A-2'})
CREATE (:Building {name: 'A-1'})
CREATE (:Building {name: 'C-1'})
CREATE (:Building {name: 'A-0'})
CREATE (:Building {name: 'B-1'})
CREATE (:Building {name: 'B-2'})
CREATE (:Building {name: 'B-3'})
CREATE (:Building {name: 'B-4'})
CREATE (:Building {name: 'H-B3B4'})
CREATE (:Building {name: 'H-B1B2'})
```

**Building and their Functions**

```Cypher
CREATE (s1:Building {name: 'S-1'})-[:HAS_FUNCTION]->(:Function {type: 'SERVICE'})
CREATE (s2:Building {name: 'S-2'})-[:HAS_FUNCTION]->(:Function {type: 'SERVICE'})
CREATE (d1:Building {name: 'D-1'})-[:HAS_FUNCTION]->(:Function {type: 'RESEARCH'})
CREATE (u2:Building {name: 'U-2'})-[:HAS_FUNCTION]->(:Function {type: 'RESEARCH'})
CREATE (a4:Building {name: 'A-4'})-[:HAS_FUNCTION]->(:Function {type: 'RESEARCH'})
CREATE (a3:Building {name: 'A-3'})-[:HAS_FUNCTION]->(:Function {type: 'TEACHING'})
CREATE (c4:Building {name: 'C-4'})-[:HAS_FUNCTION]->(:Function {type: 'TEACHING'})
CREATE (c3:Building {name: 'C-3'})-[:HAS_FUNCTION]->(:Function {type: 'TEACHING'})
CREATE (c2:Building {name: 'C-2'})-[:HAS_FUNCTION]->(:Function {type: 'TEACHING'})
CREATE (u1:Building {name: 'U-1'})-[:HAS_FUNCTION]->(:Function {type: 'RESEARCH'})
CREATE (ha2:Building {name: 'H-A2'})-[:HAS_FUNCTION]->(:Function {type: 'SERVICE'})
CREATE (ha1:Building {name: 'H-A1'})-[:HAS_FUNCTION]->(:Function {type: 'SERVICE'})
CREATE (a2:Building {name: 'A-2'})-[:HAS_FUNCTION]->(:Function {type: 'RESEARCH'})
CREATE (a1:Building {name: 'A-1'})-[:HAS_FUNCTION]->(:Function {type: 'RESEARCH'})
CREATE (c1:Building {name: 'C-1'})-[:HAS_FUNCTION]->(:Function {type: 'RESEARCH'})
CREATE (a0:Building {name: 'A-0'})-[:HAS_FUNCTION]->(:Function {type: 'SERVICE'})
CREATE (b1:Building {name: 'B-1'})-[:HAS_FUNCTION]->(:Function {type: 'SERVICE'})
CREATE (b2:Building {name: 'B-2'})-[:HAS_FUNCTION]->(:Function {type: 'RESEARCH'})
CREATE (b3:Building {name: 'B-3'})-[:HAS_FUNCTION]->(:Function {type: 'RESEARCH'})
CREATE (b4:Building {name: 'B-4'})-[:HAS_FUNCTION]->(:Function {type: 'RESEARCH'})
CREATE (hb3b4:Building {name: 'H-B3B4'})-[:HAS_FUNCTION]->(:Function {type: 'SERVICE'})
CREATE (hb1b2:Building {name: 'H-B1B2'})-[:HAS_FUNCTION]->(:Function {type: 'SERVICE'})
```

**Faculty Headquarters**

```Cypher
CREATE (hq1:HQ {name: 'Faculty of Mining'})-[:LOCATED_IN]->(s1)
CREATE (hq2:HQ {name: 'Faculty of Electrical Engineering'})-[:LOCATED_IN]->(s2)
CREATE (hq3:HQ {name: 'Faculty of Mechanical Engineering'})-[:LOCATED_IN]->(d1)
```

**Classrooms**

```Cypher
CREATE (class1:Classroom {name: '101'})-[:LOCATED_IN]->(a1)
CREATE (class2:Classroom {name: '102'})-[:LOCATED_IN]->(a1)
CREATE (class3:Classroom {name: '201'})-[:LOCATED_IN]->(c3)
CREATE (class4:Classroom {name: '202'})-[:LOCATED_IN]->(c4)
```


**Entrances**

```Cypher
CREATE (e1:Entrance {name: 'Entrance1'})-[:LOCATED_IN]->(a0)
CREATE (e2:Entrance {name: 'Entrance2'})-[:LOCATED_IN]->(a1)
CREATE (e3:Entrance {name: 'Entrance3'})-[:LOCATED_IN]->(c1)
CREATE (e4:Entrance {name: 'Entrance4'})-[:LOCATED_IN]->(c2)
```

Added 22 labels, created 22 nodes, set 22 properties, completed after 35 ms.

---

**Task 1.2:** Create building functions: service facilities, research and teaching facilities; use labels: "SERVICE", "RESEARCH", "TEACHING",

```Cypher 
MATCH (b:Building)
WHERE b.name IN ['S-1', 'S-2', 'D-1', 'U-2']
SET b:SERVICE
WITH b

MATCH (b:Building)
WHERE b.name IN ['A-4', 'A-3', 'C-4', 'C-3', 'C-2', 'U-1', 'H-A2', 'H-A1', 'A-2', 'A-1', 'C-1']
SET b:RESEARCH
WITH b

MATCH (b:Building)
WHERE b.name IN ['A-0', 'B-1', 'B-2', 'B-3', 'B-4', 'H-B3B4', 'H-B1B2']
SET b:TEACHING
```
Added 4 labels, completed after 100 ms.

**Task 1.3:** Create buildings' **adjacency**: e.g. C-3 is adjacent to C-2 and there is a foot path connecting them on each floor; mind that not all floors are connected e.g.  C-1 and A-1 is connected via 1st floor only, if you are not sure which buildings are connected at which floors make it up :); use and edge with property "floor" (value of 0 represents a ground floor)

```Cypher
// Creating adjacency relationships between buildings
// Adjacent will specify the floor on which connection exists.
CREATE (c3)-[:ADJACENT {floor: 0}]->(c2)
CREATE (c3)-[:ADJACENT {floor: 1}]->(c2)
CREATE (c1)-[:ADJACENT {floor: 1}]->(a1)
CREATE (a1)-[:ADJACENT {floor: 0}]->(a2)
CREATE (a2)-[:ADJACENT {floor: 1}]->(a3)
CREATE (a3)-[:ADJACENT {floor: 0}]->(a4)
CREATE (b1)-[:ADJACENT {floor: 0}]->(b2)
CREATE (b2)-[:ADJACENT {floor: 1}]->(b3)
CREATE (b3)-[:ADJACENT {floor: 0}]->(b4)
CREATE (u1)-[:ADJACENT {floor: 0}]->(u2)
CREATE (ha1)-[:ADJACENT {floor: 0}]->(ha2)
CREATE (hb1b2)-[:ADJACENT {floor: 0}]->(hb3b4)

// Entrance connections
CREATE (e1)-[:CONNECTED_TO]->(e2)
CREATE (e2)-[:CONNECTED_TO]->(e3)
CREATE (e3)-[:CONNECTED_TO]->(e4)
```
Set 1 property, created 1 relationship, completed after 46 ms.

**Task 1.4:** Create faculty **head quarter** locations (labeled with numbers on the map); each faculty headquarter should be represented as a node with "HQ" label,
```Cypher
CREATE (:HQ {name: 'HQ-1'})
CREATE (:HQ {name: 'HQ-2'})
CREATE (:HQ {name: 'HQ-3'})
```
Added 3 labels, created 3 nodes, set 3 properties, completed after 60 ms.

**Task 1.5:** Create classrooms you have had classes in; their numbers and relationships with the buildings; represent each of them as a node with "CLASSROOM" label,
```Cypher
CREATE (:CLASSROOM {number: 'C1'})-[:LOCATED_IN]->(:Building {name: 'C-1'})
CREATE (:CLASSROOM {number: 'C2'})-[:LOCATED_IN]->(:Building {name: 'C-2'})
CREATE (:CLASSROOM {number: 'C3'})-[:LOCATED_IN]->(:Building {name: 'C-3'})
```
Added 6 labels, created 6 nodes, set 6 properties, created 3 relationships, completed after 70 ms.

**Task 1.6:** Create classrooms you have had classes in; their numbers and relationships with the buildings; represent each of them as a node with "CLASSROOM" label,
```Cypher
// Building entrance nodes (random)
CREATE (:ENTRANCE {name: 'Entrance S-1'})
CREATE (:ENTRANCE {name: 'Entrance S-2'})
CREATE (:ENTRANCE {name: 'Entrance D-1'})
CREATE (:ENTRANCE {name: 'Entrance U-2'})
CREATE (:ENTRANCE {name: 'Entrance A-4'})
CREATE (:ENTRANCE {name: 'Entrance A-3'})
CREATE (:ENTRANCE {name: 'Entrance C-4'})
CREATE (:ENTRANCE {name: 'Entrance C-3'})
CREATE (:ENTRANCE {name: 'Entrance C-2'})
CREATE (:ENTRANCE {name: 'Entrance U-1'})
CREATE (:ENTRANCE {name: 'Entrance H-A2'})
CREATE (:ENTRANCE {name: 'Entrance H-A1'})
CREATE (:ENTRANCE {name: 'Entrance A-2'})
CREATE (:ENTRANCE {name: 'Entrance A-1'})
CREATE (:ENTRANCE {name: 'Entrance C-1'})
CREATE (:ENTRANCE {name: 'Entrance A-0'})
CREATE (:ENTRANCE {name: 'Entrance B-1'})
CREATE (:ENTRANCE {name: 'Entrance B-2'})
CREATE (:ENTRANCE {name: 'Entrance B-3'})
CREATE (:ENTRANCE {name: 'Entrance B-4'})
CREATE (:ENTRANCE {name: 'Entrance H-B3B4'})
CREATE (:ENTRANCE {name: 'Entrance H-B1B2'})
```
Added 22 labels, created 22 nodes, set 22 properties, completed after 38 ms.


```Cypher
// Footpath relationships between entrances
MATCH (e1:ENTRANCE), (e2:ENTRANCE)
WHERE e1 <> e2
CREATE (e1)-[:CONNECTED]->(e2)
```
Created 756 relationships, completed after 60 ms.

---

### **Task 2: Analytics, run the following queries:** 
**Task 2.1:** Are there any buildings that are **not connected** directly (not through an entrance) to other buildings?

```Cypher
MATCH (b:Building) // find all nodes labeled "Building"
WHERE NOT (b)-[:ADJACENT]->() // to filter buildings that do not have any relationship
RETURN b.name // retutn name of building (as output)
```
Output --> S-1"
"S-2"
"D-1"
"U-2"
"A-4"
"A-3"
"C-4"
"C-3"
"C-2"

**Task 2.2:** How many service facilities there are?
```Cypher
MATCH (b:Building)-[:HAS_FUNCTION]->(f:Function {type: 'SERVICE'}) // finds Service type in Buildings 
RETURN count(b) AS service_facilities_count // output for 
```
Started streaming 1 records after 8 ms and completed after 9 ms.
Output --> 4

**Task 2.3:** What buildings A-1 is connected with?
```Cypher
MATCH (a1:Building {name: 'A-1'})-[:ADJACENT]-(adj:Building)
RETURN adj.name, collect(properties(a1)-[:ADJACENT]->(adj)) AS floors_connected //names of these adjacent buildings and collects the properties of the ADJACENT relationships,
```
Output --> Data Model

**Task 2.4:** What buildings A-1 is connected with and at which floors?
- Connected changed to ADJACENT_TO
```Cypher
MATCH (a1:Building {name: 'A-1'})-[:ADJACENT_TO]-(connectedBuilding)
RETURN connectedBuilding.name AS connectedBuilding, connectedBuilding.floor AS floor
```

**Task 2.5:** How to get from the Candidates Application Centre to the Faculty of Mechanical Engineering and Robotics without leaving the buildings (not going through an entrance)?
```Cypher
MATCH path = (c:CLASSROOM {number: 'C1'})-[:LOCATED_IN|ADJACENT_TO*]-(f:TEACHING {name: 'Faculty of Mechanical Engineering and Robotics'})
WHERE ALL(node IN nodes(path)[1..-1] WHERE node:TEACHING OR node:RESEARCH OR node:SERVICE)  // filter ensures that all nodes in the path, except the starting and ending nodes, are labeled as TEACHING, RESEARCH, or SERVICE, thus preventing the path from including any entrances.
RETURN path
```

**Task 2.6:** What is a shortest path (minimal number of buildings to go through) from the C-3 ground floor to the A-0 entrance?
```Cypher
MATCH (b1:Building)-[:ADJACENT*1..2]-(b2:Building)  // This query matches buildings connected within 1 to 2 hops through the ADJACENT relationship.
WITH b1, count(DISTINCT b2) AS connected_buildings // aggregates the number of distinct buildings each b1 building is connected to within the specified hop range.
WHERE connected_buildings >= 3   // at least three other buildings.
RETURN b1.name
```

```Cypher
// Solution with Dijkstra
MATCH (start:Building {name: 'C-3'}), (end:Entrance {name: 'A-0'})
CALL apoc.algo.dijkstra(start, end, 'ADJACENT|CONNECTED_TO', 'weight') YIELD path, weight
RETURN path, weight
```

//This specifies a **variable-length pattern** that **matches** paths with a **minimum of 1 and a maximum of 2** relationships. This can be used to find nodes that are within 1 or 2 hops from a given node.
