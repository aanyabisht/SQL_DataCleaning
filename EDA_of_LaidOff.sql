-- EXPLORATORY DATA ANALYSIS

SELECT *
from layoffs_staging2;

#total laid of checking
select max(total_laid_off),max(percentage_laid_off)
from layoffs_staging2;

SELECT *
from layoffs_staging2
where percentage_laid_off=1
order by total_laid_off desc;

SELECT *
from layoffs_staging2
where percentage_laid_off=1
order by funds_raised_millions desc;

#checking laid off company-wise
SELECT company , sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select  min(`date`) ,max(`date`)
from layoffs_staging2;

#most industry affected in covid years
SELECT industry , sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

SELECT country , sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

SELECT YEAR(`date`) , sum(total_laid_off)
from layoffs_staging2
group by YEAR(`date`)
order by 1 desc;

SELECT stage , sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

select substring(`date`,1,7) as `Month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc;

#checking the laid off each month
with Rolling_total as
(
select substring(`date`,1,7) as `Month` , sum(total_laid_off) as total
from layoffs_staging2
where substring(`date`,1,7)  is not null
group by `Month`
order by 1 asc
)
select `Month`, total,
sum(total) over(order by `Month`) as rolling_total
from Rolling_total;

#top five most laid off company each years
with Company_year(company , years ,total_laid) as(
select company, year(`date`) , sum(total_laid_off)
from layoffs_staging2
group by company , year(`date`)
),
Company_year_rank as(
select *,
dense_rank() over(partition by years order by total_laid desc) as ranking
from Company_year
where years is not null
)
select *
from Company_year_rank
where ranking <=5;
;