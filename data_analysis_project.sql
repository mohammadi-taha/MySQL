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

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging3;

SELECT *
FROM layoffs_staging3
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT *
FROM layoffs_staging3
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT *
FROM layoffs_staging3
ORDER BY company;






