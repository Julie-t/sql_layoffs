--Exploratory Data analysis

SELECT *
FROM layoffs_staging2

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC


SELECT *
FROM layoffs_staging2


SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC

SELECT SUBSTRING(`date`,1,7) AS `month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1

--rolling_totals
WITH Rolling_Totals  AS
(
	SELECT SUBSTRING(`date`,1,7) AS `month`, SUM(total_laid_off)  AS total_layoffs
	FROM layoffs_staging2
	WHERE SUBSTRING(`date`,1,7) IS NOT NULL
	GROUP BY `month`
	ORDER BY 1 ASC
)
SELECT `month`, total_layoffs,
SUM(total_layoffs) OVER(ORDER BY `month`) AS rolling_total
FROM Rolling_Totals


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 ASC


WITH Company_year (company, years, total_laid_off) AS
(
	SELECT company, YEAR(`date`), SUM(total_laid_off)
	FROM layoffs_staging2
	GROUP BY company,YEAR(`date`)
),
  Company_Year_Rank AS
	(SELECT *,
	DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off) AS ranking
	FROM Company_year
	WHERE years IS NOT NULL
    AND total_laid_off IS NOT NULL
)
SELECT *
FROM Company_year_Rank
WHERE Ranking <= 5
