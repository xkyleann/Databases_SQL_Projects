
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
Added 22 labels, created 22 nodes, set 22 properties, completed after 35 ms.

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

**Task 1.3:** Create buildings' adjacency: e.g. C-3 is adjacent to C-2 and there is a foot path connecting them on each floor; mind that not all floors are connected e.g.  C-1 and A-1 is connected via 1st floor only, if you are not sure which buildings are connected at which floors make it up :); use and edge with property "floor" (value of 0 represents a ground floor)

```Cypher
// Creating adjacency relationships between buildings
MATCH (b1:BUILDING {name: 'C-3'}), (b2:BUILDING {name: 'C-2'})
CREATE (b1)-[:ADJACENT_TO {floor: 0}]->(b2)
WITH b2

MATCH (b1:BUILDING {name: 'C-2'}), (b2:BUILDING {name: 'C-1'})
CREATE (b1)-[:ADJACENT_TO {floor: 1}]->(b2)
WITH b2

MATCH (b1:BUILDING {name: 'C-1'}), (b2:BUILDING {name: 'A-1'})
CREATE (b1)-[:ADJACENT_TO {floor: 1}]->(b2)
WITH b2

MATCH (b1:BUILDING {name: 'A-1'}), (b2:BUILDING {name: 'A-0'})
CREATE (b1)-[:ADJACENT_TO {floor: 1}]->(b2)
```

```Cypher
MATCH (a:Building {name: 'S-1'}), (b:Building {name: 'S-2'})
CREATE (a)-[:CONNECTED {floor: 0}]->(b)
```
Set 1 property, created 1 relationship, completed after 46 ms.

**Task 1.4:** Create faculty head quarter locations (labeled with numbers on the map); each faculty headquarter should be represented as a node with "HQ" label,
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

### **Task 2: Analytics, run the following queries:** 
**Task 2.1:** Are there any buildings that are not connected directly (not through an entrance) to other buildings?
```Cypher
MATCH (b:Building)
WHERE NOT (b)-[:ADJACENT_TO]-(:Building)
RETURN b.name
```
Started streaming 46 records after 9 ms and completed after 23 ms.
Output --> 46 

```Cypher
-- NEW 
MATCH (b:Building)
WHERE NOT (b)-[:ADJACENT_TO]-(:Building)
RETURN b.name
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
MATCH (s:SERVICE)
RETURN count(s) AS serviceFacilitiesCount
```
Started streaming 1 records after 8 ms and completed after 9 ms.
Output --> 4

**Task 2.3:** What buildings A-1 is connected with?
```Cypher
MATCH (a1:Building {name: 'A-1'})-[:ADJACENT_TO]-(connectedBuilding)
RETURN connectedBuilding.name AS connectedBuilding
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
WHERE ALL(node IN nodes(path)[1..-1] WHERE node:TEACHING OR node:RESEARCH OR node:SERVICE)
RETURN path

```
**Task 2.6:** What is a shortest path (minimal number of buildings to go through) from the C-3 ground floor to the A-0 entrance?
```Cypher
MATCH (start:Building {name: 'C-3', floor: 0})-[:ADJACENT_TO*]-(end:Building {name: 'A-0', floor: 1})
MATCH path = shortestPath((start)-[:ADJACENT_TO*]-(end))
RETURN path
```
