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

/* Subqueries (cont'd) */

-- Subqueries as data sources:
SELECT c.customer_id ID, c.first_name, c.last_name, 
    pymnt.num_rentals, pymnt.tot_payments
  FROM customer c
    INNER JOIN
    (SELECT customer_id, 
      count(*) num_rentals, sum(amount) tot_payments
    FROM payment
    GROUP BY customer_id
    ) pymnt
    ON c.customer_id = pymnt.customer_id
    ORDER BY tot_payments;

-- Exercise: is the subquery above a correlated or
-- noncorrelated subquery?
SELECT customer_id, 
      count(*) num_rentals, sum(amount) tot_payments
    FROM payment
    GROUP BY customer_id; 
							-- It's UNCORRELATED

-- Data Fabrication: making data ourselves

-- Suppose we want to classify the customers in this way:
-- Note: limits don't overlap... highest limit is completely out of bounds in order to compare
SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit
  UNION ALL
  SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit
  UNION ALL
  SELECT 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit;

-- Here is the query to classify:
SELECT pymnt_grps.name, count(*) num_customers
  FROM (SELECT customer_id,
    count(*) num_rentals, sum(amount) tot_payments
  FROM payment
  GROUP BY customer_id
  ) pymnt
  INNER JOIN
    (SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit
    UNION ALL
    SELECT 'Below Average Joes' name, 75 low_limit, 99.99 high_limit
    UNION ALL
    SELECT 'Above Average Joes' name, 100 low_limit, 149.99 high_limit
    UNION ALL
    SELECT 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit
    ) pymnt_grps
  ON pymnt.tot_payments BETWEEN pymnt_grps.low_limit AND pymnt_grps.high_limit
  GROUP BY pymnt_grps.name;

SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit
    UNION ALL
    SELECT 'Below Average Joes' name, 75 low_limit, 99.99 high_limit
    UNION ALL
    SELECT 'Above Average Joes' name, 100 low_limit, 149.99 high_limit
    UNION ALL
    SELECT 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit;

-- Exercise: count the participation of actors in movies using 
-- the following classification:
SELECT 'Hollywood Star' level, 30 min_roles, 99999 max_roles
	UNION ALL
	SELECT 'Prolific Actor' level, 20 min_roles, 29 max_roles
	UNION ALL
	SELECT 'Newcomer' level, 1 min_roles, 19 max_roles;

SELECT * FROM film_actor;
SELECT * FROM actor;

SELECT count(*) nfilms 
	FROM film_actor
	GROUP BY actor_id;

SELECT tl.level, count(*) num_movies
  FROM (SELECT count(*) nfilms 
			FROM film_actor
			GROUP BY actor_id) AS nf
  INNER JOIN (SELECT 'Hollywood Star' level, 30 min_roles, 99999 max_roles
		UNION ALL
		SELECT 'Prolific Actor' level, 20 min_roles, 29 max_roles
		UNION ALL
		SELECT 'Newcomer' level, 1 min_roles, 19 max_roles) AS tl
  ON nf.nfilms BETWEEN tl.min_roles AND tl.max_roles
  GROUP BY tl.level;

SELECT actor_id, count(*) AS nfilms
	FROM film_actor
	GROUP BY actor_id;
    
SELECT actor_id, count(*) AS nfilms 
	FROM film_actor
	INNER JOIN (SELECT 'Hollywood Star' level, 30 min_roles, 99999 max_roles
		UNION ALL
		SELECT 'Prolific Actor' level, 20 min_roles, 29 max_roles
		UNION ALL
		SELECT 'Newcomer' level, 1 min_roles, 19 max_roles) AS tl
	ON nfilms BETWEEN tl.min_roles AND tl.max_roles;

/* OUTER JOINs */

-- So far we have studied INNER JOINs.
-- The assumption is that the columns match perfectly
-- I.e., there is no missingness in the tables joined

-- What if we have missingness?

-- Example:
SELECT count(*) FROM film;

SELECT count(DISTINCT film_id) FROM inventory i; -- Bc of rentals not being returned

SELECT f.film_id, f.title, count(*) num_copies
  FROM film f
    INNER JOIN inventory i
    ON f.film_id = i.film_id
  GROUP BY f.film_id, f.title; -- Film_id 14 is missing! 
  -- Inner join doesn't keep entries if they are not in both tables.

