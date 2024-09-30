# Spotify Advanced SQL Project and Query Optimization P-6
Project Category: Advanced
[Click Here to get Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

![Black-Spotify-Logo](https://github.com/user-attachments/assets/cc32572c-8348-4898-b7fd-452416920c82)

## Overview
This project analyzes Spotify data using SQL to perform exploratory data analysis (EDA) and complex queries. Key tasks include calculating correlations, ranking tracks, and aggregating metrics like streams, views, and likes. It also applies window functions to derive insights on top tracks, energy differences, and artist contributions.

```sql
-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
```
## Project Steps

### 1. Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

### 4. Querying the Data
After the data is inserted, various SQL queries can be written to explore and analyze the data. Queries are categorized into **easy**, **medium**, and **advanced** levels to help progressively develop SQL proficiency.

#### Easy Queries
- Simple data retrieval, filtering, and basic aggregations.
  
#### Medium Queries
- More complex queries involving grouping, aggregation functions, and joins.
  
#### Advanced Queries
- Nested subqueries, window functions, CTEs, and performance optimization.

### 5. Query Optimization
In advanced stages, the focus shifts to improving query performance. Some optimization strategies include:
- **Indexing**: Adding indexes on frequently queried columns.
- **Query Execution Plan**: Using `EXPLAIN ANALYZE` to review and refine query performance.
  
---

## Practice Questions

### Easy Level
1. Retrieve the names of all tracks that have more than 1 billion streams.
2. List all albums along with their respective artists.
3. Get the total number of comments for tracks where licensed = TRUE.
4. Find all tracks that belong to the album type "single."
5. Count the total number of tracks by each artist.
6. Calculate the correlation between views and likes for each artist.

### Medium Level
1. Calculate the average danceability of tracks in each album.
2. Find the top 5 tracks with the highest energy values.
3. List all tracks along with their views and likes where official_video = TRUE.
4. For each album, calculate the total views of all associated tracks.
5. Retrieve the track names that have been streamed on Spotify more than YouTube.
6. Which album types generate the most streams?
7. Find the top 10 most popular tracks (by views) that have low valence, and what is their average energy?

### Advanced Level
1. Find the top 3 most-viewed tracks for each artist using window functions.
2. Find tracks where the liveness score is above the average.
3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
4. Find tracks where the energy-to-liveness ratio is greater than 1.2.
5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
6. Calculate the percentage of total streams that each artist contributes relative to the overall streams on the platform.
7. Identify the top 3 longest albums (by total track duration) for each artist.
8. Find the most commented track for each album where speechiness is greater than 0.66.
9. Identify tracks where the tempo is in the top 10% of all tracks.

---

## Query Optimization Technique 

To improve query performance, we carried out the following optimization process:

- **Initial Query Performance Analysis Using `EXPLAIN`**
    - We began by analyzing the performance of a query using the `EXPLAIN` function.
    - The query retrieved tracks based on the `artist` column, and the performance metrics were as follows:
        - Execution time (E.T.): **7 ms**
        - Planning time (P.T.): **0.17 ms**

- **Index Creation on the `artist` Column**
    - To optimize the query performance, we created an index on the `artist` column. This ensures faster retrieval of rows where the artist is queried.
    - **SQL command** for creating the index:
      ```sql
      CREATE INDEX idx_artist ON spotify_tracks(artist);
      ```
- **Performance Analysis After Index Creation**
    - After creating the index, we ran the same query again and observed significant improvements in performance:
        - Execution time (E.T.): **0.153 ms**
        - Planning time (P.T.): **0.152 ms**
     
This optimization shows how indexing can drastically reduce query time, improving the overall performance of our database operations in the Spotify project.
---
**Technology Suite**

**Database: PostgreSQL**

**SQL Queries:** Includes DDL (Data Definition Language), DML (Data Manipulation Language), aggregations, joins, subqueries, and window functions.

**Tools:** Utilize pgAdmin 4 (or any SQL editor) along with PostgreSQL, which can be installed via Homebrew, Docker, or directly.

**Steps to Execute the Project**

**Install PostgreSQL and pgAdmin:**

Ensure you have PostgreSQL and pgAdmin installed on your machine. These tools are essential for managing your database and executing SQL queries.
Set Up the Database Schema and Tables:

Use the provided normalization structure to create the necessary database schema and tables. This step involves defining the structure of your data, which is crucial for ensuring data integrity and efficiency.
Insert Sample Data:

Populate the created tables with sample data. This allows you to test your queries and gain insights from the dataset you’re working with.
Execute SQL Queries:

Run the SQL queries designed to address the specified problems. This is where you will apply your SQL knowledge to extract meaningful information from the dataset.
Explore Query Optimization Techniques:

Investigate methods for optimizing your queries, especially when working with large datasets. Understanding how to write efficient queries can significantly improve performance and reduce execution tim

---

## Contributing
If you would like to contribute to this project, feel free to fork the repository, submit pull requests, or raise issues.
