--
-- QTM 385
-- Elements of Data Science
-- Prof.: Umberto Mignozzetti
--
-- SQL Class 05
--

-- Getting started
USE sakila;

-- Show tables
SHOW TABLES;

/* Subqueries */

-- Query within query. Example:
SELECT customer_id, first_name, last_name
    FROM customer
    WHERE customer_id = 
      (SELECT MAX(customer_id) 
       FROM customer);
       -- This works for any table, no matter the number of customers that you have. Subqueries are useful for when tables change
       -- This subquery selects the maximum customer id from the customer table
	   -- All subqueries are in parenthesis. IF you remove the parenthesis, it will not run!

SELECT * FROM customer;

-- And here is the result of the subquery:
SELECT MAX(customer_id) 
	FROM customer;

-- Exercise: do the same for the minimum customer id.
SELECT customer_id, first_name, last_name
    FROM customer
    WHERE customer_id = 
      (SELECT MIN(customer_id) 
       FROM customer);
       
       -- Subqueries can go anywhere: in the SELECT, FROM, or WHERE statements! 
       -- Just remember that they always go in parenthesis.
       -- Key characteristic about subqueries:
			-- non-correlated: A subqery that you can run if ran by itself.
            -- correlated: A subquery that depends on something from the entire subquery (that isnt clear) and doesnt stand by itself.

/* Correlated x non-correlated subqueries */

-- Noncorrelated subqueries: completely self-contained
SELECT city_id, city 
  FROM city 
  WHERE country_id <> 
    (SELECT country_id FROM country WHERE country = 'India');

-- Self-contained: nothing needed to execute it independently
SELECT country_id FROM country WHERE country = 'India';

-- Multirow subequery (fail):
SELECT city_id, city
  FROM city
  WHERE country_id <> -- Vectors use "IN" and "NOT IN"... so <> is not acceptable
						-- we use it to match if the variable is not in the column
    (SELECT country_id FROM country WHERE country <> 'India');

(SELECT country_id FROM country WHERE country <> 'India');

-- Multirow subequery (done right):
SELECT city_id, city, country_id
  FROM city
  WHERE country_id NOT IN
    (SELECT country_id FROM country WHERE country <> 'India');

-- Multirow subquery:
SELECT city_id, city
  FROM city
  WHERE country_id IN
  (SELECT country_id
    FROM country
    WHERE country IN ('Canada','Mexico'));

SELECT country_id, country
    FROM country
    WHERE country IN ('Canada','Mexico');
    
SELECT country_id, country
    FROM country
    WHERE country_id IN (20, 60);
    
-- Exercise: what are the cities not in Canada or Mexico?
SELECT city_id, city
  FROM city
  WHERE country_id IN
  (SELECT country_id
    FROM country
    WHERE country NOT IN ('Canada','Mexico'));

-- ALL operator: makes comparison between value and all values in set
-- 

-- All customers that never got a free rental:
SELECT first_name, last_name
  FROM customer
  WHERE customer_id <> ALL
    (SELECT customer_id
	FROM payment
    WHERE amount = 0);

-- The subquery is getting the customers that didn't pay anything for a rental.
(SELECT customer_id
	FROM payment
    WHERE amount = 0);
    
-- But if you don't like to use the ALL operator:
SELECT first_name, last_name
FROM customer
WHERE customer_id NOT IN
 (SELECT customer_id
  FROM payment
  WHERE amount = 0);

-- Be careful with null's: NULL values make the query return no values
SELECT first_name, last_name
  FROM customer
  WHERE customer_id NOT IN (122, 452, NULL);
  
-- ALL clause again:
-- Exercise: Read this query out loud. What does it do?
SELECT customer_id, count(*)
    FROM rental
    GROUP BY customer_id
    HAVING count(*) > ALL -- Asking for the people that rented more movies than every person in the US, Mexico and Canada.
     (SELECT count(*)
      FROM rental r
        INNER JOIN customer c
        ON r.customer_id = c.customer_id
        INNER JOIN address a
        ON c.address_id = a.address_id
        INNER JOIN city ct
        ON a.city_id = ct.city_id
        INNER JOIN country co
        ON ct.country_id = co.country_id
      WHERE co.country IN ('United States','Mexico','Canada')
      GROUP BY r.customer_id
      );

