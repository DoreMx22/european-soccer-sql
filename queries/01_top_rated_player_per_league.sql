-- ============================================================================
-- Top Rated Player per League
-- ============================================================================
-- Question:
--   For each league in the database, who is the player with the highest
--   average overall rating? And how many total goals were scored in that league?
--
-- Approach:
--   Multi-step CTE pipeline that:
--     1. Calculates each player's average overall_rating across seasons.
--     2. Maps every player to their league by flattening the 22 player slots
--        per match (home_player_1..11 + away_player_1..11) using UNION ALL.
--     3. Identifies the maximum rating per league.
--     4. Sums total goals scored per league.
--   The final SELECT joins everything together to retrieve player and league
--   names, alongside the league's total goals as context.
--
-- Database: European Soccer Database (Hugo Mathien, Kaggle)
-- Engine:   MySQL 8
-- ============================================================================

WITH rating_player AS (
    -- Step 1: Average overall rating per player across all seasons
    SELECT
        pa.player_api_id,
        AVG(pa.overall_rating) AS avg_rating
    FROM player_attributes pa
    GROUP BY pa.player_api_id
),

ligas_jugador AS (
    -- Step 2: Map each player to a league by flattening the 22 player slots
    -- in the Match table. UNION ALL stacks all (player, league) pairs;
    -- DISTINCT in the final SELECT removes duplicates downstream.
    SELECT DISTINCT home_player_1 AS player, league_id AS league
    FROM `match` WHERE home_player_1 IS NOT NULL
    UNION ALL
    SELECT DISTINCT home_player_2, league_id FROM `match` WHERE home_player_2 IS NOT NULL
    UNION ALL
    SELECT DISTINCT home_player_3, league_id FROM `match` WHERE home_player_3 IS NOT NULL
    UNION ALL
    SELECT DISTINCT home_player_4, league_id FROM `match` WHERE home_player_4 IS NOT NULL
    UNION ALL
    SELECT DISTINCT home_player_5, league_id FROM `match` WHERE home_player_5 IS NOT NULL
    UNION ALL
    SELECT DISTINCT home_player_6, league_id FROM `match` WHERE home_player_6 IS NOT NULL
    UNION ALL
    SELECT DISTINCT home_player_7, league_id FROM `match` WHERE home_player_7 IS NOT NULL
    UNION ALL
    SELECT DISTINCT home_player_8, league_id FROM `match` WHERE home_player_8 IS NOT NULL
    UNION ALL
    SELECT DISTINCT home_player_9, league_id FROM `match` WHERE home_player_9 IS NOT NULL
    UNION ALL
    SELECT DISTINCT home_player_10, league_id FROM `match` WHERE home_player_10 IS NOT NULL
    UNION ALL
    SELECT DISTINCT home_player_11, league_id FROM `match` WHERE home_player_11 IS NOT NULL
    UNION ALL
    SELECT DISTINCT away_player_1, league_id FROM `match` WHERE away_player_1 IS NOT NULL
    UNION ALL
    SELECT DISTINCT away_player_2, league_id FROM `match` WHERE away_player_2 IS NOT NULL
    UNION ALL
    SELECT DISTINCT away_player_3, league_id FROM `match` WHERE away_player_3 IS NOT NULL
    UNION ALL
    SELECT DISTINCT away_player_4, league_id FROM `match` WHERE away_player_4 IS NOT NULL
    UNION ALL
    SELECT DISTINCT away_player_5, league_id FROM `match` WHERE away_player_5 IS NOT NULL
    UNION ALL
    SELECT DISTINCT away_player_6, league_id FROM `match` WHERE away_player_6 IS NOT NULL
    UNION ALL
    SELECT DISTINCT away_player_7, league_id FROM `match` WHERE away_player_7 IS NOT NULL
    UNION ALL
    SELECT DISTINCT away_player_8, league_id FROM `match` WHERE away_player_8 IS NOT NULL
    UNION ALL
    SELECT DISTINCT away_player_9, league_id FROM `match` WHERE away_player_9 IS NOT NULL
    UNION ALL
    SELECT DISTINCT away_player_10, league_id FROM `match` WHERE away_player_10 IS NOT NULL
    UNION ALL
    SELECT DISTINCT away_player_11, league_id FROM `match` WHERE away_player_11 IS NOT NULL
),

rating_maximo AS (
    -- Step 3: Highest average rating per league
    SELECT
        lj.league,
        MAX(rp.avg_rating) AS max_rating
    FROM rating_player rp
    JOIN ligas_jugador lj
        ON lj.player = rp.player_api_id
    GROUP BY lj.league
),

total_goals AS (
    -- Step 4: Total goals scored per league (home + away)
    SELECT
        league_id,
        SUM(home_team_goal + away_team_goal) AS total_goals
    FROM `match`
    GROUP BY league_id
)

-- Final query: pull names, ratings, and league context together
SELECT DISTINCT
    p.player_name             AS player,
    l.name                    AS league,
    ROUND(rp.avg_rating, 2)   AS rating,
    tg.total_goals            AS league_total_goals
FROM player p
JOIN rating_player rp
    ON p.player_api_id = rp.player_api_id
JOIN ligas_jugador lj
    ON p.player_api_id = lj.player
JOIN league l
    ON l.id = lj.league
JOIN total_goals tg
    ON tg.league_id = lj.league
JOIN rating_maximo rm
    ON  rm.league     = lj.league
    AND rm.max_rating = rp.avg_rating
ORDER BY rating DESC;
