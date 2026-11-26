UIF Relational Database Project



Run the following single command from the root of the freshly cloned repository:



```bash

docker compose up --abort-on-container-exit



Expected output:



1. The db service starts PostgreSQL 16, automatically initializes the normalized schema, loads the data, and applies the migration scripts from /init.



2\. Once the database is healthy, the runner service executes all Part 2 SQL queries in order, printing each question, its relational algebra expression, and the query result.



3\. The runner service regenerates the RelaX group file at ./output/grupo\_relax.txt and exits without errors.



Test credentials are documented in .env.example



Verification Test 

Tested by: Martínez Ruíz César Javier



Date: 23-11-2026



Commit hash: 



Result: Cloned into a new folder, executed docker compose up --abort-on-container-exit, and verified that all queries and the RelaX export completed without errors.



Gemini were used during this practice as a study and drafting assistant to verify normalization proofs, review Markdown documentation, and structure the Docker Compose configuration.

