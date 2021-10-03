Select * 
from PortfolioProject..['covid deaths']
where  continent is NOT NULL

order by 3,4

--Select * 
--from PortfolioProject..['covid Deaths']
--order by 3,4

-- secect the data we are going to use


Select Location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..['covid deaths']
where  continent is NOT NULL
order by 1,2



--looking at total cases  Vs total deaths
--percentage of Death if You contract Covid in India
Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..['covid deaths']
Where location like '%Indi%'
and continent is NOT NULL
order by 1,2



--Looking at Total cases vs Population
--shows what percentage of population gets covid

Select Location,date,population,total_cases,(total_cases/population)*100 as PercentageAffected
from PortfolioProject..['covid deaths']
Where location like '%Indi%'
and continent is NOT NULL
order by 1,2 

--looking at countries with highest infection rate
Select Location,population,MAX(total_cases) as HighestInfectionCount , MAX(total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..['covid deaths']
where  continent is NOT NULL
Group By location,population
order by PercentPopulationInfected desc


-- Showing the countries with Highest Death count per population
Select Location,MAX(cast(total_deaths AS int)) as TotalDeathCOunt
from PortfolioProject..['covid deaths']
where  continent is NOT NULL
Group By location
order by TotalDeathCOunt desc

--By continent



--Showing the continent with the highest  Death count pr population

Select continent,MAX(cast(total_deaths AS int)) as TotalDeathCOunt
from PortfolioProject..['covid deaths']
where  continent is NOT NULL
Group By continent
order by TotalDeathCOunt desc



--Global Numbers

Select SUM(new_cases) as totalCases ,SUM(cast(new_deaths as int )) as TotalDeaths,sum(cast(new_deaths as int))/sum(new_cases)*100 DeathPercentage
from PortfolioProject..['covid deaths']
--Where location like '%Indi%'
Where continent is NOT NULL
--Group by date
order by 1,2

-- looking at total population vs Vaccinations

select dea.continent,dea.location,dea.date, dea.population,vac.new_vaccinations
,Sum(convert(int,vac.new_vaccinations) ) OVER (partition By dea.location order by dea.location,dea.date) 
as RollingPeopleVaccinated
From PortfolioProject..['covid deaths'] dea
Join PortfolioProject..['covid Vaccination1$'] vac
   on dea.location=vac.location
   and dea.date=vac.date
where dea.continent is Not NULL
order by 2,3


-- USE CTE

with PopvsVac(continent,Location,Date, Population ,New_vaccinations,RollingPeopleVaccinated)
as (
select dea.continent,dea.location,dea.date, dea.population,vac.new_vaccinations
,Sum(convert(int,vac.new_vaccinations) ) OVER (partition By dea.location order by dea.location,dea.date) 
as RollingPeopleVaccinated
From PortfolioProject..['covid deaths'] dea
Join PortfolioProject..['covid Vaccination1$'] vac
   on dea.location=vac.location
   and dea.date=vac.date
where dea.continent is Not NULL
--order by 2,3
)
Select*,(RollingPeopleVaccinated/Population)*100
From PopvsVac





--TEMP TABLE
 DROP TABLE if exists #percentPopulationVaccinated
 create Table #percentPopulationVaccinated
 (
 continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )


insert Into #percentPopulationVaccinated
select dea.continent,dea.location,dea.date, dea.population,vac.new_vaccinations
,Sum(convert(int,vac.new_vaccinations) ) OVER (partition By dea.location order by dea.location,dea.date) 
as RollingPeopleVaccinated
From PortfolioProject..['covid deaths'] dea
Join PortfolioProject..['covid Vaccination1$'] vac
   on dea.location=vac.location
   and dea.date=vac.date
where dea.continent is Not NULL
--order by 2,3

Select*,(RollingPeopleVaccinated/Population)*100
From #percentPopulationVaccinated






   
--creating View to store data for later visualization

create view PercentPopulationVaccinated  as
select dea.continent,dea.location,dea.date, dea.population,vac.new_vaccinations
,Sum(convert(int,vac.new_vaccinations) ) OVER (partition By dea.location order by dea.location,dea.date) 
as RollingPeopleVaccinated
From PortfolioProject..['covid deaths'] dea
Join PortfolioProject..['covid Vaccination1$'] vac
   on dea.location=vac.location
   and dea.date=vac.date
where dea.continent is Not NULL
--order by 2,3


