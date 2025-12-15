-- making staging table:
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;


-- step(1) >> remove duplicates

-- find duplicates (using ROW_NUMBER and PARTITION BY all columns in a cte):
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off, 'date',
stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- check if we find duplicates truely:
SELECT *
FROM layoffs_staging
WHERE company = 'Cazoo';

-- make another staging table (just columns): copy to clipboard - create statement - paste it - change the name of table - *add the row_num column*
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
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

-- add date to new staging table:
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off, 'date',
stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2;

-- check duplicate data before deleting to be right to delete:
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- change the setting to get rid of error:
SET SQL_SAFE_UPDATES = 0;

-- deleting duplicate data using row_num > 1:
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- check are duplicates gone:
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- change the setting to default:
SET SQL_SAFE_UPDATES = 1;


-- step(1) >> standardize data

-- removing extra spaces from company column:
UPDATE layoffs_staging2
SET company = TRIM(company);

-- checking another column:
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

-- changing the name of same categories of industry:
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- double check:
SELECT *
FROM layoffs_staging2
WHERE industry = 'Crypto%';

-- changing the name of united states of country to be same:
UPDATE layoffs_staging2
SET country = 'United States'
WHERE industry LIKE 'United States%';

-- changing format and datatype of date column:
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;








