// Exercise 4.3 - Lab3 
// gcc exercise2.c -o exercise2
// ./exercise2

#include <stdio.h>
#include <sqlite3.h>

#define DB_FILE_MEMORY ":memory:"  // file name for memory storage
#define DB_FILE "test.db"          // file name for file storage.
#define MAX_RECORDS 1000000        // max number of records.

int main() {
    sqlite3 *db; // db SQLite database conection
    int rc; // rc = return code

    // open database connection 
    rc = sqlite3_open(DB_FILE_MEMORY, &db); // chose storage method
    if (rc != SQLITE_OK) {
        fprintf(stderr, "Cannot open database: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        return 1;
    }

    // create table and insert sample data
    char *sql = "CREATE TABLE IF NOT EXISTS records ("
                "id INTEGER PRIMARY KEY,"
                "name TEXT,"
                "desc TEXT);";
    rc = sqlite3_exec(db, sql, 0, 0, 0); // executes the SQL statement to create the table.
    if (rc != SQLITE_OK) {
        fprintf(stderr, "SQL error: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        return 1;
    }

    // use transactions
    sqlite3_exec(db, "BEGIN TRANSACTION", 0, 0, 0);
    for (int i = 0; i < MAX_RECORDS; i++) { // loops and inserts sample data into the records table.
        char insert_sql[200]; //sn = Formats an SQL INSERT statement and insert
        snprintf(insert_sql, sizeof(insert_sql), "INSERT INTO records (id, name, desc) VALUES (%d, 'Name%d', 'Description%d')", i, i, i);
        rc = sqlite3_exec(db, insert_sql, 0, 0, 0);
        if (rc != SQLITE_OK) {
            fprintf(stderr, "SQL error: %s\n", sqlite3_errmsg(db));
            sqlite3_close(db);
            return 1;
        }
    }

    sqlite3_exec(db, "COMMIT", 0, 0, 0); // commits transaction

    // use of indexes (create index on id column)
    sql = "CREATE INDEX IF NOT EXISTS idx_id ON records (id)";
    rc = sqlite3_exec(db, sql, 0, 0, 0);
    if (rc != SQLITE_OK) {
        fprintf(stderr, "SQL error: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        return 1;
    }

    //  journaling modes (set journal_mode)
    // journaling mode determines how changes are written to the database file
    sql = "PRAGMA journal_mode = WAL";  
    rc = sqlite3_exec(db, sql, 0, 0, 0);
    if (rc != SQLITE_OK) {
        fprintf(stderr, "SQL error: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        return 1;
    }

    // Search for a record with id = 999999
    sql = "SELECT * FROM records WHERE id = 999999";
    sqlite3_stmt *stmt;  // stmt is a variable of type sqlite3_stmt 
    rc = sqlite3_prepare_v2(db, sql, -1, &stmt, 0);
    if (rc != SQLITE_OK) {
        fprintf(stderr, "SQL error: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        return 1;
    }
    rc = sqlite3_step(stmt);
    if (rc == SQLITE_ROW) {
        printf("Record found: id=%d, name=%s, desc=%s\n", sqlite3_column_int(stmt, 0), sqlite3_column_text(stmt, 1), sqlite3_column_text(stmt, 2));
    } else {
        printf("Record not found\n");
    }
    sqlite3_finalize(stmt);

    // Close database connection
    sqlite3_close(db);

    return 0;
}
