SELECT CovidDeaths.continent, CovidDeaths.location, CovidDeaths.population, CovidDeaths.date,
		CovidDeaths.total_cases, CovidDeaths.new_cases, CovidDeaths.new_deaths, CovidDeaths.total_deaths,
		CovidVaccinations.total_vaccinations, CovidVaccinations.people_vaccinated,
		CovidVaccinations.people_fully_vaccinated
INTO CovidEffects
FROM CovidDeaths
JOIN CovidVaccinations ON CovidDeaths.continent=CovidVaccinations.continent AND CovidDeaths.location=CovidVaccinations.location
	AND CovidDeaths.date = CovidVaccinations.date