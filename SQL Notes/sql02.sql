--
-- QTM 385
-- Elements of Data Science
-- Prof.: Umberto Mignozzetti
--
-- SQL Class 02
--

-- Getting started
USE sakila;

-- Show tables
SHOW TABLES;

/* SELECT */
SELECT * FROM category;

-- Exercise: do the same with table language
SELECT * FROM language;

-- SELECT for some variables
SELECT name FROM category;

-- Exercise: select `language_id` and `name` from 
-- the table `language`
SELECT language_id, name FROM language;

-- SELECT with aliases
SELECT language_id,
  /*Creating a new variable called language_usage with the word common inside it*/
  'COMMON' AS language_usage, 
  /*Creating a new variable called long_pi_value with a new value*/
  language_id * 3.1415927 AS lang_pi_value,
  upper(name) AS language_name
  FROM language;

-- Aliasing the columns
SELECT category_id as id,
  name AS cat_name
  FROM category;

select * from film_actor;
-- SELECT and SELECT DISTINCT
SELECT actor_id 
  FROM film_actor 
  ORDER BY actor_id;

SELECT DISTINCT actor_id 
  FROM film_actor 
  ORDER BY actor_id;

-- Exercise: how many types of movies by rating we have? 
-- Hint: table film column rating
SELECT DISTINCT rating
	FROM film;

/* SELECT + WHERE */
SELECT title
  FROM film
  WHERE rating = 'G' AND 
  rental_duration >= 7;

SELECT title
  FROM film
  WHERE rating = 'G' OR
    rental_duration >= 7;

-- Exercise: select the title and rating for all 'R' rated movies.
SELECT title
	FROM film
	WHERE rating = 'R';

-- More complicated WHERE clauses:
SELECT title, rating, rental_duration
  FROM film
  WHERE 
    (rating = 'G' AND rental_duration >= 7) 
	OR 
	(rating = 'PG-13' AND rental_duration < 4);

-- Exercise: Select the title and rating for all 'R' with rental duration less than 5 days.
SELECT title, rating, rental_duration
  FROM film
  WHERE
	rental_duration<5 AND rating = 'R';

-- To simply count the number:
SELECT count(*)
  FROM film
  WHERE rating = 'G';

-- Exercise: count the number of 'R' rated movies.
SELECT count(*) as '# of R rated movies'
  FROM film
  WHERE rating = 'R';

-- SELECT + WHERE (range)
SELECT * FROM rental;

SELECT customer_id, rental_date
    FROM rental
    WHERE rental_date <= '2005-06-16'
      AND rental_date >= '2005-06-14';

-- Range using BETWEEN operator:
SELECT customer_id, rental_date
   FROM rental
   WHERE rental_date BETWEEN
      '2005-06-14' AND '2005-06-16';
      
SELECT customer_id, payment_date, amount
  FROM payment
  WHERE amount BETWEEN 10.0 AND 11.99;

-- Also works for strings:
SELECT last_name, first_name
  FROM customer
  WHERE last_name BETWEEN 'FA' AND 'FR';

-- Membership:
SELECT title, rating
  FROM film
  WHERE rating IN ('G','PG');

-- Exercise: select all movies PG-13 and R.
select title, rating
	FROM film
	WHERE rating in ('PG-13', 'R');

-- NOT IN:
SELECT title, rating
  FROM film
  WHERE rating NOT IN ('G','PG');

-- Exercise: select all but PG-13 or R rated movies.
answers_here

-- LIKE
SELECT title, rating
  FROM film
  WHERE title LIKE 'AM%';

-- Exercise: select all movies ending with 'T'.
answers_here

-- Wild card:
SELECT title, rating
  FROM film
  WHERE title LIKE 'S_E%';

/* Other queries */
-- LIMIT:
SELECT title, rating
  FROM film
  WHERE rating IN ('G','PG')
  LIMIT 10;

-- Exercise: select the first 20 PG-13 or R rated movies.
SELECT title, rating
	FROM film
    WHERE rating in ('PG-13', 'R')
    LIMIT 20;

-- COUNT:
SELECT COUNT(rating) as "# of rated films"
  FROM film;

SELECT COUNT(DISTINCT rating) as "# of Distinct films"
  FROM film;

-- Functions:
SELECT COUNT(amount), AVG(amount), MAX(amount), MIN(amount), SUM(amount)
  FROM payment;

-- ORDER BY:
SELECT first_name, last_name
  FROM actor
  ORDER BY last_name DESC;

-- Exercise: do the same ordering, without descending order.
SELECT first_name, last_name
	FROM actor;

-- GROUP BY:
SELECT rating, count(*)
  FROM film
  GROUP BY rating;

-- Exercise: compute the average payment and number rental frequency for each customer, 
-- ordering by the average payment.
SELECT avg(amount), customer_id
		FROM payment
        ORDER BY amount;


-- HAVING:
SELECT rating, 
  count(*) AS n_movies
  FROM film
  GROUP BY rating
  HAVING n_movies > 200;

-- Exercise: compute the average payment and 
-- number rental frequency for each customer, 
-- ordering by the average payment, having 
-- more than 30 rentals.
answers_here

/* That's all, folks! */