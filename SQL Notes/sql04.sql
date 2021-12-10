--
-- QTM 385
-- Elements of Data Science
-- Prof.: Umberto Mignozzetti
--
-- SQL Class 04
--

-- Getting started
USE sakila;

-- Show tables
SHOW TABLES;

/* Querying Multiple Tables */

-- Using the same table more than once
DESC film;
DESC film_actor;
DESC actor;

-- Films that two actors appeared:
SELECT f.title
    FROM film f 
    INNER JOIN film_actor fa
      ON f.film_id = fa.film_id
      INNER JOIN actor a
      ON fa.actor_id = a.actor_id
    WHERE ((a.first_name = 'CATE' AND a.last_name = 'MCQUEEN')
        OR (a.first_name = 'CUBA' AND a.last_name = 'BIRCH'));


-- Exercise: Join 3 names:
SELECT f.title
    FROM film f 
    INNER JOIN film_actor fa
      ON f.film_id = fa.film_id
      INNER JOIN actor a
      ON fa.actor_id = a.actor_id
    WHERE ((a.first_name = 'CATE' AND a.last_name = 'MCQUEEN')
        OR (a.first_name = 'CUBA' AND a.last_name = 'BIRCH')
        OR (a.first_name = 'WOODY' AND a.last_name = 'HOFFMAN'));

-- But what if you want films that both actors appeared together?
-- Create a copy of the table and filter seperately:

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

-- Exercise: Join 3 names
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
       INNER JOIN film_actor fa3
       ON f.film_id = fa3.film_id
	   INNER JOIN actor a3
       ON fa3.actor_id = a3.actor_id
    WHERE (a1.first_name = 'CATE' AND a1.last_name = 'MCQUEEN')
      AND (a2.first_name = 'CUBA' AND a2.last_name = 'BIRCH')
      AND (a3.first_name = 'ED' AND a3.last_name = 'CHASE');


-- Self Joins: when we join the table with itself!
CREATE TABLE my_film AS SELECT * FROM film;

ALTER TABLE my_film
  ADD COLUMN prequel_film_id INT;

SELECT special_features from my_film
WHERE title = 'FIDDLER LOST';

INSERT INTO my_film (film_id, title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating, special_features, prequel_film_id)
  VALUES (2345, 'FIDDLER LOST II', 'Another boring tale', 2007, 1, 4, 4.99, 75, 20.99, 'R', 'Deleted Scenes,Behind the Scenes', 312);

-- JOINING your table to itself, and then joining on a different variable
SELECT f.title, f_prnt.title prequel
    FROM my_film f
      INNER JOIN my_film f_prnt
      ON f_prnt.film_id = f.prequel_film_id
    WHERE f.prequel_film_id IS NOT NULL;

DROP TABLE my_film;

-- Exercise: Write a query that returns the title of every film in 
-- which an actor with the first name JOHN appeared.
SELECT f.title, f.rating, f.release_year
    FROM film f
      INNER JOIN film_actor fa
      ON f.film_id = fa.film_id
      INNER JOIN actor a
      ON fa.actor_id = a.actor_id
	WHERE a.first_name = "JOHN";

/* Set Theory */

-- UNION: allow us to combine multiple datasets
SELECT 1 num, 'abc' str
    UNION
	SELECT 9 num, 'xyz' str;
    
-- UNION: sorts and remove duplicates.
SELECT 1 num, 'abc' str
    UNION
    SELECT 1 num, 'abc' str;
		-- We end up with a table that only has one line. This is because UNION deletes duplicate entries.

-- or:
SELECT c.first_name, c.last_name
    FROM customer c
    WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
    UNION -- attention here!
    SELECT a.first_name, a.last_name
    FROM actor a
    WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';

-- UNION ALL: puts all together. (even if there are duplicates)
SELECT 1 num, 'abc' str
    UNION ALL
    SELECT 1 num, 'abc' str;

-- UNION ALL:
SELECT 'CUST' typ, c.first_name, c.last_name
    FROM customer c
    UNION ALL
    SELECT 'ACTR' typ, a.first_name, a.last_name
    FROM actor a
    ORDER BY first_name;

