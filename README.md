# SQL Soccer Analysis

SQL portfolio project exploring the **European Soccer Database** to practice and showcase intermediate-to-advanced SQL skills: multi-step CTEs, JOINs across multiple tables, aggregations, and data wrangling on a real-world dataset.

---

## Dataset

[European Soccer Database](https://www.kaggle.com/datasets/hugomathien/soccer) by Hugo Mathien (Kaggle).

| Table              | Rows    | Description                                |
|--------------------|---------|--------------------------------------------|
| `Player`           | 11,060  | Player profiles (name, height, weight)     |
| `Player_Attributes`| 183,978 | Per-season FIFA-style player ratings       |
| `Match`            | 25,979  | Match-level data, lineups, and scores      |
| `Team`             | 299     | Team profiles                              |
| `Team_Attributes`  | 1,458   | Tactical attributes per team and season    |
| `League`           | 11      | European leagues                           |
| `Country`          | 11      | Countries linked to leagues                |

The original file is SQLite; for this project it was migrated to **MySQL 8**.

---

## Tech Stack

- **MySQL 8** — query engine
- **DBeaver** — IDE
- **Git / GitHub** — version control

---

## Queries

### [`01_top_rated_player_per_league.sql`](queries/01_top_rated_player_per_league.sql)

**Question:** For each league, who is the player with the highest average overall rating, and how many total goals were scored in that league?

**Techniques used:**
- 4 chained CTEs to build the analysis step by step
- `UNION ALL` of 22 SELECTs to flatten the 22 player slots per match into a single `(player, league)` mapping (the `Match` table stores lineups in wide format)
- `MAX` per group to identify the top rating in each league
- 5 JOINs in the final query to enrich IDs with names

**Sample output:**

| Player              | League                  | Rating | League Total Goals |
|---------------------|-------------------------|--------|--------------------|
| Lionel Messi        | Spain LIGA BBVA         | 92.19  | 8,412              |
| Cristiano Ronaldo   | England Premier League  | 91.28  | 8,240              |
| Franck Ribery       | Germany 1. Bundesliga   | 88.46  | 7,103              |
| Zlatan Ibrahimovic  | Italy Serie A           | 88.29  | 7,895              |
| Zlatan Ibrahimovic  | France Ligue 1          | 88.29  | 7,427              |
| Iker Casillas       | Spain LIGA BBVA *(GK)*  | 86.95  | —                  |

**Findings:**
- Messi tops the entire dataset (~92 rating across seasons).
- Zlatan appears as top-rated in **two leagues** — he played at elite level in both Serie A and Ligue 1.
- Goalkeepers (Casillas, Valdés) make the cut. Their `overall_rating` competes with elite outfield players, which is realistic.
- The Eredivisie (Netherlands) has the highest goals-per-match average; Serie A the lowest among the top-5 leagues — consistent with their reputations.

---

## Skills Practiced

- `SELECT`, `WHERE`, `LIMIT`, `ORDER BY`
- Aggregations: `COUNT`, `SUM`, `AVG`, `MAX`, `MIN`, `ROUND`
- `GROUP BY` and `HAVING`
- `JOIN` (INNER, LEFT, RIGHT) and self-joins
- `UNION` / `UNION ALL`
- Subqueries (in `WHERE` and `FROM`)
- **CTEs (`WITH ... AS`)** — multi-step pipelines
- Date functions: `YEAR`, `MONTH`, `DATEDIFF`, `TIMESTAMPDIFF`
- String functions: `SUBSTRING_INDEX`, `CONCAT`, `LIKE`
- `CASE WHEN` for conditional logic
- Type conversion: `CAST`, `CONVERT`
- `NULL` handling: `IS NULL`, `IFNULL`, `COALESCE`
- Views: `CREATE VIEW`

---

## How to Run

1. Download the original SQLite database from [Kaggle](https://www.kaggle.com/datasets/hugomathien/soccer).
2. Convert to MySQL (or use the SQLite version directly — most queries run with minor syntax adjustments).
3. Open `queries/01_top_rated_player_per_league.sql` in your SQL client and run it against the loaded database.

---

## Roadmap

- [x] Multi-step CTE analysis
- [ ] Window functions (rankings, running totals, partition-based comparisons)
- [ ] Pivot / unpivot transformations
- [ ] Query optimization with indexes and `EXPLAIN`
- [ ] Final integrative project — World Cup historical analysis (SQL + Python)

---

## License

MIT
