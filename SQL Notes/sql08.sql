--
-- QTM 385
-- Elements of Data Science
-- Prof.: Umberto Mignozzetti
--
-- SQL Class 08
--

-- Getting started
USE sakila;

-- Show tables
SHOW TABLES;

/* Practice */

-- 1. What are the names of all the languages in 
-- the database (sorted alphabetically)?
SELECT name
	FROM language
    ORDER BY name;

-- 2. Return the full names (first and last) 
-- of actors with “SON” in their last name, 
-- ordered by their first name.
SELECT CONCAT(first_name, ' ', last_name) as full_name
	FROM actor
	WHERE last_name LIKE '%SON%'
    ORDER BY first_name;

-- 3. Find all the addresses where the second 
-- address is not empty (i.e., contains some text), 
-- and return these second addresses sorted.
SELECT address2
	FROM address a
	WHERE (a.address2 IS NOT NULL)
	ORDER BY a.address;

-- 4. Return the first and last names of actors who played 
-- in a film involving a “Crocodile” and a “Shark”, along 
-- with the release year of the movie, sorted by the actors’ 
-- last names.


SELECT * FROM film;
SELECT * FROM film_actor;
SELECT * FROM actor;
SELECT * FROM film
	WHERE description LIKE '%CROCODILE%' 
    AND description LIKE '%SHARK%';
    
SELECT fa2.actor_id, f2.film_id, f2.release_year
	FROM film_actor fa2
    INNER JOIN film f2
		ON fa2.film_id = f2.film_id
	WHERE f2.description LIKE '%CROCODILE%'
		AND f2.description LIKE '%SHARK%';
-- WE need a multirow query (See class 5)
-- SELECT city_id, city
--   FROM city
--   WHERE country_id IN
--   (SELECT country_id
--     FROM country
--     WHERE country IN ('Canada','Mexico'));	

SELECT a.first_name, a.last_name, fa.release_year
	FROM actor AS a
	INNER JOIN
	(SELECT fa2.actor_id, f2.film_id, f2.release_year
	FROM film_actor fa2
    INNER JOIN film f2
		ON fa2.film_id = f2.film_id
	WHERE f2.description LIKE '%CROCODILE%'
		AND f2.description LIKE '%SHARK%') AS fa
	ON a.actor_id = fa.actor_id
    ORDER BY last_name;

SELECT a.first_name, a.last_name, f.release_year
	FROM actor a
	INNER JOIN film_actor fa
      ON a.actor_id = fa.actor_id
    INNER JOIN film f
      ON f.film_id = fa.film_id
	WHERE f.description LIKE '%CROCODILE%'
		AND f.description LIKE '%SHARK%'
	ORDER BY a.last_name;

-- 5. How many films involve a “Crocodile” and a “Shark”?
SELECT COUNT(*)
	FROM film
	WHERE description LIKE '%CROCODILE%'
		AND description LIKE '%SHARK%';
	
-- 6. Find all the film categories in which there are
-- between 55 and 65 films. Return the names of these categories 
-- and the number of films per category, sorted by the number 
-- of films.
SHOW tables;
SELECT * FROM categories;
SELECT * FROM film;
SELECT * FROM film_category;

SELECT c.name, count(*) number_films
	FROM film_category fc
    INNER JOIN category c
		ON fc.category_id = c.category_id
	GROUP BY c.name
    HAVING number_films BETWEEN 55 AND 65 -- "having" goes AFTER the group by, "where" goes BEFORE the group by
    ORDER BY number_films;
	
-- 7. In how many film categories is the average difference 
-- between the film replacement cost and the rental rate 
-- larger than 17?
SELECT * FROM film;
SELECT * FROM category;

-- USE THIS:
	SELECT c.name, count(*) number_films
	FROM film_category fc
    INNER JOIN category c
		ON fc.category_id = c.category_id
	GROUP BY c.name
-- Going to do an inner join, join by film_id, join by category (3-way join)

SELECT film_id, title, replacement_cost - rental_rate avg_diff
	FROM film
    WHERE replacement_cost - rental_rate > 17;

-- 8. Display the first and last names of all actors from the table actor.

-- 9. Display the first and last name of each actor in a 
-- single column in upper case letters. Name the column Actor Name.

-- 10. You need to find the ID number, first name, and last 
-- name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?

-- 11. Find all actors whose last name contain the letters GEN:

-- 12. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order:

-- 13. Using IN, display the country_id and country columns 
-- of the following countries: Afghanistan, Bangladesh, and China:

-- 14. List the last names of actors, as well as how many actors 
-- have that last name.

-- 15. List last names of actors and the number of actors 
-- who have that last name, but only for names that are 
-- shared by at least two actors

-- 16. Use JOIN to display the first and last names, 
-- as well as the address, of each staff member. 

-- 17. Use JOIN to display the total amount rung up by each staff 
-- member in August of 2005. Use tables staff and payment.
-- Use also: payment_date LIKE '2005-08%'

-- 18. List each film and the number of actors who are listed for \
-- that film. Use tables film_actor and film. Use inner join.

-- 19. How many copies of the film Hunchback Impossible exist 
-- in the inventory system?

-- 20. Use subqueries to display all actors who appear in the 
-- film Alone Trip.

-- 21. You want to run an email marketing campaign in Canada, 
-- for which you will need the names and email addresses of 
-- all Canadian customers. Use joins to retrieve this information.

/* That's all, folks! */