-- However, the entire match is the following:
SELECT f.film_id, f.title, count(i.inventory_id) num_copies
  FROM film f
    LEFT OUTER JOIN inventory i
    ON f.film_id = i.film_id
  GROUP BY f.film_id, f.title
  LIMIT 15;
  -- Outer join is great for not getting rid of things for whatever reason
  
-- For example, the movie "Alice Fantasia"
-- number 14, has zero copies in the inventory
-- However, the INNER JOIN does not allow us
-- to see this:
SELECT f.film_id, f.title, count(*) num_copies
  FROM film f
    INNER JOIN inventory i
    ON f.film_id = i.film_id
  GROUP BY f.film_id, f.title
  LIMIT 15;
  
-- And checking the inventory id's:
SELECT f.film_id, f.title, i.inventory_id
  FROM film f
    LEFT OUTER JOIN inventory i
    ON f.film_id = i.film_id
  WHERE f.film_id BETWEEN 13 AND 15;

-- In these cases, we need the OUTER JOINs.

-- Exercise: adapt the code above using RIGHT OUTER JOIN.
-- Hint: change the order of the join.
SELECT f.film_id, f.title, i.inventory_id
  FROM inventory i
	RIGHT OUTER JOIN film f
    ON f.film_id = i.film_id
  WHERE f.film_id BETWEEN 13 AND 15;

-- A bit more of Cartesian Products
-- CROSS JOIN:
SELECT c.name category_name, l.name language_name
  FROM category c
    CROSS JOIN language l;
		-- Cross join takes the names and languages and joins both
    
-- NATURAL JOINs: they find out the variables to make
-- the match by themselves
SELECT cust.first_name, cust.last_name, date(r.rental_date)
  FROM
    (SELECT customer_id, first_name, last_name
    FROM customer
    ) cust
      NATURAL JOIN rental r;

/* Data Generation, Manipulation, and Conversion */

-- A few special characters:
SELECT CHAR(128,129,130,131,132,133,134,135,136,137);

SELECT CHAR(138,139,140,141,142,143,144,145,146,147);

SELECT CHAR(148,149,150,151,152,153,154,155,156,157);

SELECT CHAR(158,159,160,161,162,163,164,165);

-- Concat function:
SELECT CONCAT('danke sch', CHAR(148), 'n');
SELECT CONCAT('My nice ', 'text');

SELECT concat(first_name, ' ', last_name,
    ' has been a customer since ', date(create_date)) cust_narrative
    FROM customer;

SELECT * FROM actor;    
SELECT * FROM customer;

SELECT CONCAT(first_name, ' ', last_name) AS full_name
	FROM actor;

SELECT CONCAT(last_name, ', ', first_name) AS full_name
	FROM actor;
        
-- Numeric data:
SELECT (360 * 8) / (24);

SELECT MOD(10,4); -- Remainder of division

SELECT MOD(22.75, 5);

SELECT POW(2,8);

SELECT POW(2,10) kilobyte, POW(2,20) megabyte,
  POW(2,30) gigabyte, POW(2,40) terabyte;

SELECT CEIL(72.445), FLOOR(72.445);

SELECT CEIL(72.000000001), FLOOR(72.999999999);

SELECT ROUND(72.49999), ROUND(72.5), ROUND(72.50001);

SELECT TRUNCATE(72.0909, 1), TRUNCATE(72.0909, 2),
  TRUNCATE(72.0909, 3);

SELECT ROUND(72.0909, 3);

-- Time and date:
SELECT CURRENT_DATE(), CURRENT_TIME(), CURRENT_TIMESTAMP();

SELECT DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY);

SELECT LAST_DAY('2021-11-18'); -- Last date of the month

SELECT DAYNAME('2021-11-18'); -- Name of the day

SELECT EXTRACT(YEAR FROM '2020-01-20 22:19:05');

SELECT DATEDIFF('2019-09-03', '2019-06-21');

-- Exercise: find the date difference from today to 
-- your birthday.
SELECT DATEDIFF(CURRENT_DATE(), '2000-10-09');

-- Hard Q:

-- 1. Create a query with sum of payment amounts by customer
--    add their first and last name in a single column
answers_here;

-- 2. Display the name and the payment amount of the
--    third highest spender.
answers_here;

/* That's all, folks! */