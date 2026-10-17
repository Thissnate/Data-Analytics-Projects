-- =============================================
-- Pixar Films Performance Analysis
-- Author: Oghenyerhovwo Oruma
-- =============================================


-- 1. Top 10 Films by Worldwide Box Office
SELECT TOP 10
    f.film,
    b.budget,
    b.box_office_worldwide,
    b.box_office_worldwide - b.budget AS Profit
FROM pixar_films f
JOIN box_office b ON f.film = b.film
ORDER BY b.box_office_worldwide DESC;


-- 2. Films with Highest ROI (Return on Investment)
SELECT 
    f.film,
    b.budget,
    b.box_office_worldwide,
    ROUND((b.box_office_worldwide - b.budget) * 100.0 / b.budget, 2) AS ROI_Percentage
FROM pixar_films f
JOIN box_office b ON f.film = b.film
WHERE b.budget > 0
ORDER BY ROI_Percentage DESC;


-- 3. Average Ratings Overview
SELECT 
    ROUND(AVG(rotten_tomatoes_score), 1) AS Avg_Rotten_Tomatoes,
    ROUND(AVG(metacritic_score), 1) AS Avg_Metacritic,
    ROUND(AVG(imdb_score), 1) AS Avg_IMDb
FROM public_response;


-- 4. Number of Films by Release Year
SELECT 
    YEAR(release_date) AS Release_Year,
    COUNT(*) AS Number_of_Films
FROM pixar_films
GROUP BY YEAR(release_date)
ORDER BY Release_Year;


-- 5. Top Directors by Total Box Office
SELECT 
    p.name AS Director,
    COUNT(DISTINCT p.film) AS Number_of_Films,
    SUM(CAST(b.box_office_worldwide AS BIGINT)) AS Total_Box_Office
FROM pixar_people p
JOIN box_office b ON p.film = b.film
WHERE p.role_type = 'Director'
GROUP BY p.name
ORDER BY Total_Box_Office DESC;


-- 6. Oscar Performance Summary
SELECT 
    status,
    COUNT(*) AS Number_of_Awards
FROM academy
GROUP BY status
ORDER BY Number_of_Awards DESC;


-- 7. Films with Most Oscar Nominations
SELECT 
    film,
    COUNT(*) AS Total_Nominations
FROM academy
WHERE status = 'Nominated'
GROUP BY film
ORDER BY Total_Nominations DESC;