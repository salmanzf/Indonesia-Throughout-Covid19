--For References
SELECT *
FROM CovidDeaths;

SELECT *
FROM CovidDeaths;


--For Visualization
--TABLE
SELECT SUM(population) population, SUM(total_cases) total_cases, (SUM(total_cases)/SUM(population))*100 total_cases_percentage
FROM CovidDeaths
WHERE continent IS NOT NULL;



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
SELECT a.location, SUM(a.population) population, SUM(CAST(b.total_vaccinations AS bigint)) total_vaccination,
		100*SUM(CAST(b.total_vaccinations AS bigint))/SUM(a.population) vaccination_rate
FROM CovidDeaths a, CovidVaccinations b
WHERE a.location = b.location
AND a.date = b.date
AND a.location IN ('Myanmar', 'Cambodia', 'East Timor', 'Indonesia', 'Laos', 'Malaysia', 'Philippines',
					'Singapore', 'Thailand', 'Vietnam')
AND a.continent IS NOT NULL
GROUP BY a.location

