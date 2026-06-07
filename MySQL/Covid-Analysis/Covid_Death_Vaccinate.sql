
--  Global COVID-19 Epidemiology & Vaccination Data Analysis


-- Initial Data Overview
SELECT COUNT(*) FROM coviddeaths;
SELECT COUNT(*) FROM covidvacsination;

SELECT location, `date`, total_cases, new_cases, total_deaths, population
FROM coviddeaths
ORDER BY 1, 2;


--  INFECTION & MORTALITY RATES ANALYSIS


-- Rate of death per case (Likelihood of dying if contracting COVID-19)
SELECT location, `date`, total_deaths, total_cases, ROUND(total_deaths/total_cases, 2) AS per_cas_dea, population
FROM coviddeaths
WHERE ROUND(total_cases / total_deaths, 2) IS NOT NULL AND location = 'united kingdom'
ORDER BY 1, 2;

-- Rate of new cases based on population (Infection Rate)
SELECT location, `date`, total_cases, population, ROUND(total_cases/population, 2) AS per_cas_pop
FROM coviddeaths
WHERE ROUND(total_cases / population, 2) IS NOT NULL AND location = 'united kingdom'
ORDER BY `date`;

-- Max rate of infection based on location and population
SELECT location, population, total_cases, MAX(total_cases), MAX(ROUND(total_cases / population, 2)) AS per_inf_pop
FROM coviddeaths
GROUP BY location, population, total_cases
ORDER BY per_inf_pop DESC;

-- Max number and rate of death based on location and population
SELECT location, population, MAX(total_deaths), MAX(ROUND(total_deaths / population, 2)) AS death_per_pop
FROM coviddeaths
GROUP BY location, population
ORDER BY death_per_pop DESC;

-- GLOBAL & CONTINENTAL AGGREGATIONS


-- Max number of deaths based on continent
SELECT continent, MAX(total_deaths) AS highest_death
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY highest_death DESC;

-- Global number of deaths and cases (Daily Global Rate)
SELECT `date`, total_deaths, total_cases, ROUND(total_deaths/total_cases, 2) AS global_rate
FROM coviddeaths
WHERE ROUND(total_cases / total_deaths, 2) IS NOT NULL
ORDER BY 1, 2;

-- Global rate of new deaths and new cases
SELECT `date`, SUM(new_cases) AS total_new_cases, SUM(new_deaths) AS total_new_deaths, 
ROUND(SUM(new_deaths) / SUM(new_cases), 2) AS global_death_rate
FROM coviddeaths
WHERE new_cases IS NOT NULL AND new_deaths IS NOT NULL
GROUP BY `date`
ORDER BY 1, 2;

-- ADVANCED JOINS & VACCINATION ROLLING TOTALS


-- Total population that has been vaccinated (Rate of Vaccination)
SELECT cd.continent, cd.location, cd.`date`, cv.population, cv.total_vaccinations, 
ROUND(cv.total_vaccinations / cv.population, 2) AS rate_of_vac 
FROM coviddeaths cd
JOIN covidvacsination cv ON cd.location = cv.location AND cd.`date` = cv.`date`
WHERE cv.total_vaccinations IS NOT NULL AND cd.continent IS NOT NULL
ORDER BY 1, 2;

-- Total population vaccinated line by line (Rolling Total using Window Function)
SELECT cd.continent, cd.location, cd.`date`, cv.new_vaccinations,
SUM(cv.new_vaccinations) OVER(PARTITION BY cd.location ORDER BY cd.location, cd.`date`) AS sum_of_vac
FROM coviddeaths cd
JOIN covidvacsination cv ON cd.location = cv.location AND cd.`date` = cv.`date`
WHERE cv.total_vaccinations IS NOT NULL AND cd.continent IS NOT NULL AND cv.new_vaccinations IS NOT NULL
ORDER BY 2, 3;

-- Utilizing CTE to perform calculations on the newly created complex column (sum_roll)
WITH cte AS (
    SELECT cd.continent, cd.location, cd.`date`, cv.new_vaccinations, cd.population,
    SUM(cv.new_vaccinations) OVER(PARTITION BY cd.location ORDER BY cd.location, cd.`date`) AS sum_roll
    FROM coviddeaths cd
    JOIN covidvacsination cv ON cd.location = cv.location AND cd.`date` = cv.`date`
    WHERE cv.total_vaccinations IS NOT NULL AND cd.continent IS NOT NULL AND cv.new_vaccinations IS NOT NULL
)
SELECT *, ROUND(sum_roll / population, 2) AS high 
FROM cte;