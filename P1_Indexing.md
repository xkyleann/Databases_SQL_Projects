# DATABASES P1
- Peoject topic is **_Indexing_** 
- Documantation can be find at --> [Lecture 1](https://github.com/Kyleann/AGH_Databeses_2/files/11012274/01-recap-sql-postgres-latest.pdf)

## Useful SQL Commands 
  - The **ANALYZE** command collects statistics of value distribution in table columns and stores them in the pg_statistic system catalog. The planner will only be able to determine an optimal execution plan if the ANALYZE command was executed for a given table and its columns significant for the query.
  - The **EXPLAIN** command displays the query execution plan. Using the **_VERBOSE_** option will show more details. The **_ANALYZE_** option automatically executes **_ANALYZE_** and the query itself, letting EXPLAIN display not only the plan, but also the actual execution results.
  
## Projects 
- Exercise for Indexing with SQL. 
### **Task 1: Hash Based Indexes** 
- Execute a query which displays all orders for the buk1 composition. Check the execution plan and take note of the execution times.
- Add a hash-based index which can accelerate the aforementioned query to the orders table. Take note of the plan and execution plan.
**Task 1: Solution** 
```SQL
\o exercise1.txt -- Execute a query which displays all orders for the buk1 composition. Check the execution plan and take note of the execution times.
SELECT * FROM all_orders WHERE compositions_no = 'buk1'; -- compositions_no also refers composition_id
CREATE INDEX compositions_in ON orders USING hash (compositions_no);
EXPLAIN ANALYZE SELECT DESCRIPTION * FROM all_orders WHERE composition_no = 'buk1';
	``` 
