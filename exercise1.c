// Exercise 4.1 - Lab3 - Edibe Tutku Gayda
// Write a C program that dynamically allocates memory for a data structure containing: id(integer), name(string, 20), and descriptin (string,90)
// gcc exercise1.c -o exercise1 
// ./exercise1
#include <stdio.h>
#include <stdlib.h> // dynamic memory allocation --> "malloc" and "free"

#define MAX_RECORDS 1000000 //max number of records for allocated

struct Rec { // Rec = represents each record 
    int id;                // unique identifier, primary key --> id(integer)
    char name[20];         // name (string, 20)
    char desc[90];         // description (string, 90)
};

int main() {
    struct Rec *data;
    int i;

    // allocate memory dynamically
    // memory will be allocated dynamically to store an array of "Rec" structures using malloc
    data = (struct Rec *)malloc(sizeof(struct Rec) * MAX_RECORDS); //sizeof(struct Rec) * MAX_RECORDS --> total memory allocated
    if (data == NULL) {
        fprintf(stderr, "Memory allocation error\n");
        return 1;
    }

    // fill the structure with sample data (?)
    for (i = 0; i < MAX_RECORDS; i++) {
        data[i].id = i; // data[i].id = value of i --> itares 
        sprintf(data[i].name, "Name%d", i); //  format and store a series of characters and values in the name field of the current record (data[i]).
        sprintf(data[i].desc, "Description%d", i);
    }

    // search for a record with id = 999999
    int search_id = 999999;
    for (i = 0; i < MAX_RECORDS; i++) {
        if (data[i].id == search_id) {
            // If found, it prints the details of the record (id, name, description).
            printf("Record found: id=%d, name=%s, desc=%s\n", data[i].id, data[i].name, data[i].desc);
            break;
        }
    }

    // Free allocated memory
    free(data); //  to prevent memory leaks

    return 0;
}
