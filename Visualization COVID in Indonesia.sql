--For References
SELECT *
FROM CovidDeaths;

SELECT *
FROM CovidDeaths;


--For Visualization
--TABLE
SELECT SUM(a.population) population, SUM(a.total_cases) total_cases, (SUM(a.total_cases)/SUM(a.population))*100 total_cases_percentage
FROM CovidDeaths a
INNER JOIN (
	SELECT location, MAX(date) MaxDate
	FROM CovidDeaths
	WHERE continent IS NOT NULL
	GROUP BY location
	) b
ON a.location=b.location AND a.date = b.MaxDate



--TIME SERIES
--Time Series Cases per Population Percentage
SELECT location, date, population, total_cases, (total_cases/population)*100 Cases_Percentage
FROM CovidDeaths
ORDER BY location, date;
--Time Series Death per Cases Percentage
SELECT location, date, population, total_cases, CONVERT(int, total_deaths) total_deaths, (CAST(total_deaths AS int)/total_cases)*100 Death_Percentage
FROM CovidDeaths
ORDER BY location, date;

--BAR CHART
--Bar Chart South East Asian Nation Total Vacc
--Without Explicit LEFT JOIN function
SELECT a.location, MAX(a.population) population, MAX(CAST(b.people_vaccinated AS bigint)) total_vaccination,
		100*MAX(CAST(b.people_vaccinated AS bigint))/MAX(a.population) vaccination_rate
FROM CovidDeaths a, CovidVaccinations b
WHERE a.location = b.location
AND a.date = b.date
AND a.location IN ('Myanmar', 'Cambodia', 'East Timor', 'Indonesia', 'Laos', 'Malaysia', 'Philippines',
					'Singapore', 'Thailand', 'Vietnam')
AND a.continent IS NOT NULL
GROUP BY a.location

