USE [Portfolio Project]
GO

-- COVID DEATHS TABLE (for reference)
SELECT *
FROM CovidDeaths;

-- COVID VACCINATION TABLE (for reference)
SELECT *
FROM CovidVaccinations;

-- EXPLORING INDONESIA PERFORMANCE IN HANDLING COVID

--COVID TOTAL CASES PER POPULATION IN INDONESIA
--Asia
SELECT a.location, AVG(a.cases_percentage) cases_per_population_percentage 
FROM
	(
	SELECT continent, location, date, population, (total_cases/population)*100 cases_percentage
	FROM CovidDeaths
	)a
WHERE a.continent IS NOT NULL
AND a.continent = 'Asia'
GROUP BY a.location
ORDER BY AVG(a.cases_percentage) DESC
--RANK 29 In the world (0.61%)

SELECT a.location, AVG(a.cases_percentage) cases_per_population_percentage 
FROM
	(
	SELECT continent, location, date, population, (total_cases/population)*100 cases_percentage
	FROM CovidDeaths
	)a
WHERE a.continent IS NOT NULL
GROUP BY a.location
ORDER BY AVG(a.cases_percentage) DESC
--Rank 139 in the world (0.61%)

-- COVID DEATH PERCENTAGE PER POPULATION IN INDONESIA
SELECT location, date, population, total_cases, CAST(total_deaths AS int) total_deaths,
		(CONVERT(int, total_deaths)/total_cases)*100 AS deathpercentage
FROM CovidDeaths
WHERE location = 'Indonesia'
ORDER BY location, date;

-- HIGHEST DEATH PERCENTAGE PER POPULATION IN THE WORLD & ASIA
--ASIA
WITH HighestDeathPercentage (Continent, Location, Date, Population, TotalCase, TotalDeath, DeathPercentage)
AS(
SELECT continent, location, date, population, total_cases, CAST(total_deaths AS int) total_deaths,
		(CONVERT(int, total_deaths)/total_cases)*100 AS deathpercentage
FROM CovidDeaths)
SELECT Location, AVG(DeathPercentage) AS AverageDeathPercentage, RANK() OVER(ORDER BY AVG(DeathPercentage) DESC) Rank
FROM HighestDeathPercentage
WHERE Continent = 'Asia'
GROUP BY Location
ORDER BY AVG(DeathPercentage) DESC;
--Rank 7th in Asia, and 2nd in Seouth East Asia (3.87%)

--WORLD
--CTE
WITH HighestDeathPercentage (Location, Date, Population, TotalCase, TotalDeath, DeathPercentage)
AS(
SELECT location, date, population, total_cases, CAST(total_deaths AS int) total_deaths,
		(CONVERT(int, total_deaths)/total_cases)*100 AS deathpercentage
FROM CovidDeaths)
SELECT Location, AVG(DeathPercentage) AS AverageDeathPercentage, RANK() OVER(ORDER BY AVG(DeathPercentage) DESC) Rank
FROM HighestDeathPercentage
GROUP BY Location
ORDER BY AVG(DeathPercentage) DESC;
-- Indonesia Rank 37th of Highest Average Death Percentage by Covid (3.87%)

--NEW CASES VS VACCINATION

--CREATE TEMP TABLE
DROP TABLE IF EXISTS #PeopleVaccinated
CREATE TABLE #PeopleVaccinated
(
location nvarchar(255),
date datetime,
population numeric,
new_test numeric,
vaccinated numeric
)
INSERT INTO #PeopleVaccinated
--Join Table CovidDeaths & CovidVaccination
SELECT dea.location, dea.date, dea.population,  vac.new_tests, SUM(CAST(vac.new_tests AS int))
		OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS total_vaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY location, date

SELECT *, (vaccinated/population)*100 AS VaccinatedPercentage
FROM #PeopleVaccinated;

--Highest Average Vaccinated
--World
SELECT location, AVG(vaccinated/population)*100 Vaccinated_Percentage
FROM #PeopleVaccinated
GROUP BY location
ORDER BY AVG(vaccinated/population)*100 DESC;
--Indonesia Rank 97 (5.51%)