-- Another example of UNION and UNION ALL:
SELECT c.first_name, c.last_name
    FROM customer c
    WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
    UNION ALL -- attention here!
    SELECT a.first_name, a.last_name
    FROM actor a
    WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';
    
SELECT c.first_name, c.last_name
    FROM customer c
    WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
    UNION -- attention here!
    SELECT a.first_name, a.last_name
    FROM actor a
    WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';

-- Exercise: add the staff to the union all under 'STAF'
SELECT 'CUST' typ, c.first_name, c.last_name
    FROM customer c
    UNION ALL
    SELECT 'ACTR' typ, a.first_name, a.last_name
    FROM actor a
    UNION ALL
    SELECT 'STAF' typ, UPPER(s.first_name), UPPER(s.last_name)
    FROM staff s
    ORDER BY typ;
    -- Union does not keep track of variable names, or anything really
    -- Make sure the order of the variables are correct for your data.
    -- Union in the wrong place will ruin the dataset

/* INTERSECT */
-- Not implemented in mysql :(
-- Think of ways to get the intersection ;)

/* EXCEPT */
-- Not implemented in mysql :(
-- Think of ways to get the except ;)

/* GROUP BY again */

-- Not grouped
SELECT * FROM rental;
SELECT customer_id FROM rental;

-- Grouped
SELECT customer_id
    FROM rental
    GROUP BY customer_id;
        
-- Counting customers in rentals
SELECT customer_id, count(*)
    FROM rental
    GROUP BY customer_id;

-- Exercise: count actors in films... TRY TO GET THE FILM TITLES: Do an inner join
SELECT film_id, count(actor_id)
	FROM film_actor
    GROUP BY film_id;

-- It is also useful to order results (ORDER BY):
desc rental;

SELECT customer_id, count(*)
    FROM rental
    GROUP BY customer_id
    ORDER BY 2 DESC; -- the "2" is the position in the SELECT statement. Also order by using the actual var name.

-- HAVING: ABSOLUTELY NECESSARY WHEN USIG THE GROUP BY FUNCTION! THE FILTER IS DONE AFTER GROUPING!
-- HAVING ONLY EXISTS TO FILTER AFTER GROUPING
SELECT customer_id, count(*)
    FROM rental
    WHERE count(*) >= 40
    GROUP BY customer_id;

SELECT customer_id, count(*)
    FROM rental
    GROUP BY customer_id
		HAVING count(*) >= 40;

-- Exercise: compute the rental revenue for each movie
DESC rental; -- rental_id
DESC payment; -- rental_id

SELECT SUM(p.amount) revenue, r.inventory_id movie
	FROM payment p 
    INNER JOIN rental r
    ON p.rental_id = r.rental_id
    GROUP BY movie
    ORDER BY revenue DESC;

-- Grouping via expression:
SELECT extract(YEAR FROM rental_date) year, COUNT(*) how_many_rentals
    FROM rental
    GROUP BY extract(YEAR FROM rental_date);

SELECT extract(YEAR FROM rental_date) 
	FROM rental;
    
-- Multiple column grouping:
SELECT fa.actor_id, f.rating, count(*)
    FROM film_actor fa
      INNER JOIN film f
      ON fa.film_id = f.film_id
    GROUP BY fa.actor_id, f.rating
    ORDER BY 1,2;
    
-- Multiple grouping and filtering:
SELECT fa.actor_id, f.rating, count(*)
    FROM film_actor fa
      INNER JOIN film f
      ON fa.film_id = f.film_id
    WHERE f.rating IN ('G','PG')
    GROUP BY fa.actor_id, f.rating
    HAVING count(*) > 9;

-- Grouping WITH ROLLUP
SELECT fa.actor_id, f.rating, count(*)
    FROM film_actor fa
      INNER JOIN film f
      ON fa.film_id = f.film_id
    GROUP BY fa.actor_id, f.rating WITH ROLLUP
    ORDER BY 1,2;
    -- THIS SHOWS THE AGGT NUMBER OF MOVIES THAT THE ACTOR PARTICIPATED IN... leaves a null value in other columns
    
-- Exercise: Compute the revenue of movies by its language and rating
answers_here;

/* That's all, folks! */