select * from layoffs
--Data Cleaning

--1. Create a staging table so as not to interfere with the raw dataset

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging

INSERT layoffs_staging
SELECT *
FROM layoffs;

--Removing duplicates
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;


WITH duplicate_cte AS
(
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

--creating 3rd table
ALTER TABLE layoffs_staging ADD row_num INT;

SELECT * 
FROM layoffs_staging

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
  `row_num` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
(company, location, industry, total_laid_off, percentage_laid_off, `date` , stage, country, funds_raised_millions, row_num)
SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2
WHERE row_num = 2

DELETE
FROM layoffs_staging2
WHERE row_num > 1

---Standardizing data
SELECT * 
FROM layoffs_staging2
--company
SELECT company
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

--industry
SELECT DISTINCT industry
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET  industry = 'Crypto'
WHERE industry like 'Crypto%';

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'crypto%';

SELECT DISTINCT country
FROM layoffs_staging2
order by 1

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%'

SELECT DISTINCT country, TRIM(trailing '.'from country)
FROM layoffs_staging2
ORDER BY 1

UPDATE layoffs_staging2
SET country = TRIM(trailing '.' FROM country)
WHERE country LIKE 'United States%';

SELECT  `date`
FROM layoffs_staging2

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y' )

ALTER TABLE layoffs_staging2 
MODIFY COLUMN `date` DATE;

SELECT * 
FROM layoffs_staging2

--removing nulls and blanks
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;



SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = ''


SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	 ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL


DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL

SELECT *
FROM layoffs_staging2

ALTER TABLE layoffs_staging2
DROP COLUMN row_num