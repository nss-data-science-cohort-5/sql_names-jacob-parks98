SELECT *
FROM names
LIMIT 5;
-- 1. How many rows are in the names table?
SELECT COUNT(*)
FROM names;

-- There are 1957046 rows in the table

--2. How many total registered people appear in the dataset?
SELECT SUM(num_registered)
FROM names;
-- 351653025 total people are registered in the dataset

--3. Which name had the most appearances in a single year in the dataset?
SELECT *
FROM names
ORDER BY num_registered DESC
LIMIT 5;

-- Linda had the most appearances of any name in the dataset, in 1947.

--4. What range of years are included?
SELECT MIN(year), MAX(year)
FROM names;
--The range is from 1880 to 2018

--5. What year has the largest number of registrations?
SELECT year, SUM(num_registered)
FROM names
GROUP BY year
ORDER BY SUM(num_registered) DESC;
-- 1957 had the largest number of registrations in the dataset.

--6. How many different (distinct) names are contained in the dataset?
SELECT COUNT(DISTINCT name)
FROM names;
-- There are 98,400 distinct names in the dataset

--7. Are there more males or more females registered?
SELECT gender, SUM(num_registered)
FROM names
GROUP BY gender;
-- There are more males registered



--8. What are the most popular male and female names overall (i.e., the most total registrations)?
SELECT name, gender, SUM(num_registered)
FROM names
GROUP BY gender, name
ORDER BY SUM(num_registered) DESC;
-- James was the most popular male name, Mary was the most popular female name




/* 9. What are the most popular boy and girl names of the first decade of the 2000s
(2000 - 2009)? */
SELECT name, gender, SUM(num_registered)
FROM names
WHERE year BETWEEN 2000 AND 2009
GROUP BY name, gender
ORDER BY SUM(num_registered) DESC;
/* Jacob (the best name in the dataset) was the most popular boy name from 2000 to 2009
Emily was the most popular girl name from 2000 to 2009 */

--Bryan
select distinct name, gender, sum(num_registered) over (partition by name, gender) as total_registrations
from names
order by total_registrations desc

--Joshua
(SELECT gender, name, SUM(num_registered) AS name_total
FROM names
WHERE gender = 'F'
GROUP BY gender, name
ORDER BY name_total DESC
LIMIT 1)
UNION
(SELECT gender, name, SUM(num_registered) AS name_total
FROM names
WHERE gender = 'M'
GROUP BY gender, name
ORDER BY name_total DESC
LIMIT 1)


--10. Which year had the most variety in names (i.e. had the most distinct names)?
SELECT year, COUNT(DISTINCT name)
FROM names
GROUP BY year
ORDER BY COUNT(DISTINCT name) DESC;
-- 2008 had the most variety in names

--11. What is the most popular name for a girl that starts with the letter X?
SELECT name, SUM(num_registered)
FROM names
WHERE name LIKE 'X%'
AND gender = 'F'
GROUP BY name
ORDER BY SUM(num_registered) DESC;
-- Ximena was the most popular name for a girl that starts with X

/* 12. How many distinct names appear that start with a 'Q', but whose second
letter is not 'u'? */
SELECT COUNT(*)
FROM names
WHERE name LIKE 'Q%'
AND name NOT LIKE 'Qu%';

-- There are 333 names that start with Q but not Qu.

/*13. Which is the more popular spelling between "Stephen" and "Steven"? 
Use a single query to answer this question. */
SELECT name, SUM(num_registered)
FROM names
WHERE name = 'Steven' OR name = 'Stephen'
GROUP BY name;
-- Steven is a more popular spelling than Stephen

/* 14. What percentage of names are "unisex" - that is what percentage of names
have been used both for boys and for girls? */
SELECT name, COUNT(DISTINCT gender)
FROM names
GROUP BY name
HAVING COUNT(DISTINCT gender) = 2;

SELECT (10773.0/COUNT(DISTINCT name))*100
FROM names;

--10773 names are unisex, meaning that 10.9% of names are unisex.

--Chris
SELECT CAST(MIN(unisex_count) AS FLOAT) / CAST(MAX(unisex_count) AS FLOAT) * 100
FROM
(SELECT 
COUNT(*) AS unisex_count
FROM 
(SELECT name
FROM names
GROUP BY name
HAVING COUNT(DISTINCT gender) > 1) AS ut
UNION
SELECT 
COUNT(DISTINCT name) AS total_count
FROM names AS n) AS union_table;


--15. How many names have made an appearance in every single year since 1880?
SELECT COUNT(DISTINCT year)
FROM names;

SELECT name, COUNT(DISTINCT year)
FROM names
GROUP BY name
HAVING COUNT(DISTINCT year) = 139;

-- 921 names have made in appearance in every single year since 1880

