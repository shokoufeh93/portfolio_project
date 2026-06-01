
-- Project 1: Layoffs Data Cleaning & Exploratory Data Analysis (EDA)

-- PHASE 1: DATA STAGING & CLEANING
-- 

--  Create a staging table to preserve the original raw data
CREATE TABLE layoffs_stagging LIKE layoffs;

INSERT INTO layoffs_stagging
SELECT * FROM layoffs;

--  Identify duplicate records using Window Functions
WITH cte AS (
    SELECT *, ROW_NUMBER() OVER(
        PARTITION BY company, location, industry, total_laid_off, 
        percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
    FROM layoffs_stagging
)
SELECT * FROM cte WHERE row_num > 1;

--  Delete the identified duplicate records
WITH cte AS (
    SELECT *, ROW_NUMBER() OVER(
        PARTITION BY company, location, industry, total_laid_off, 
        percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
    FROM layoffs_stagging
)
DELETE FROM layoffs_stagging WHERE row_num > 1;

--  Standardize Date formatting and change data type
UPDATE layoffs
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs
MODIFY COLUMN `date` DATE;

-- ------------------------------------------------------------------------
-- EXPLORATORY DATA ANALYSIS (EDA)
-- ------------------------------------------------------------------------

-- Date range of the dataset
SELECT MIN(`date`), MAX(`date`) FROM layoffs;

-- Companies with the highest single-day layoffs
SELECT MAX(total_laid_off), MAX(percentage_laid_off) FROM layoffs;

-- Total laid off per company (Descending)
SELECT company, SUM(total_laid_off) 
FROM layoffs
WHERE total_laid_off IS NOT NULL
GROUP BY company
ORDER BY SUM(total_laid_off) DESC;

-- Total laid off per industry
SELECT industry, SUM(total_laid_off) 
FROM layoffs
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC;

-- Total laid off per country
SELECT country, SUM(total_laid_off) 
FROM layoffs
GROUP BY country
ORDER BY SUM(total_laid_off) DESC;

-- Total laid off per year
SELECT YEAR(`date`) AS year_, SUM(total_laid_off) 
FROM layoffs
GROUP BY YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC;

-- Investigating potential correlation between total laid off and funds raised
SELECT * FROM layoffs
WHERE percentage_laid_off = 1 AND total_laid_off IS NOT NULL
ORDER BY funds_raised_millions DESC;


-- ADVANCED AGGREGATIONS & WINDOW FUNCTIONS


-- Changes in total laid off month by month (Rolling Total)
WITH cte AS (
    SELECT SUBSTRING(`date`, 1, 7) AS y_m, SUM(total_laid_off) AS total_off 
    FROM layoffs
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY y_m 
)
SELECT y_m, total_off, SUM(total_off) OVER(ORDER BY y_m) AS rolling_total 
FROM cte;

-- Rolling total of laid off per company
WITH rolling_total AS (
    SELECT company, YEAR(`date`) AS year_, SUM(total_laid_off) AS com_laid_off 
    FROM layoffs
    WHERE total_laid_off IS NOT NULL
    GROUP BY company, YEAR(`date`) 
)
SELECT company, year_, com_laid_off, SUM(com_laid_off) OVER(ORDER BY company) AS rolling_total 
FROM rolling_total;

-- Top 5 ranked companies with the highest total laid off per year
WITH companies_laidoff AS (
    SELECT company, YEAR(`date`) AS year_, SUM(total_laid_off) AS com_laid_off 
    FROM layoffs
    WHERE total_laid_off IS NOT NULL AND YEAR(`date`) IS NOT NULL
    GROUP BY company, YEAR(`date`)
), companies_ranked AS (
    SELECT company, year_, com_laid_off, DENSE_RANK() OVER(PARTITION BY year_ ORDER BY com_laid_off DESC) AS laid_off_rank 
    FROM companies_laidoff 
)
SELECT * FROM companies_ranked WHERE laid_off_rank <= 5;

-- Top 5 ranked industries with the highest laid off per year
WITH industries_highest_laid_off AS (
    SELECT industry, YEAR(`date`) AS year_, SUM(total_laid_off) AS laid_off 
    FROM layoffs
    WHERE industry IS NOT NULL AND YEAR(`date`) IS NOT NULL
    GROUP BY industry, year_
), industry_ranking AS (
    SELECT industry, year_, laid_off, DENSE_RANK() OVER(PARTITION BY year_ ORDER BY laid_off DESC) AS industries_rank 
    FROM industries_highest_laid_off 
)
SELECT * FROM industry_ranking WHERE industries_rank <= 5;