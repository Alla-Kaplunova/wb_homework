
SELECT s1.first_name, s1.last_name, s1.salary, s1.industry, s2.first_name AS name_highest_sal
FROM salary s1
JOIN (
    SELECT industry, MAX(salary) AS max_salary
    FROM salary
    GROUP BY industry
) AS max_salaries
ON s1.industry = max_salaries.industry AND s1.salary = max_salaries.max_salary;

SELECT s1.first_name, s1.last_name, s1.salary, s1.industry, s2.first_name AS name_lowest_sal
FROM salary s1
JOIN (
    SELECT industry, MIN(salary) AS min_salary
    FROM salary
    GROUP BY industry
) AS min_salaries
ON s1.industry = min_salaries.industry AND s1.salary = min_salaries.min_salary;

SELECT DISTINCT ON (industry) first_name, last_name, salary, industry, 
       first_name AS name_highest_sal
FROM (
    SELECT first_name, last_name, salary, industry,
           RANK() OVER (PARTITION BY industry ORDER BY salary DESC) AS rank
    FROM salary
) AS ranked
WHERE rank = 1;

SELECT DISTINCT ON (industry) first_name, last_name, salary, industry, 
       first_name AS name_lowest_sal
FROM (
    SELECT first_name, last_name, salary, industry,
           RANK() OVER (PARTITION BY industry ORDER BY salary ASC) AS rank
    FROM salary
) AS ranked
WHERE rank = 1;
