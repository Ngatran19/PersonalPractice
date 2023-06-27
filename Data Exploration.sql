use [project covid]
-- Select Data that we are going to be starting with
select location, date,population , total_cases , total_deaths
from CovidDeaths$ as d
where continent is not null 
order by 1,2 desc
go
-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
select location, date, population , (total_deaths/total_cases)*100 as percenDeadth
from CovidDeaths$
where continent is not null
order by 4 desc
go

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

select location, date , (total_cases/population)*100 as infectedpercentage
from CovidDeaths$
where continent is not null 
order by 1,2 desc
go

-- Countries with Highest Infection Rate compared to Population
select location, population ,max(total_cases), max((total_cases/population)*100 ) as infectedpercentage
from CovidDeaths$
where continent is not null 
group by location, population
order by 1,2 desc