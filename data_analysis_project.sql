-- checking duplicates data (a mistake from last project that appeared checking table's data)
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off, 'date',
stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging2
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `layoffs_staging3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging3
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off, 'date',
stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging3
WHERE row_num > 1;


-- removing duplicates data (a mistake from last project)
SET SQL_SAFE_UPDATES = 0;

DELETE
FROM layoffs_staging3
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 1;

-- checking if we clear duplicates data correctly:
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT
           CONCAT_WS('|',
               company,
               location,
               industry,
               total_laid_off,
               percentage_laid_off,
               date,
               stage,
               country,
               funds_raised_millions
           )
       ) AS distinct_rows
FROM layoffs_staging3;

-- removing row_num column:
ALTER TABLE layoffs_staging3
DROP row_num;


-- -------------------------------------------------------------------------------------
-- DATA ANALYSIS PROJECT

-- checking some info from table:

-- max and min counting of lay off:
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging3;

-- companies that totally closed with total laid off:
SELECT *
FROM layoffs_staging3
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- companies that totally closed with checking fund:
SELECT *
FROM layoffs_staging3
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- total laid off according to companies:
SELECT company, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY company
ORDER BY 2 DESC;

-- check date:
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging3;

-- total laid off according to industry:
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY industry
ORDER BY 2 DESC;

-- total laid off according to country:
SELECT country, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY country
ORDER BY 2 DESC;

-- total laid off according to year:
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- total laid off according to stage:
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY stage
ORDER BY 2 DESC;


-- checking the laid off according to month and year:
SELECT SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off)
FROM layoffs_staging3
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC;

-- rolling total laid off according to date:
WITH rolling_total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off) AS sum_laid_off
FROM layoffs_staging3
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC
)
SELECT `month`, sum_laid_off, 
SUM(sum_laid_off) OVER(ORDER BY `month`) AS rolling_total 
FROM rolling_total;


SELECT company, 
YEAR(`date`), 
SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC; 

-- checking top 5 laid off accoring to the year:
WITH company_year (company, years, total_laid_off) AS
(
SELECT company, 
YEAR(`date`), 
SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY company, YEAR(`date`)
), company_year_rank AS
(SELECT *, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE ranking <= 5;









