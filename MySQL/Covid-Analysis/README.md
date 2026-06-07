COVID-19 Global Epidemiology & Vaccination Analysis
Overview

This project analyzes global COVID-19 infection, mortality, and vaccination data using MySQL. The goal is to explore pandemic trends across countries and continents, measure infection and death rates, and evaluate vaccination progress worldwide.

The analysis combines epidemiological and vaccination datasets to generate insights into the impact of COVID-19 and the effectiveness of vaccination campaigns.

Dataset

The project uses two datasets:

coviddeaths

Contains COVID-19 statistics including:

Location
Date
Population
Total Cases
New Cases
Total Deaths
New Deaths
Continent
covidvaccination

Contains vaccination statistics including:

Location
Date
Population
Total Vaccinations
New Vaccinations
Project Objectives

The main objectives of this analysis are:

Measure infection rates across countries.
Analyze mortality rates associated with COVID-19.
Compare pandemic impact between continents.
Track global case and death trends over time.
Evaluate vaccination progress worldwide.
Calculate rolling vaccination totals using window functions.
Key Analysis Performed
Data Exploration
Record counts for each dataset.
Initial review of COVID-19 case and vaccination data.
Data validation and structure exploration.
Infection Analysis
Infection rate relative to population.
Highest infection rates by country.
Total cases across locations and dates.
Mortality Analysis
Death rate per confirmed case.
Death rate relative to population.
Countries with the highest mortality rates.
Continents with the highest number of deaths.
Global Trend Analysis
Daily global cases and deaths.
Global death rate over time.
Comparison of pandemic progression across regions.
Vaccination Analysis
Vaccination rate by country.
Total vaccinated population.
Vaccination progress over time.
Advanced SQL Analysis
INNER JOIN operations between datasets.
Window Functions for rolling vaccination totals.
Common Table Expressions (CTEs).
Running cumulative calculations.
Percentage calculations based on population.
SQL Concepts Used

This project demonstrates:

SELECT Statements
Aggregate Functions (SUM, MAX, COUNT)
GROUP BY
ORDER BY
INNER JOIN
Common Table Expressions (CTE)
Window Functions
PARTITION BY
Running Totals
Date-Based Analysis
Percentage Calculations
Business Questions Answered

The analysis addresses questions such as:

Which countries experienced the highest infection rates?
Which countries had the highest mortality rates?
How did COVID-19 affect different continents?
What was the global death rate throughout the pandemic?
Which countries achieved the highest vaccination coverage?
How quickly were vaccination campaigns implemented?
Sample Insights
Comparison of infection rates across countries.
Identification of regions with the highest COVID-19 impact.
Trends in global mortality over time.
Vaccination progress and coverage rates by country.
Relationship between vaccination rollout and population size.
Tools Used
MySQL
SQL
Window Functions
CTEs
Data Analysis
Skills Demonstrated
Data Exploration
Data Cleaning & Validation
SQL Query Optimization
Aggregation & Grouping
Time-Series Analysis
Epidemiological Data Analysis
Business Intelligence Thinking
