--select *
--from Portfolioprojects..CovidDeaths
--where continent is not null

--select *
--from Portfolioprojects..CovidVaccinations

--select location, date, total_cases, new_cases, total_deaths, population
--from Portfolioprojects..CovidDeaths
-- where continent is not null
--order by 1,2

-- looking at total cases vs deaths
-- shows the likelihood of death by covid in a country
--select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
--from Portfolioprojects..CovidDeaths
--where location like '%state%'
--order by 1,2

--looking at total cases vs population
--select location, date, total_cases, population, (total_cases/population)*100 as InfectedPercentage
--from Portfolioprojects..CovidDeaths
----where location like '%state%'
--order by 1,2

--looking at countries with highest infeccction rate compared to population
--select location, max(total_cases) as HighestInfectionCount, population, max((total_cases/population))*100 as infectedPercentage
--from Portfolioprojects..CovidDeaths
----where location like '%state%'
--group by location, population
--order by infectedPercentage desc

--showing countries with highest death counth per population
--select location, max(cast(total_deaths as int)) as totalDeathCount
--from Portfolioprojects..CovidDeaths
----where location like '%state%' 
--where continent is not null
--group by location
--order by totalDeathCount desc

--lets break it down by continent
--select location, max(cast(total_deaths as int)) as totalDeathCount
--from Portfolioprojects..CovidDeaths
----where location like '%state%' 
--where continent is not null
--group by location
--order by totalDeathCount desc

--global numbers, the datatype we are using is float so we need to use casting to convert  into int and solve the query
--select sum(new_cases) as total_Cases, sum(cast (new_deaths as int))  as total_deaths, sum (cast(new_deaths as int))/sum (new_cases) *100 as deathPercentage
--from Portfolioprojects..CovidDeaths
----where location like '%state%' 
--where continent is not null
----group by date
--order by 1,2

--select date, sum(new_cases) as total_Cases, sum(cast (new_deaths as int))  as total_deaths, sum (cast(new_deaths as int))/sum (new_cases) *100 as deathPercentage
--from Portfolioprojects..CovidDeaths
----where location like '%state%' 
--where continent is not null
--group by date
--order by 1,2

--looking at total population vs vaccination
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)
--as rollingVaccinated
--from Portfolioprojects..CovidDeaths dea
--join Portfolioprojects..CovidVaccinations vac
--	on dea.location = vac.location 
--	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

--Using CTE
--with PopvsVac (continent, location, date, population, new_vaccinations, rollingVaccinated)
--as 
--(
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)
--as rollingVaccinated
--from Portfolioprojects..CovidDeaths dea
--join Portfolioprojects..CovidVaccinations vac
--	on dea.location = vac.location 
--	and dea.date = vac.date
--where dea.continent is not null
----order by 2,3
--)
--select *, (rollingVaccinated/population)*100
--from PopvsVac

--Using temp table

--Drop table if exists #percentPeopleVaccinated
--create table #percentPeopleVaccinated
--(
--continent nvarchar(255), location nvarchar(255), date datetime, population numeric, new_vaccinations numeric, rollingVaccinated numeric
--)

--insert into #percentPeopleVaccinated
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)
--as rollingVaccinated
--from Portfolioprojects..CovidDeaths dea
--join Portfolioprojects..CovidVaccinations vac
--	on dea.location = vac.location 
--	and dea.date = vac.date
--where dea.continent is not null
----order by 2,3
--select *, (rollingVaccinated/population)*100
--from #percentPeopleVaccinated

--creating view to store datat for later visualisation 
create view percentPopulatedVaccination as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)
as rollingVaccinated
from Portfolioprojects..CovidDeaths dea
join Portfolioprojects..CovidVaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
order by 2,3
