# DATABASES P2
- Project topic is **_GIS_** 
- Final project documentation can be find at --> [PR 2]
- The goal of  is to get accustomed with spatial extensions to relational databases, using **_PostgreSQL and PostGIS_**.
## Introduction 
- Use your account on the server. If PostGIS support has not been added to the database, run the command: 
```SQL
CREATE EXTENSION postgis;
``` 
- Then, you will be able to use PostGIS functions in your schema. For reference, use the online PostGIS manual and the lecture slides.

## Projects 
- Exercise for PostgreSQL and PostGIS.
- Includes 6 exercises including answers.
- Must used file for tasks --> 
##### **Task 1: Creating a table, measuring distances, reference systems** 
- In this exercise, use the spherical WGS-84 reference system, SRID EPSG:4326 , used e.g. in by GPS receivers.
- Create a table called cities, which stores the city name and the coordinates of its centre (as a GEOMETRY). Add at least two cities to the table, using data from Wikipedia – coordinates can be found under the geohack link in the top right corner (e.g. here ).
- Caution: note that the coordinates are usually given in the (latitude, longitude) order, while WKT uses the opposite (longitude, latitude). Therefore, the centre of Kraków in WKT will look like this:
```SQL
POINT(19.938333 50.061389)
``` 
- Note that the default behaviour of geometry constructor functions (such as ST_GeomFromText or ST_MakePoint) is to generate a geometry without an SRID assigned (i.e., with SRID=0). To tag the geometry with the appropriate SRID (e.g. one that matches the coordinates), use ST_SetSRID.
- Write a query which computes the distance between the two cities. What units is the result in?
- To get a result in metres using ST_Distance, you must transform the coordinates to a planar reference system that covers your intended area and provides adequate precision in metres. Use the search engine at http://spatialreference.org to find the appropriate local reference system.
- Recompute the distance, but this time cast the coordinates to that reference system using ST_Transform inside ST_Distance.
- **_Solution_** for **_Task 1_**, should be like this: 
```SQL
exercise1.txt
-- TASK 1 : Creating a table, measuring distances, reference systems.
CREATE TABLE cities (
	city_name VARCHAR(255),
	latitude DECIMAL(9,6), -- Decimal(9,6) -> used to store the coordinates as decimal up to 9 digits and up to 6 decimal places. Coordinate of the center.
	longitude DECIMAL(9,6) -- Question -> Why 9,6 ? 
);

INSERT INTO cities (city_name, latitude, longitude) -- INSERT INTO -> For specify both column names and the values to be inserted.
VALUES (‘Krakow’, 50.0647, 19.9450); -- 50.0647, 19.9450 -> lat and lon of the city center. 
INSERT INTO cities (city_name,latitude,longitude)
VALUES ('Turkey',41.0082, 28.9784); -- lat and long of Istanbul 
SELECT * FROM cities; -- To display what is inserted in the cities table 
```

##### **Task 2: Geometry vs. geography** 
- In the first exercise, we used a planar reference system suitable for Poland, since GEOMETRY columns always measure distance as if the coordinates were on a flat surface, regardless of whether they are planar or spherical.
- Obviously, there can be no global reference system using meters with adequate linear precision – hence the need to use local reference systems. This can be inconvenient if you need your database to be able to store data for any location in the world.
- However, PostGIS also provides the GEOGRAPHY type, which uses WGS-84 (spherical) coordinates, but performs computations in metres, using a geoid representing the shape of the Earth. One drawback is that GEOGRAPHY is supported by less functions than GEOMETRY. Processing GEOGRAPHY objects is also a little slower.
- Repeat exercise 1, creating a similar table called cities2, but this time use the GEOGRAPHY type. Remember that you don’t need to transform the coordinates this time.
- **_Solution_** for **_Task 2_**, should be like this: 
```SQL
exercise2.txt
-- TASK 1.1 : Write a query which computes distance beetween the two cities. What units is the result in?
-- Using Haversine Formula in SQL 
-- Acos ->  inverse cosine function
-- Radians -> lat and lon values for Krakow and Istanbul expressed in radians

SELECT 
    6371 * ACOS( -- 6371 -> approximate radius of the earth in kilometers
        COS(RADIANS(50.0647)) * COS(RADIANS(41.0082)) * COS(RADIANS(28.9784) - RADIANS(19.9450)) + SIN(RADIANS(50.0647)) * SIN(RADIANS(41.0082))
    ) AS distance_in_km -- output has to be with km
FROM 
    cities
WHERE 
    city_name = 'Krakow'; 
```
##### **Task 3: Data import** 
