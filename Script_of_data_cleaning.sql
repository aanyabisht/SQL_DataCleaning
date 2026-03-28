-- Data Cleaning

SELECT * 
FROM layoffs;
-- Removing Duplicates
-- Standardize the data
-- Null values or blank values
-- removing unnessary columns

-- Creating another table to preserve the raw data like copying the data from one to another
 CREATE TABLE layoffs_staging#will create the table and have the columns name
 LIKE layoffs;

 SELECT *
 FROM layoffs_staging;
 
 INSERT layoffs_staging#insert the value to this table
 SELECT * 
 FROM layoffs; 
 
 #Creating a id in this table for removing dublicates
 SELECT *,
 row_number() over(
 PARTITION BY company, industry,total_laid_off, percentage_laid_off,`date`) as row_num
 FROM layoffs_staging;
 
 with duplicates_cte as #you cannot update a cte like delete update insert
 (
 SELECT *,
 row_number() over( PARTITION BY company,location, industry,total_laid_off, percentage_laid_off,`date`,stage,
 country,funds_raised_millions) as row_num
 FROM layoffs_staging
)
select *
from duplicates_cte
where row_num>1; 

SELECT *
 FROM layoffs_staging
 where company='Casper';
 
 #right click on table in schema copy to clipboard create statement
 #paste it here to create another table
 CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT #using back tick we added this column
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * 
from layoffs_staging2;

#inserting value in the table from another
Insert into layoffs_staging2
SELECT *,
 row_number() over( PARTITION BY company,location, industry,total_laid_off, percentage_laid_off,`date`,stage,
 country,funds_raised_millions) as row_num
 FROM layoffs_staging;

select *
from layoffs_staging2;

DELETE #deleting dublicates rows now 
FROM layoffs_staging2
where row_num>1;

-- Standardizing data
#Standardize data of company
select TRIM(company)
from layoffs_staging2;

UPDATE layoffs_staging2
SET company= TRIM(company);

#standardize data of industry
update layoffs_staging2
set industry=trim(industry);

select distinct industry
from layoffs_staging2;

select *
from layoffs_staging2
where industry like 'Crypto%';

UPDATE layoffs_staging2
set industry ='Crypto'
where industry like 'Crypto%';

#Standardize the Location
select DISTINCT location
from layoffs_staging2
order by 1;

select *
from layoffs_staging2
where location like "%dorf" and company LIKE "Spring%";

UPDATE layoffs_staging2
SET location='Dusseldorf'
where location like "%dorf" and company LIKE "Spring%";

select *
from layoffs_staging2
where location like "%polis" and country like 'Bra%';

update layoffs_staging2
set location ='Minneapolis'
where location like "%polis" and country like 'Bra%';

update layoffs_staging2
set location=trim(location);


#country standardize

select distinct country
from layoffs_staging2
order by 1;

select *
from layoffs_staging2
where country like "%.";

update layoffs_staging2
set country ='United States'
where country like "%.";

update layoffs_staging2
set country= trim(country);

#Fixing date datatype and the data format
select `date`,
str_to_date(`date`, '%m/%d/%Y') #format m/d/Y
from layoffs_staging2;

update layoffs_staging2
set `date`=str_to_date(`date`, '%m/%d/%Y'); #ITS CHANGE THE FORMAT OF DATA

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE; #NOW the date column is DATE

select *
from layoffs_staging2;

#Dealing with Nulls values and blank values 

SELECT *
FROM layoffs_staging2
where total_laid_off is null and percentage_laid_off is null  ;

select *
from layoffs_staging2
where  industry is null or industry = '';

#Null value replacing
select *
from layoffs_staging2
where company='Carvana' and industry ='';


update layoffs_staging2
set industry ='Transportation'
where company='Carvana' and industry ='';

update layoffs_staging2
set industry ='Travel'
where company='Airbnb' and industry ='';

select *
from layoffs_staging2
where company='Juul' and industry ='';

update layoffs_staging2
set industry ='Consumer'
where company='Juul' and industry ='';

select *
from layoffs_staging2
where company="Bally's Interactive";


#Instead all these selection and finding we can use join
select *
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company =t2.company
where (t1.industry is null or t1.industry='')
AND t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company =t2.company
set t1.industry=t2.industry  
where (t1.industry is null or t1.industry='')
AND t2.industry is not null;
  
#DELETING NOT IMP DATA not good for visualization
DELETE
from layoffs_staging2
where   total_laid_off is null and percentage_laid_off is null;

alter table layoffs_staging2
drop column row_num;#now no need of row_num

select *
from layoffs_staging2;