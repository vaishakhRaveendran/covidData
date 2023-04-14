select population,total_cases,(total_cases/population)*100 as extend
from covid_death$
where location like '%india%'
order by new_cases,new_deaths

--country with the highest infection rate compared to population
select location,population,max(cast (total_cases as int)) as HighestInfectionCount,max((cast (total_cases as float)/population))*100 as extend
from covid_death$
where continent is not null
group by location,population
order by extend desc


--showing countries with highest death count
select location,max(cast (total_deaths as int)) as DeathCount
from covid_death$
where continent is not null
group by locatio
order by DeathCount desc


--visualising continents with highest death count
select location,max(cast (total_deaths as int)) as DeathCount
from covid_death$
where continent is  null
group by location
order by DeathCount desc



--joining the two tables
select *
from covid_death$ death
join covid_vaccination$ vaccination on
death.location=vaccination.location and death.date=vaccination.date

--visualising the vaccinations over each day
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from covid_death$ dea
join covid_vaccination$ vac on
dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3


select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint))over(partition by dea.location)
from covid_death$ dea
join covid_vaccination$ vac on
dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3



--partion the table after ordering by location and date.
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint))over(partition by dea.location order by dea.location,dea.date) as total_vaccination
from covid_death$ dea
join covid_vaccination$ vac on
dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3



--you cant use the column u creted so we are creating a cte 
with table1(continent,location,date,population,new_vaccinations,total_vaccination)
as(select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint))over(partition by dea.location order by dea.location,dea.date) as total_vaccination
from covid_death$ dea
join covid_vaccination$ vac on
dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
)
select *,(total_vaccination/population)*100 as percentage
from table1


---creating a view for later purpose
create view view1 as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint))over(partition by dea.location order by dea.location,dea.date) as total_vaccination
from covid_death$ dea
join covid_vaccination$ vac on
dea.location=vac.location and dea.date=vac.date
where dea.continent is not null