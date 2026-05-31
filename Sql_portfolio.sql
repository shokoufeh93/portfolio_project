select count(*) from coviddeaths;
select count(*) from covidvacsination;

select location, `date`, total_cases, new_cases, total_deaths, population
from coviddeaths
order by 1,2;


-- rate of death per cases for different locations

select location, `date`, total_deaths, total_cases ,  round(total_deaths/total_cases , 2) as per_cas_dea , population
from coviddeaths
where round(total_cases / total_deaths, 2) is not null and location = 'united kingdom'
order by 1,2;

select location, `date`, total_deaths, total_cases ,  round(total_deaths/total_cases , 2) as per_cas_dea , population
from coviddeaths
where round(total_cases / total_deaths, 2) is not null and location like '%states%'
order by `date` desc;



-- rate of new cases based on population

select location, `date`, total_cases  , population, round(total_cases/ population , 2) as per_cas_pop
from coviddeaths
where round(total_cases /  population, 2) is not null and location = 'united kingdom'
order by `date` ;



-- max rate of infection

select location,  population, total_cases, max(total_cases),  max(round(total_cases / population, 2))  as per_inf_pop
from coviddeaths
group by location,  population,total_cases
order by  per_inf_pop desc ;



-- max rate of death based on location and population

select location,  population, max(total_deaths), max(round(total_deaths / population, 2)) as death_per_pop
from coviddeaths
group by location,  population
order by  death_per_pop desc ;



-- max number of death based on location and population

select location,  population, max(total_deaths) as death_per_pop
from coviddeaths
where continent is not null
group by location,  population
order by  death_per_pop desc ;



-- max number of death based on continent

select continent,  max(total_deaths) as highest_death
from coviddeaths
where continent is not null
group by continent
order by  highest_death desc ;



-- global number of death and cases

select  `date`, total_deaths, total_cases ,  round(total_deaths/total_cases , 2) as global_rate
from coviddeaths
where round(total_cases / total_deaths, 2) is not null
order by 1,2;


-- global number of new_death and new_cases

select  `date`,sum(new_cases), sum(new_deaths)
from coviddeaths
where new_cases is not null and new_deaths is not null
group by `date`
order by 1,2;


-- global rate of new_death and new_cases

select  `date`, sum(new_cases), sum(new_deaths), round(sum(new_deaths)/(new_cases), 2) as global_death
from coviddeaths
where new_cases is not null and new_deaths is not null
group by `date`, new_cases, new_deaths
order by 1,2;



-- joining two tables

select * from coviddeaths cd
join covidvacsination cv on cd.location = cv.location
and cd.`date` = cv.`date`;



-- total population had been vaccinated(rolling_total)

select cd.continent, cd.location, cd.`date`, cv.population, cv.total_vaccinations , 
round(cv.total_vaccinations / cv.population , 2) as rete_of_vac from coviddeaths cd
join covidvacsination cv on cd.location = cv.location
and cd.`date` = cv.`date`
where cv.total_vaccinations is not null and cd.continent is not null
order by 1, 2;


-- total population had been vaccinated(rolling_total)(line by line)

select cd.continent, cd.location, cd.`date`, cv.new_vaccinations,
sum(cv.new_vaccinations) over(partition by cd.location order by cd.location, cd.`date`) as sum_of_vac
from coviddeaths cd
join covidvacsination cv on cd.location = cv.location
and cd.`date` = cv.`date`
where cv.total_vaccinations is not null and cd.continent is not null
and cv.new_vaccinations is not null
order by 2, 3;



-- CTE helps in calculation on newly created complex columns(in this example sum_roll )

with cte (continent, location, `date`, new_vaccinations, population, sum_roll) as
(
select cd.continent, cd.location, cd.`date`, cv.new_vaccinations, cd.population,
sum(cv.new_vaccinations) over(partition by cd.location order by cd.location, cd.`date`) as sum_roll
from coviddeaths cd
join covidvacsination cv on cd.location = cv.location
and cd.`date` = cv.`date`
where cv.total_vaccinations is not null and cd.continent is not null
and cv.new_vaccinations is not null
) 
select *,  round(sum_roll/ population, 2) as high from cte;



CREATE view cte as
select cd.continent, cd.location, cd.`date`, cv.new_vaccinations, cd.population,
sum(cv.new_vaccinations) over(partition by cd.location order by cd.location, cd.`date`) as sum_roll
from coviddeaths cd
join covidvacsination cv on cd.location = cv.location
and cd.`date` = cv.`date`
where cv.total_vaccinations is not null and cd.continent is not null
and cv.new_vaccinations is not null;










