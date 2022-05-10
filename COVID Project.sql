Select * 
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4


-- Select Data that we are going to be using
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


-- Looking at Total Cases vs Total Deaths
-- Shows the liklihood of dying if you contract covid in the United States
Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2


-- Looking at Total Cases vs. Population
-- Shows what percentage of population got Covid
Select Location, date, population, total_cases, (total_cases/population)*100 as ContractPercentage
From PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2


-- Looking at Countries with Highest Infection Rate compared to Population
Select Location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as ContractPercentage
From PortfolioProject..CovidDeaths
where continent is not null
group by location, population
order by ContractPercentage desc


-- Showing Countries with Highest Death Count per Population
Select Location, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT
-- Showing Countries with Highest Death Count per Population
Select continent, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc


-- Total death percentage grouped by date
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,  SUM(cast(new_deaths as int))/ SUM(new_cases)*100 as WorldDeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2

-- Total death percentage 
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,  SUM(cast(new_deaths as int))/ SUM(new_cases)*100 as WorldDeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


-- Looking at Total Population vs Vaccinations Using Use CTE 
With PopvsVac (Continent, Location, Date, Population, new_vaccinations, people_vacinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location,
	dea.date) as people_vacinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
Select *, (people_vacinated/Population)*100 as percentage_vaccinated
From PopvsVac



-- Creating View to store data for later visualizations
Create View PercentWolrdPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location,
	dea.date) as people_vacinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null


select * 
From PercentWolrdPopulationVaccinated


Create View TotalDeathCount as 
Select continent, max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
group by continent

select * 
From TotalDeathCount


Create View ContractPercentage as 
Select Location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as ContractPercentage
From PortfolioProject..CovidDeaths
where continent is not null
group by location, population

select * 
From ContractPercentage