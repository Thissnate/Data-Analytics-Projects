# Spotify Streaming History Analysis

**Author:** Oghenenyerhovwo Oruma ([Thissnate](https://github.com/Thissnate))  
**Tools:** Excel / Power Query → SQL Server → Power BI  
**Dataset:** Spotify Streaming History (Maven Analytics)  
**Period:** July 2013 – December 2024  
**Status:** Completed

---

## Project Overview

Personal Spotify streaming history analysis exploring listening habits, top artists & tracks, skip behaviour, platform usage, and discovery vs loyalty patterns over 11+ years.

### Key Questions Answered
- Which artist was listened to the most this year vs last year?
- Which songs were played the most and how often were they skipped?
- What time of day (and day of week) is music typically listened to?
- How often are new artists explored versus replaying familiar favourites?

---

## Dataset

| Item | Details |
|------|---------|
| Source | Maven Analytics – Spotify Streaming History |
| Original rows | 149,860 |
| Cleaned rows | 148,675 |
| Date range | 2013-07-08 to 2024-12-15 |
| Unique artists | 4,112 |
| Unique tracks | 13,661 |

**Cleaning steps:**
- Removed 1,185 full duplicate rows
- Filled nulls in `reason_start` and `reason_end` with "unknown"
- Added helper columns: `minutes_played`, `hours_played`, `year`, `month`, `hour`, `day_of_week`

---

## Folder Structure

```
spotify-streaming-analysis/
├── Data/
│   └── spotify_history_cleaned.csv
├── Sql/
│   └── 01_spotify_analysis_queries.sql
├── PowerBI/
│   ├── Spotify_Streaming_History_Dashboard.pbix
│   └── Spotify_streaming_performance_dashboard_page.jpg
└── README.md
```

---

## Key Findings

| Metric | Value |
|--------|-------|
| Total Streams | 148,675 |
| Total Hours Listened | 5,288.7 |
| Overall Skip Rate | 5.29% |
| Top Artist (All-time) | The Beatles (333.1 hrs) |
| Peak Listening Time | Late night / early morning (12 AM – 2 AM) |
| Dominant Platform | Android (93.9%) |
| Listening Pattern | Strong preference for familiar / repeat artists |

**Top 5 Artists by Hours Listened:**
1. The Beatles – 333.1 hrs  
2. The Killers – 286.8 hrs  
3. John Mayer – 197.7 hrs  
4. Bob Dylan – 156.2 hrs  
5. Paul McCartney – 98.6 hrs  

**Most Played Tracks:**
- "Ode To The Mets" – The Strokes (203 plays)
- "In the Blood" – John Mayer (180 plays)
- "Dying Breed" – The Killers (166 plays)

**2023 vs 2024 Insight:**  
John Mayer and ABBA showed notable growth in 2024, while The Beatles and The Killers remained strong across both years.

---

## Power BI Dashboard

**Visuals included:**
1. KPI Cards (Total Streams, Total Hours, Unique Artists, Unique Tracks, Skip Rate %)
2. Listening Trend Over the Years
3. Streams by Platform
4. Top Artists by Hours Listened
5. Listening Activity by Hour of Day
6. Most Played Tracks
7. New vs Familiar Artists
8. Listening Activity by Day of Week
9. Top Artists: 2023 vs 2024

**Slicers:** Year/Month, Platform, Artist Type

The `.pbix` file and dashboard preview image are available in the `PowerBI/` folder.

---

## How to Reproduce

1. Load `Data/spotify_history_cleaned.csv` into SQL Server or Power BI
2. Run the analysis queries in `Sql/01_spotify_analysis_queries.sql`
3. Open the Power BI file in the `PowerBI/` folder

---

## Tools Used
- **Excel / Power Query** – Initial data cleaning
- **SQL Server** – Data storage and analysis
- **Power BI** – Interactive dashboard