--16. How many names have only appeared in one year?
SELECT name, COUNT(DISTINCT year)
FROM names
GROUP BY name
HAVING COUNT(DISTINCT year) = 1;

--21123 names have only appeared in one year.

--17. How many names only appeared in the 1950s?
SELECT name, MIN(year), MAX(year)
FROM names
GROUP BY name
HAVING (MIN(year) BETWEEN 1950 AND 1959)
AND (MAX(year) BETWEEN 1950 AND 1959);

--661 names appeared only in the 1950s

--18. How many names made their first appearance in the 2010s?
SELECT name, MIN(year)
FROM names
GROUP BY name
HAVING MIN(year) >= 2010;
-- 11270 names made their first appearance in the 2010s

--19. Find the names that have not be used in the longest.
SELECT name, MAX(year)
FROM names
GROUP BY name
ORDER BY MAX(year)
LIMIT 10;

/* Zilaph, Roll, Crete, Sip, Ng, Lelie, Ottillie, Byrde, Pembroke,
and Bengiman have not been used since the 1880s.*/

--20. What is the least popular name from my birth year, 1998?
SELECT name, SUM(num_registered)
FROM names
WHERE year = 1998
GROUP BY name
ORDER BY SUM(num_registered);
-- There is a 3823-way tie for first place, the first in the result set is Iker.

--Bonus, Are there more female or male names in 1998:
SELECT gender, SUM(num_registered)
FROM names
WHERE year = 1998
GROUP BY gender
ORDER BY SUM(num_registered) DESC;
--There were more male names from 1998.

-- In what years did the number of male registrations outnumber female registrations


-- BONUS
--1. Find the longest name contained in this dataset. What do you notice about the long names?
SELECT DISTINCT name, LENGTH(name) AS length
from names
ORDER BY LENGTH(name) DESC;

-- All of these names are compund names

--2. How many names are palindromes (i.e. read the same backwards and forwards, such as Bob and Elle)?
SELECT COUNT(DISTINCT name)
FROM names
WHERE LOWER(name) = REVERSE(LOWER(name)) AND name IS NOT NULL;

--137 names are palindromes

/* 3. Find all names that contain no vowels (for this question, we'll count a,e,i,o,u, and y as vowels).
(Hint: you might find this page helpful: https://www.postgresql.org/docs/8.3/functions-matching.html) */
SELECT COUNT(DISTINCT name), LENGTH(name)
FROM names
WHERE LOWER(name) SIMILAR TO '%(a|e|i|o|u|y)%' = False
ORDER BY LENGTH(name) DESC

--43 names have no vowels

-- Bryan, compared counts after replacing name
select distinct names_examined.name
from (select name, regexp_replace(lower(name), E'[aeiouy]', '', 'g') as modified_name from names) as names_examined
where length(names_examined.name) = length(names_examined.modified_name);




/*4. How many double-letter names show up in the dataset?
Double-letter means the same letter repeated back-to-back,
like Matthew or Aaron. Are there any triple-letter names? */

SELECT COUNT(DISTINCT name)
FROM names
WHERE LOWER(name) SIMILAR TO '%(aa|bb|cc|dd|ee|ff|gg|hh|ii|jj|kk|ll|mm|oo|pp|qq|rr|ss|tt|uu|vv|ww|xx|yy|zz)%';

--very questionable and inefficient, but I think there are 17,405 double letter names
-- joshua
SELECT DISTINCT name
FROM names
WHERE name ~* '.*(.)\1{1}.*';

/* 5. On question 17 of the first part of the exercise, 
you found names that only appeared in the 1950s. 
Now, find all names that did not appear in the 1950s but were used both before and after the 1950s.
We'll answer this question in two steps. 
a. First, write a query that returns all names that appeared during the 1950s.
b. Now, make use of this query along with the IN keyword in order the find all names that
did not appear in the 1950s but which were used both before and after the 1950s.*/

SELECT name, MIN(year), MAX(year)
FROM names
WHERE name NOT IN
(
	SELECT name
	FROM names
	GROUP BY name
	HAVING (MIN(year) BETWEEN 1950 AND 1959)
	AND (MAX(year) BETWEEN 1950 AND 1959) 
)
GROUP BY name
HAVING MIN(year) <1950 AND MAX(year) > 1959;

--14,548 names did not occur in the 50s

--Chris
SELECT COUNT(DISTINCT name)
FROM names
WHERE name NOT IN 
	(
		SELECT name
		FROM names
		GROUP BY name
		HAVING MIN(year) >= 1950
		AND MAX(year) <= 1959
	)
AND name IN
	(
		SELECT name
		FROM names
		GROUP BY name
		HAVING MIN(year) < 1950
		AND MAX(year) > 1959
	);

/* 6. In question 16, you found how many names appeared in only one year. Which year had the highest
number of names that only appeared once? */


