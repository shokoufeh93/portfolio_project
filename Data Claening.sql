-- Data Cleaning
-- Remove duplicates
-- Standardize the data
-- Null values or blank values
-- Remove any columns


-- Creating Duplicate Tables 

select * from layoffs;
select * from layoff_stage;
select * from layoff_stage2;

create table layoff_stage
like layoffs;

insert into layoff_stage
select * from layoffs;


-- Remove duplicates


with CTE as 
(
select * ,
row_number()over(partition by company , location , industry, total_laid_off , percentage_laid_off , `date`,stage, 
country , funds_raised_millions) as row_num from layoff_stage
)
select * from CTE
where row_num > 1;



with CTE as 
(
select * ,
row_number()over(partition by company , location , industry, total_laid_off , percentage_laid_off ,
`date`,stage, country, funds_raised_millions) as row_num from layoff_stage
)
delete from CTE
where row_num > 1;

-- to delete duplicate data we need to create another table to solve the error in the above code

CREATE TABLE `layoff_stage2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` date DEFAULT NULL,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
   `row_num`   INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


insert into layoff_stage2
select * ,
row_number()over(partition by company , location , industry, total_laid_off , percentage_laid_off ,
`date`,stage, country, funds_raised_millions) as row_num from layoff_stage;


select * from layoff_stage2;


delete from layoff_stage2
where row_num > 1;

-- delete column

alter table layoff_stage2
drop column row_num;

-- Standardizing data


update layoff_stage2
set company = trim(company);


select distinct industry from layoff_stage2;


update layoff_stage2
set industry = 'Crypto'
where  industry like 'crypto%';


select * from layoff_stage2
where  industry = 'crypto';


select distinct country from layoff_stage2;

update layoff_stage2
set country = trim(trailing '.' from country);


-- date datatype is text and for timeseries analyze it should be date

-- one way

update layoff_stage2
set `date` = str_to_date(`date`, '%m/%d/%Y');

-- another way

alter table layoff_stage2
modify `date` date;

-- Null and Blank values


select *  from  layoff_stage2

where total_laid_off is null or total_laid_off  = ''
and percentage_laid_off is null or percentage_laid_off  = ''
and funds_raised_millions is null or funds_raised_millions = '';


select *  from  layoff_stage2
where industry is null  or industry = '';


update layoff_stage2
set industry = 'Null'
where industry = '';

-- the written below is reffer to issue about same companies with same name with null or blank values and some of them with values 

select * from  layoff_stage2 ls1
join layoff_stage2 ls2 on ls1.company = ls2.company
where (ls1.industry is null or ls1.industry = '')
and ls2.industry is not null;


SELECT company, industry from layoff_stage2
where company like 'Air%';


update layoff_stage2 ls1
join layoff_stage2 ls2 on ls1.company = ls2.company
set ls1.industry = ls2.industry
where ls1.industry is null
and ls2.industry is not null;
