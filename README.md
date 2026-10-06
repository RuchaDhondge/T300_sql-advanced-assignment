# Advanced SQL Assignment: Online Shopping Platform

## Project Overview
This repository contains the database schema, sample dataset, advanced SQL query implementations, routines, transactions, triggers, and performance tuning solutions for an Online Shopping Platform database (`shopping_db`).

The solution is implemented as a single, fully re-runnable SQL script (`sql-advanced-assignment.sql`) designed to demonstrate modern relational database capabilities, automated workflows, and query optimization techniques.

---

## Database Schema & ER Model

The database manages four main entities within the `shopping_db` database:

1. **Customers**: Stores customer profile details (`customer_id`, `customer_name`, `city`, `email`).
2. **Products**: Contains inventory product listings (`product_id`, `product_name`, `category`, `price`, `created_date`).
3. **Orders**: Relational transaction table linking customers and products (`order_id`, `customer_id`, `product_id`, `quantity`, `order_date`).
4. **Order_Audit**: Automated logging table captured by SQL triggers (`audit_id`, `order_id`, `action_date`).

---

## Execution Instructions

1. **Prerequisites**: MySQL Server 5.7+ or 8.0+ and MySQL Workbench (or MySQL CLI).
2. **Setup**: Clone the repository 
3. **Running the Script**:
   - Open `sql-advanced-assignment.sql` in MySQL Workbench.
   - Execute the entire script or run sections sequentially.

---

## Summary of Implemented Advanced SQL Concepts

- **Advanced Joins**: Evaluated relational combinations using `INNER JOIN` for matched sets, `CROSS JOIN` for Cartesian products, and `LEFT JOIN` for capturing unmatched parent records.
- **Subqueries**: Leveraged scalar subqueries in `HAVING` clauses, set checks using `NOT IN`, and row-by-row comparisons using correlated subqueries.
- **Set Operations**: Combined datasets using `UNION` and constructed MySQL-compatible equivalents for `INTERSECT` (via `INNER JOIN`) and `EXCEPT` (via `LEFT JOIN ... WHERE IS NULL`).
- **Window Functions**: Applied analytical functions like `RANK()` partitioned by category, `LAG()` for value shifting, and frame-based cumulative `SUM()` operations.
- **Common Table Expressions (CTEs)**: Used standard CTEs to simplify complex multi-level aggregations and recursive CTEs for sequential generation.
- **Views**: Virtualized filtered product datasets using `CREATE VIEW` for simplified data presentation.
- **Indexing & Performance Tuning**: Created single-column B-tree indexes on high-cardinality filtering attributes (`category`), analyzed execution plans using `EXPLAIN`, and converted non-sargable functions (`YEAR(created_date)`) into index-friendly date-range scans.
- **Stored Routines**: Engineered `GetProductsByCategory` procedure for modular parameter-driven retrieval and `CalculateOrderTotal` deterministic function for dynamic order valuations.
- **Transactions & Concurrency**: Demonstrated ACID compliance using `START TRANSACTION`, `COMMIT`, and `ROLLBACK`, including script idempotency via baseline state restoration.
- **Triggers**: Implemented an `AFTER INSERT` trigger on `Orders` to automate auditing into `Order_Audit`.
