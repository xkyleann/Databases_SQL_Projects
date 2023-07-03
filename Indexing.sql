-- P2_Indexing 
-- ---------------------------------------------------------------------------------------------------
-- Topic: Indexing, the goal of this lab working with advanced indeing in relational databases. 
-- In florist's shop there are two database. 1-ascii.sql and other one is 3-ascii.sql
-- orders --> all_orders

\o exercise1.txt -- Execute a query which displays all orders for the buk1 composition. Check the execution plan and take note of the execution times.
SELECT * FROM all_orders WHERE compositions_no = 'buk1'; -- compositions_no also refers composition_id
CREATE INDEX compositions_in ON orders USING hash (compositions_no);
EXPLAIN ANALYZE SELECT DESCRIPTION * FROM all_orders WHERE composition_no = 'buk1';
\o


\o exercise2.txt -- Delete the index created in the previous exercise and create a similar one, but using B-trees. Repeat the previous query and take a note of the results.
CREATE INDEX compositions_in ON all_orders (compositions_no);
EXPLAIN ANALYZE SELECT DESCRIPTION * FROM WHERE compositions_no = 'buk1';
EXPLAIN ANALYZE SELECT * FROM WHERE compositions_no < 'c' -- Execute a query displaying orders of all compositions with IDs beginning with letters appearing before the letter 'c' in the alphabet. Is the index in use?
EXPLAIN ANALYZE SELECT compositions_no from all_orders where compositions_no ='c' AND paif ='f';
EXPLAIN ANALYZE SELECT * FROM all_orders WHERE compositions_no ~ '^c'; -- can be removed 
DROP INDEX compositions_in;
\o


\o exercise3.txt -- Create an index for the remarks column and query the database for all orders with remarks beginning with the "do" string. Is the index in use?
CREATE INDEX orders_remarks ON orders (remarks);
EXPLAIN ANALYZE SElECT * FROM orders WHERE remarks LIKE 'do%';
DROP INDEX orders_remarks;
CREATE INDEX orders_remarks_idx ON orders (remarks varchar_pattern_ops);
DROP INDEX orders_remarks;
\o



\o exercise4.txt -- Create a multi-column index covering the client_id, recipient_id and composition_id columns.
CREATE INDEX multi_column_index ON orders (client_id, recipient_id, composition_id);
EXPLAIN ANALYZE SELECT * FROM orders WHERE client_id = 'msowins' AND recipient_id = 1 AND composition_id = 'buk1';
EXPLAIN ANALYZE SELECT * FROM orders WHERE client_id = 'msowins' OR recipient_id = 1 OR composition_id = 'buk1';
EXPLAIN ANALYZE SELECT * FROM orders WHERE composition_id = 'buk1';
DROP INDEX multi_column_index;
CREATE INDEX composition_index ON orders (composition_id);
CREATE INDEX recipient_index ON orders (recipient_id);
CREATE INDEX client_index ON orders (client_id);
EXPLAIN ANALYZE SELECT * FROM orders WHERE client_id = 'msowins' AND recipient_id = 1 AND composition_id = 'buk1';
EXPLAIN ANALYZE SELECT * FROM orders WHERE client_id = 'msowins' OR recipient_id = 1 OR composition_id = 'buk1';
EXPLAIN ANALYZE SELECT * FROM orders WHERE composition_id = 'buk1';
\o



\o exercise5.txt -- Run a query which returns all orders sorted by their composition ID. Is the index in use?
EXPLAIN ANALYZE SELECT * FROM all_orders ORDER BY composition_id ORDER BY composition_id ASC;
DROP INDEX composition_index;
DROP INDEX recipient_id_idx;
DROP INDEX client_index;
EXPLAIN ANALYZE SELECT  all_orders, composition_id  FROM orders ORDER BY composition_id ASC;
\o



\o exercise6.txt -- Create an index on the client_id column, but only for orders which have been paid.
CREATE INDEX  client_index ON orders (client_id) WHERE all.paid ='t';
EXPLAIN ANALYZE SELECT * FROM orders WHERE all.paid  = 't';
EXPLAIN ANALYZE SELECT * FROM orders WHERE client_id='msowins' AND all.paid='t'; 
EXPLAIN ANALYZE SELECT sum(price) FROM orders WHERE all.paid = 'f';
DROP INDEX client_index;
\o




\o exercise7.txt -- Create an index and write a query which retrieves clients living in a city which begins with a given string (e.g. "krak"), regardless of the case (e.g. "krak"="Krak"="KRAK", etc.).
EXPLAIN ANALYZE SELECT * FROM all_clients WHERE city LIKE 'Krak%';
CREATE INDEX name_in ON clients (client_id);
DROP INDEX name_in;
EXPLAIN ANALYZE SELECT * FROM all_clients WHERE city LIKE 'Krak%';
\o



\o exercise8.txt -- Add a column called location of type point to the orders table. Populate this column with random data within the (0,0)–(100,100) range:
ALTER  TABLE orders ADD  COLUMN location point;
UPDATE all_orders SET location = point ( random ( ) * 100 , random ( ) * 100 ) ;
EXPLAIN ANALYZE SELECT * FROM all_orders ORDER BY location <-> point '(50,50)' LIMIT 10;
CREATE INDEX  location_idx ON all_orders USING gist(location);
EXPLAIN ANALYZE SELECT * FROM all_orders ORDER BY location <-> point '(50,50)' LIMIT 10;
DROP INDEX index_of_location;
ALTER TABLE all_orders DROP COLUMN location;
\o
