--
-- QTM 385
-- Elements of Data Science
-- Prof.: Umberto Mignozzetti
--
-- SQL Class 03
--

-- Getting started
USE sakila;

-- Show tables
SHOW TABLES;

/* Querying Multiple Tables */

-- Looking the info in customer
DESC customer;

-- Looking the info in address
DESC address;

-- Cartesian Product: ignores the common keys
SELECT c.first_name, c.last_name, a.address
    FROM customer c JOIN address a;
    
-- Seems like a normal table, but ordering it
-- shows its bad behavior:
SELECT c.first_name, c.last_name, a.address
    FROM customer AS c JOIN address AS a
    ORDER BY last_name, first_name;

-- Exerise: Language and Country Cartesian
DESC language;
DESC country;
SELECT l.language_id, l.name, c.country
	FROM language l JOIN country c;
			-- Does an inner join by default

/* INNER JOIN */
SELECT c.first_name, c.last_name, a.address
    FROM customer c INNER JOIN address a
	ON c.address_id = a.address_id
    ORDER BY last_name, first_name;

-- Exercise: create a table with staff name and amount paid by customer. Then, check up who is 
-- the employee that generated the maximum revenue.
desc staff;
desc payment;
SELECT s.first_name, s.last_name, sum(p.amount) AS Revenue
	FROM payment as p INNER JOIN staff as s
	ON p.staff_id = s.staff_id
    GROUP BY s.first_name, s.last_name
    ORDER BY Revenue;

-- Another way to do INNER JOINs:
SELECT c.first_name, c.last_name, a.address
  FROM customer c 
  INNER JOIN address a
    USING (address_id);
    
-- Exercise:
SELECT s.first_name, s.last_name, sum(p.amount) AS Revenue
	FROM payment as p INNER JOIN staff as s
		USING (staff_id)
    GROUP BY s.first_name, s.last_name
    ORDER BY Revenue;
    
-- Older JOINs: somewhat different way to do it
SELECT c.first_name, c.last_name, a.address
    FROM customer c, address a
    WHERE c.address_id = a.address_id;

-- Older JOINs: and can keep filtering...
SELECT c.first_name, c.last_name, a.address
    FROM customer c, address a
    WHERE c.address_id = a.address_id
      AND a.postal_code = 52137;

-- Exercise: Fix this query to use JOIN -- ON
SELECT c.first_name, c.last_name, a.address
    FROM customer c 
    JOIN address a
		ON c.address_id = a.address_id
    WHERE a.postal_code = 52137;
      
-- Joining more than two tables
DESC address;

DESC city;

SELECT c.first_name, c.last_name, a.address, ct.city
	FROM customer c
	INNER JOIN address a
	ON c.address_id = a.address_id
	INNER JOIN city ct
	ON a.city_id = ct.city_id;

-- STRAIGHT JOIN:
-- Use if the order of the operations do matter. Straight join enforces the order that you put your operations
-- Use when you are sure that the order you code in matters

SELECT STRAIGHT_JOIN c.first_name, c.last_name, ct.city
  FROM city ct
  INNER JOIN address a
  ON a.city_id = ct.city_id
  INNER JOIN customer c
  ON c.address_id = a.address_id;

-- Exercise: Add also country name to the previous table.
desc country;
desc city;
SELECT c.first_name, c.last_name, a.address, ct.city, co.country
	FROM customer c 
		INNER JOIN address a
		ON c.address_id = a.address_id
			INNER JOIN city ct
			ON a.city_id = ct.city_id
				JOIN country co
				ON co.country_id = ct.country_id
	ORDER BY c.last_name;

-- Join as a table:
SELECT c.first_name, c.last_name, addr.address, addr.city, addr.country
    FROM customer c
      INNER JOIN
	  (SELECT a.address_id, a.address, ct.city, co.country
		FROM address a
		INNER JOIN city ct
		ON a.city_id = ct.city_id
        JOIN country co
        ON co.country_id = ct.country_id
		WHERE a.district = 'California'
	  ) addr
	  ON c.address_id = addr.address_id;


-- And here is only the subquery that generates the table addr:
SELECT a.address_id, a.address, ct.city
	FROM address a
      INNER JOIN city ct
      ON a.city_id = ct.city_id
    WHERE a.district = 'California';

-- Using the same table more than once

-- Films that two actors appeared:
SELECT f.title
    FROM film f
      INNER JOIN film_actor fa
      ON f.film_id = fa.film_id
      INNER JOIN actor a
      ON fa.actor_id = a.actor_id
    WHERE ((a.first_name = 'CATE' AND a.last_name = 'MCQUEEN')
        OR (a.first_name = 'CUBA' AND a.last_name = 'BIRCH'));

-- But what if you want films that both actors appeared together?
SELECT f.title
     FROM film f
       INNER JOIN film_actor fa1
       ON f.film_id = fa1.film_id
       INNER JOIN actor a1
       ON fa1.actor_id = a1.actor_id
       INNER JOIN film_actor fa2
       ON f.film_id = fa2.film_id
       INNER JOIN actor a2
       ON fa2.actor_id = a2.actor_id
    WHERE (a1.first_name = 'CATE' AND a1.last_name = 'MCQUEEN')
      AND (a2.first_name = 'CUBA' AND a2.last_name = 'BIRCH');

-- Self Joins: when we join the table with itself!
CREATE TABLE my_film AS SELECT * FROM film;

ALTER TABLE my_film
  ADD COLUMN prequel_film_id INT;

SELECT special_features from my_film
WHERE title = 'FIDDLER LOST';

INSERT INTO my_film (film_id, title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating, special_features, prequel_film_id)
  VALUES (2345, 'FIDDLER LOST II', 'Another boring tale', 2007, 1, 4, 4.99, 75, 20.99, 'R', 'Deleted Scenes,Behind the Scenes', 312);

SELECT f.title, f_prnt.title prequel
    FROM my_film f
      INNER JOIN my_film f_prnt
      ON f_prnt.film_id = f.prequel_film_id
    WHERE f.prequel_film_id IS NOT NULL;

DROP TABLE my_film;

-- Exercise: Write a query that returns the title of every film in 
-- which an actor with the first name JOHN appeared.
answers_here;

/* RIGHT JOIN */
SELECT c.first_name, c.last_name, a.address
    FROM customer c 
    RIGHT JOIN address a
	ON c.address_id = a.address_id;

/* LEFT JOIN */
SELECT c.first_name, c.last_name, a.address
    FROM customer c 
    LEFT JOIN address a
	ON c.address_id = a.address_id;

/* That's all, folks! */