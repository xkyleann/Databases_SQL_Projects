-- Lab: The goal is to get accumstomed with spatial extensions to relational databases.
-- \d cities -> for display lab_gis.cities 
-- Exercise sheet with notes.
-- ---------------------------------------------------------------------------------------------------
\o exercise1.txt
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
\o
-- ------------------------------------------------------------------------------------------------------------
\o exercise1_1.txt
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
\o

-- ------------------------------------------------------------------------------------------------------------
\o exercise1_2.txt
-- TASK 1.2 : Write a query which computes distance beetween the two cities. What units is the result in?
-- Using ST_SetSRID, ST_Distance, ST_MakePoint

SELECT ST_Distance(
    ST_SetSRID(ST_MakePoint(19.9449799, 50.0646501), 4326), -- Krakow coordinates (longitude, latitude)
    ST_SetSRID(ST_MakePoint(28.9743882, 41.0082376), 4326) -- Istanbul coordinates (longitude, latitude)
) AS distance_in_meters; -- / 1000 AS distance_in_km;
\o
-- ST_MakePoint -> To create point geometries from the longitude and latitude coordinates of Krakow and Istanbul.
-- 4526 -> Which corresponds to the WGS 84 geographic coordinate system
-- ST_Distance -> To calculate the distance between the two points in meters
-- If needed, 'ST_Distance' can be convert to kilometers by dividing 1000.

-- ------------------------------------------------------------------------------------------------------------
\o exercise2.txt
-- TASK 2 : GEOMETRY VS. GEOGRAPHY 
CREATE TABLE cities2 ( 
    city_name VARCHAR(255),
    coordinates GEOGRAPHY(Point,4326) -- Point -> stores a single point and 4326 indicates the SRID for the WGS84 coordinate system.
);

INSERT INTO cities2 (city_name, coordinates)  -- coordinates ->  to store the point location in GEOGRAPHY data type
VALUES ('Istanbul', ST_GeographyFromText('POINT(28.9784 41.0082)')),
       ('Krakow', ST_GeographyFromText('POINT(19.9450 50.0647)'));
\o

-- ------------------------------------------------------------------------------------------------------------
\o exercise4.txt
-- TASK 4 : AREA OF THE KRAKOW
-- Calculate the area of Kraków in sq. km. 
SELECT ST_Area(ST_Transform(way, 3857))/1000000 AS area_sq_km
FROM planet_osm_polygon
WHERE admin_level = '8' AND name = 'Kraków';
\o

-- ST_Area -> compute the area of the polygon in square meters using GEOMETRY data type.
-- planet_osm_polygon -> access the OpenStreetMap data for polygons.
-- way -> column contains the polygon for Kraków
-- ST_Transform -> to convert the projection of the polygon to Web Mercator
-- Dividing 1000000 -> area from square meters to square kilometers

-- ------------------------------------------------------------------------------------------------------------
\o exercise5.txt
-- TASK 5 : SIMPLE SPATIAL OPERATORS
SELECT SUM(ST_Length(ST_Transform(way, 3857))) AS total_length_meters
FROM planet_osm_line
WHERE highway IN ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'tertiary', 'tertiary_link', 'residential', 'unclassified')
AND ST_Intersects(ST_Transform(way, 3857), (SELECT way FROM planet_osm_polygon WHERE admin_level = '8' AND name = 'Kraków'));

-- Planet_osm_linw ->  table to access OpenStreetMap data for road lines
-- Way ->  column contains the line for each road as a GEOMETRY object
-- ST_Transform -> to convert the projection of the line to Web Mercator (EPSG 3857)
-- ST_Intersects -> to select only those road lines that intersect with the administrative boundary of Kraków
-- ST_Length ->  the length of each road line in meters
-- SUM -> total length of roads used by motor vehicles
\o

-- ------------------------------------------------------------------------------------------------------------
-- TASK 6 : COUNTING LAMPS 
\o exercise6.txt
-- First Query -> common table expression 
WITH road_widths AS ( -- calculates the road width for each road in Krakow
  SELECT 
    id, 
    CASE 
      WHEN road_width IS NOT NULL THEN road_width -- checks if road_width is not null 
      WHEN lane_count IS NOT NULL THEN lane_count * 3.5 -- it checks lane_count 
      ELSE 6  -- if both are null, auto width 6 meters 
    END AS width
  FROM roads
  WHERE ST_Contains((SELECT geom FROM admin_boundaries WHERE name = 'Krakow'), geom)
), lamp_counts AS ( -- number of lamps >= 10m
  SELECT 
    r.id, 
    s.name, 
    COUNT(*) AS count
  FROM 
    road_widths r  -- table name = road_widths, table name = street_lamps
    JOIN street_lamps s ON ST_DWithin(r.geom, s.geom, 10 + r.width) -- ST_DWithin for check distance between a lamp and the road edge
  GROUP BY r.id, s.name
) 
-- Final Query 
SELECT name AS street_name, count AS number_of_lamps -- selects the street name and lamp count -> lamp_counts in the bottom
FROM lamp_counts
ORDER BY count DESC -- lamp count with descending order, and limit 20 
LIMIT 20;
\o

-- -------------------------------------------------------------------------------------------------------------- ------------------------------------------------------------------------------------------------------------
