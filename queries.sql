--Q1-Create a query that displays the name and category of the movie, rental duration and rental date, provided shows the maximum category viewed

SELECT DISTINCT
    f.title,
    c.name,
    f.rental_duration,
    r.rental_date,
    ntile(4) OVER (PARTITION BY f.rental_duration) quartile
FROM
    film f
    JOIN film_category fc ON fc.film_id = f.film_id
    JOIN category c ON fc.category_id = c.category_id
    JOIN inventory i ON i.film_id = f.film_id
    JOIN rental r ON r.inventory_id = i.inventory_id
WHERE
    c.name IN ('Animation', 'Children', 'Comedy', 'Family', 'Games', 'Music')
ORDER BY
    rental_duration DESC
LIMIT 800;

--Q2-Create a query display sales for Store 1, Store 2, and Count Rental ID

 SELECT
     DATE_TRUNC('month', r.rental_date) AS month,
     i.store_id,
     COUNT(rental_id) AS total
 FROM
     rental r
     JOIN inventory i ON i.inventory_id = r.inventory_id
 GROUP BY
     1,
     2
 ORDER BY
     3 DESC;


--Q3- Create a query that displays movie ID, movie name, description, payment amount,
--and sub-query showing maximum length*/

SELECT
    f.film_id,
    f.title,
    f.description,
    MAX(length) AS max_length,
    p.amount
FROM
    film AS f
    JOIN inventory AS i ON i.film_id = f.film_id
    JOIN rental AS r ON r.inventory_id = i.inventory_id
    JOIN payment AS p ON p.rental_id = r.rental_id
WHERE
    length = (
        SELECT
            MAX(length)
        FROM
            film)
GROUP BY
    1,
    2,
    3,
    5;


--Q4- Create a query that displays the name of the movie, its release date, its category and its rating, and there is a case statement
 --explaining the classification of the movie if G puts a phrase suitable for all ages , PG puts parental guidance suggested and
  --PG-13 puts parents strongly cautioned, If the condition does not apply, put a phrase for adult or requires accompanying parent

  SELECT
      f.title,
      r.rental_date,
      c.name,
      f.rating,
      CASE f.rating
      WHEN 'G' THEN
          'for all ages'
      WHEN 'PG' THEN
          'parental guidance suggested'
      WHEN 'PG-13' THEN
          'parents strongly cautioned'
      ELSE
          'for adult or requires accompanying parent'
      END description
  FROM
      category AS c
      JOIN film_category AS fc ON fc.category_id = c.category_id
      JOIN film AS f ON fc.film_id = f.film_id
      JOIN inventory i ON i.film_id = f.film_id
      JOIN rental r ON r.inventory_id = i.inventory_id
  WHERE
      rental_date = (
          SELECT
              max(rental_date)
          FROM
              rental)
  ORDER BY
      title
  LIMIT 900;
