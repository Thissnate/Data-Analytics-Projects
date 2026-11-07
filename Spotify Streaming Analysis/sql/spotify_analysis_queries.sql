/*
=====================================================
Spotify Streaming History - SQL Analysis
Project: Spotify Streaming History Analysis
Database: Spotify_historyDB
Table:   dbo.spotify_history_cleaned
Author:  Oghenyerhovwo Oruma (Thissnate)
Date:    October 2026
=====================================================

Data Overview (after cleaning):
- Total rows: 148,675
- Date range: 2013-07-08 to 2024-12-15
- Unique artists: 4,112
- Unique tracks: 13,661
- Total hours listened: 5,288.7
- Overall skip rate: 5.29%

Cleaning steps applied:
- Removed 1,185 full duplicate rows
- Filled nulls in reason_start / reason_end with 'unknown'
- Added helper columns: minutes_played, hours_played, year, month, hour, day_of_week
*/


-- =====================================================
-- 1. OVERALL KPIs
-- =====================================================
SELECT 
    COUNT(*) AS total_streams,
    COUNT(DISTINCT artist_name) AS unique_artists,
    COUNT(DISTINCT track_name) AS unique_tracks,
    ROUND(SUM(ms_played) / 3600000.0, 1) AS total_hours_listened,
    ROUND(AVG(ms_played) / 60000.0, 2) AS avg_minutes_per_stream,
    ROUND(SUM(CASE WHEN skipped = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS overall_skip_rate_pct
FROM dbo.spotify_history_cleaned;


-- =====================================================
-- 2. LISTENING OVER TIME
-- =====================================================

-- Yearly trend
SELECT 
    year,
    COUNT(*) AS total_streams,
    ROUND(SUM(ms_played) / 3600000.0, 1) AS hours_listened,
    COUNT(DISTINCT artist_name) AS unique_artists
FROM dbo.spotify_history_cleaned
GROUP BY year
ORDER BY year;

-- Monthly trend
SELECT 
    year,
    month,
    COUNT(*) AS total_streams,
    ROUND(SUM(ms_played) / 3600000.0, 1) AS hours_listened
FROM dbo.spotify_history_cleaned
GROUP BY year, month
ORDER BY year, month;


-- =====================================================
-- 3. TOP ARTISTS
-- =====================================================

-- Top 15 Artists All-Time (by hours listened)
SELECT TOP 15
    artist_name,
    COUNT(*) AS streams,
    ROUND(SUM(ms_played) / 3600000.0, 1) AS hours_listened,
    COUNT(DISTINCT track_name) AS unique_tracks
FROM dbo.spotify_history_cleaned
GROUP BY artist_name
ORDER BY hours_listened DESC;

-- Top Artists: 2024 vs 2023
SELECT 
    artist_name,
    SUM(CASE WHEN year = 2024 THEN 1 ELSE 0 END) AS streams_2024,
    SUM(CASE WHEN year = 2023 THEN 1 ELSE 0 END) AS streams_2023,
    ROUND(SUM(CASE WHEN year = 2024 THEN ms_played ELSE 0 END) / 3600000.0, 1) AS hours_2024,
    ROUND(SUM(CASE WHEN year = 2023 THEN ms_played ELSE 0 END) / 3600000.0, 1) AS hours_2023
FROM dbo.spotify_history_cleaned
WHERE year IN (2023, 2024)
GROUP BY artist_name
HAVING SUM(CASE WHEN year = 2024 THEN 1 ELSE 0 END) > 0
ORDER BY hours_2024 DESC;


-- =====================================================
-- 4. TOP TRACKS + SKIP BEHAVIOUR
-- =====================================================
SELECT TOP 20
    track_name,
    artist_name,
    COUNT(*) AS times_played,
    ROUND(SUM(ms_played) / 60000.0, 1) AS total_minutes,
    SUM(CASE WHEN skipped = 1 THEN 1 ELSE 0 END) AS times_skipped,
    ROUND(SUM(CASE WHEN skipped = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS skip_rate_pct
FROM dbo.spotify_history_cleaned
GROUP BY track_name, artist_name
ORDER BY times_played DESC;


-- =====================================================
-- 5. LISTENING HABITS (TIME OF DAY + DAY OF WEEK)
-- =====================================================

-- By Hour of Day
SELECT 
    hour AS hour_of_day,
    COUNT(*) AS total_streams,
    ROUND(SUM(ms_played) / 3600000.0, 1) AS hours_listened
FROM dbo.spotify_history_cleaned
GROUP BY hour
ORDER BY hour;

-- By Day of Week
SELECT 
    day_of_week,
    COUNT(*) AS total_streams,
    ROUND(SUM(ms_played) / 3600000.0, 1) AS hours_listened
FROM dbo.spotify_history_cleaned
GROUP BY day_of_week, 
         CASE day_of_week
             WHEN 'Sunday' THEN 1
             WHEN 'Monday' THEN 2
             WHEN 'Tuesday' THEN 3
             WHEN 'Wednesday' THEN 4
             WHEN 'Thursday' THEN 5
             WHEN 'Friday' THEN 6
             WHEN 'Saturday' THEN 7
         END
ORDER BY CASE day_of_week
             WHEN 'Sunday' THEN 1
             WHEN 'Monday' THEN 2
             WHEN 'Tuesday' THEN 3
             WHEN 'Wednesday' THEN 4
             WHEN 'Thursday' THEN 5
             WHEN 'Friday' THEN 6
             WHEN 'Saturday' THEN 7
         END;


-- =====================================================
-- 6. PLATFORM USAGE + DISCOVERY VS LOYALTY
-- =====================================================

-- Platform breakdown
SELECT 
    platform,
    COUNT(*) AS total_streams,
    ROUND(SUM(ms_played) / 3600000.0, 1) AS hours_listened,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS pct_of_streams
FROM dbo.spotify_history_cleaned
GROUP BY platform
ORDER BY total_streams DESC;

-- New vs Familiar artists
SELECT 
    CASE 
        WHEN stream_count = 1 THEN 'New / One-time artists'
        ELSE 'Repeat / Familiar artists'
    END AS artist_type,
    COUNT(*) AS number_of_artists,
    SUM(stream_count) AS total_streams
FROM (
    SELECT artist_name, COUNT(*) AS stream_count
    FROM dbo.spotify_history_cleaned
    GROUP BY artist_name
) AS artist_stats
GROUP BY 
    CASE 
        WHEN stream_count = 1 THEN 'New / One-time artists'
        ELSE 'Repeat / Familiar artists'
    END;


-- =====================================================
-- BONUS: MOST SKIPPED ARTISTS (min 20 plays)
-- =====================================================
SELECT TOP 10
    artist_name,
    COUNT(*) AS plays,
    SUM(CASE WHEN skipped = 1 THEN 1 ELSE 0 END) AS skips,
    ROUND(SUM(CASE WHEN skipped = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS skip_rate_pct
FROM dbo.spotify_history_cleaned
GROUP BY artist_name
HAVING COUNT(*) >= 20
ORDER BY skip_rate_pct DESC;


/*
=====================================================
KEY FINDINGS SUMMARY
=====================================================

1. Overall
   - 148,675 streams | 5,288.7 hours listened | 5.29% skip rate

2. Top Artists (All-time by hours)
   1. The Beatles          - 333.1 hours
   2. The Killers          - 286.8 hours
   3. John Mayer           - 197.7 hours
   4. Bob Dylan            - 156.2 hours
   5. Paul McCartney       - 98.6 hours

3. 2024 vs 2023
   - John Mayer and ABBA rose strongly in 2024
   - The Beatles and The Killers remained high but slightly lower than 2023

4. Top Tracks
   - "Ode To The Mets" (The Strokes) - 203 plays
   - "In the Blood" (John Mayer)     - 180 plays
   - "Dying Breed" (The Killers)     - 166 plays
   - Skip rates on top tracks are generally very low (< 5%)

5. Listening Habits
   - Peak listening: Midnight – 2 AM
   - Strongest day: Wednesday, followed by Tuesday and Monday
   - Platform: Android dominates (93.9% of streams)

6. Discovery vs Loyalty
   - Vast majority of listening comes from familiar/repeat artists
   - Only ~1,864 streams came from one-time artists
*/