-- And the subquery:
SELECT r.customer_id, count(*), co.country
      FROM rental r
        INNER JOIN customer c
        ON r.customer_id = c.customer_id
        INNER JOIN address a
        ON c.address_id = a.address_id
        INNER JOIN city ct
        ON a.city_id = ct.city_id
        INNER JOIN country co
        ON ct.country_id = co.country_id
      WHERE co.country IN ('United States','Mexico','Canada')
      GROUP BY r.customer_id;

-- Exercise: Construct a query against the film table 
-- that uses a filter condition with a noncorrelated 
-- subquery against the category table to find all 
-- action films (category.name = 'Action').
SELECT * from category;

SELECT title from film
	WHERE film_id IN 
		(SELECT film_id FROM film_category
		WHERE category_id IN
			(SELECT category_id
			FROM category c
			WHERE c.name = 'Action'
            )
		);

SELECT film_id FROM film_category
	WHERE category = 'Action';

SELECT film_id FROM film_category
	WHERE category_id IN
		(SELECT category_id
		FROM category c
		WHERE c.name = 'Action');
    
SELECT category_id
	FROM category c
    WHERE (SELECT c.name = 'Action');
	-- Use this becasue it works when the table changes (Same reason as before)


-- Correlated subquery
-- Definition: queries that do NOT stand by themselves.

-- Example: containing query retrieves 
-- those customers who have rented exactly 20 films:
SELECT c.first_name, c.last_name
  FROM customer c
  WHERE 20 =
    (SELECT count(*) FROM rental r
    WHERE r.customer_id = c.customer_id
    );

-- If you try the subquery, you get an error:
SELECT count(*) FROM rental r
    WHERE r.customer_id = c.customer_id;

-- Exercise: retrieve customers with more than 25 rentals.
SELECT c.first_name, c.last_name
	FROM customer c
    WHERE 25 < 
		(SELECT count(*) FROM rental r
        WHERE r.customer_id = c.customer_id);
        
-- Exercise: Make this query noncorrelated
SELECT c.first_name, c.last_name
	FROM customer c
    WHERE 
		(SELECT customer_id, count(*) n_rentals 
			FROM rental
			GROUP BY customer_id
            HAVING n_rentals = 20);

(SELECT customer_id, count(*) n_rentals 
	FROM rental
	GROUP BY customer_id
    HAVING n_rentals = 20);
    
SELECT customer_id FROM (
SELECT customer_id, count(*) n_rentals FROM rental
	GROUP BY customer_id
    HAVING n_rentals = 20);
    
-- Warning about correlated subqueries: 
-- **they are computationally expensive.**

-- EXISTS operator: useful when the amount is not crucial
-- For example, how many customers rented before a date?
SELECT c.first_name, c.last_name
  FROM customer c
  WHERE EXISTS -- looking at the table. if the results are there then it will display, otherwise it wont
  (SELECT 1 FROM rental r -- looking for ppl that rented before 2005
    WHERE r.customer_id = c.customer_id
      AND date(r.rental_date) < '2005-05-25');

-- Note the 1. It can be anything. Will not change... We only are asking if it exists. The exists clasue matches if it exists and doesnt if not
SELECT c.first_name, c.last_name
  FROM customer c
  WHERE EXISTS
  (SELECT * FROM rental r
    WHERE r.customer_id = c.customer_id
      AND date(r.rental_date) < '2005-05-25');

-- Actually, speed changes.

-- Actor never appeared in R rated (NOT EXISTS clause):
SELECT a.first_name, a.last_name
  FROM actor a
  WHERE NOT EXISTS
  (SELECT 1
    FROM film_actor fa
      INNER JOIN film f ON f.film_id = fa.film_id
    WHERE fa.actor_id = a.actor_id
      AND f.rating = 'R');

-- Subqueries as data sources:
SELECT c.first_name, c.last_name, 
    pymnt.num_rentals, pymnt.tot_payments
  FROM customer c
    INNER JOIN
    (SELECT customer_id, 
      count(*) num_rentals, sum(amount) tot_payments
    FROM payment
    GROUP BY customer_id
    ) pymnt
    ON c.customer_id = pymnt.customer_id;

-- Exercise: is the subquery above a correlated or
-- noncorrelated subquery?


/* That's all, folks! */