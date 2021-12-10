--
-- QTM 385
-- Elements of Data Science
-- Prof.: Umberto Mignozzetti
--
-- SQL Class 07
--

-- Getting started
USE sakila;

-- Show tables
SHOW TABLES;

/* Conditional Logic */

-- All computer languages have flow control
-- logics implemented in them. In SQL
-- we use CASE-WHEN to control the flow:
SELECT first_name, last_name,
  CASE
    WHEN active = 1 THEN 'ACTIVE'
    ELSE 'INACTIVE'
  END activity_type
  FROM customer;

/* Syntax:

CASE
  WHEN C1 THEN E1
  WHEN C2 THEN E2
  ...
  WHEN CN THEN EN
  [ELSE ED]
END

Ci: conditions
Ei: expressions

*/

SELECT c.first_name, c.last_name,
  CASE
    WHEN active = 0 THEN 0
    ELSE
    (SELECT count(*) FROM rental r
	WHERE r.customer_id = c.customer_id)
    END num_rentals
  FROM customer c;

-- Monthly rentals without CASE-WHEN
SELECT monthname(rental_date) rental_month,
  count(*) num_rentals
  FROM rental
  WHERE rental_date BETWEEN '2005-05-01' AND '2005-08-01'
  GROUP BY monthname(rental_date);

-- Monthly rentals with CASE-WHEN
SELECT
  SUM(CASE WHEN monthname(rental_date) = 'May' THEN 1
    ELSE 0 END) May_rentals,
  SUM(CASE WHEN monthname(rental_date) = 'June' THEN 1
    ELSE 0 END) June_rentals,
  SUM(CASE WHEN monthname(rental_date) = 'July' THEN 1
    ELSE 0 END) July_rentals
  FROM rental
  WHERE rental_date BETWEEN '2005-05-01' AND '2005-08-01';

-- Exercise: Rewrite the following query so that 
-- the result set contains a single row with 
-- five columns (one for each rating). 
-- Name the five columns G, PG, PG_13, R, and NC_17.
SELECT rating, count(*)
  FROM film
  GROUP BY rating;

-- What about an inventory count?
SELECT f.title,
  CASE (SELECT count(*) FROM inventory i 
      WHERE i.film_id = f.film_id)
    WHEN 0 THEN 'Out Of Stock'
    WHEN 1 THEN 'Scarce'
    WHEN 2 THEN 'Scarce'
    WHEN 3 THEN 'Available'
    WHEN 4 THEN 'Available'
    ELSE 'Common'
    END film_availability
  FROM film f;

-- Dealing with NULL:
SELECT 100 / 0;

-- Example: avoiding nulls when computing averages
SELECT c.first_name, c.last_name,
  sum(p.amount) tot_payment_amt,
  count(p.amount) num_payments,
  sum(p.amount) /
    CASE WHEN count(p.amount) = 0 THEN 1
      ELSE count(p.amount)
      END avg_payment
  FROM customer c
    LEFT OUTER JOIN payment p
    ON c.customer_id = p.customer_id
  GROUP BY c.first_name, c.last_name;

-- Example: Full address removing unkowns
SELECT c.first_name, c.last_name,
  CASE
    WHEN a.address IS NULL THEN 'Unknown'
    ELSE a.address
  END address,
  CASE
    WHEN ct.city IS NULL THEN 'Unknown'
    ELSE ct.city
  END city,
  CASE
    WHEN cn.country IS NULL THEN 'Unknown'
    ELSE cn.country
  END country
FROM customer c
  LEFT OUTER JOIN address a
  ON c.address_id = a.address_id
  LEFT OUTER JOIN city ct
  ON a.city_id = ct.city_id
  LEFT OUTER JOIN country cn
  ON ct.country_id = cn.country_id;

/* Views */

-- Views are meant for creating table with queries
-- easily to visualize. This is good, as it hides 
-- some of the implementation XXXX of the user:
CREATE VIEW customer_vw
 (customer_id,
  first_name,
  last_name,
  email 
 )
AS
SELECT 
  customer_id,
  first_name,
  last_name,
  concat(substr(email,1,2), '*****', substr(email, -4)) email
FROM customer;

SELECT * FROM customer_vw;

-- And is looks like a table:
DESCRIBE customer_vw;

-- We can even join views with other tables:
SELECT cv.first_name, cv.last_name, p.amount
  FROM customer_vw cv
    INNER JOIN payment p
    ON cv.customer_id = p.customer_id
  WHERE p.amount >= 11;
  
-- Active user: one thing to note is the email part
CREATE VIEW active_customer_vw
 (customer_id,
  first_name,
  last_name,
  email
 )
AS
SELECT
  customer_id,
  first_name,
  last_name,
  concat(substr(email,1,2), '*****', substr(email, -4)) email
FROM customer
WHERE active = 1;

-- Exercise: display it
answers_here;

-- Sales by category:
CREATE VIEW sales_by_film_category
AS
SELECT
  c.name AS category,
  SUM(p.amount) AS total_sales
FROM payment AS p
  INNER JOIN rental AS r ON p.rental_id = r.rental_id
  INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
  INNER JOIN film AS f ON i.film_id = f.film_id
  INNER JOIN film_category AS fc ON f.film_id = fc.film_id
  INNER JOIN category AS c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY total_sales DESC;

-- Exercise: Create a view definition that can 
-- be used by the following query to generate 
-- the given results:
/*
SELECT title, category_name, first_name, last_name
FROM film_ctgry_actor
WHERE last_name = 'FAWCETT';

+---------------------+---------------+------------+-----------+
| title               | category_name | first_name | last_name |
+---------------------+---------------+------------+-----------+
| ACE GOLDFINGER      | Horror        | BOB        | FAWCETT   |
| ADAPTATION HOLES    | Documentary   | BOB        | FAWCETT   |
| CHINATOWN GLADIATOR | New           | BOB        | FAWCETT   |
| CIRCUS YOUTH        | Children      | BOB        | FAWCETT   |
| CONTROL ANTHEM      | Comedy        | BOB        | FAWCETT   |
| DARES PLUTO         | Animation     | BOB        | FAWCETT   |
| DARN FORRESTER      | Action        | BOB        | FAWCETT   |
| DAZED PUNK          | Games         | BOB        | FAWCETT   |
| DYNAMITE TARZAN     | Classics      | BOB        | FAWCETT   |
| HATE HANDICAP       | Comedy        | BOB        | FAWCETT   |
| HOMICIDE PEACH      | Family        | BOB        | FAWCETT   |
| JACKET FRISCO       | Drama         | BOB        | FAWCETT   |
| JUMANJI BLADE       | New           | BOB        | FAWCETT   |
| LAWLESS VISION      | Animation     | BOB        | FAWCETT   |
| LEATHERNECKS DWARFS | Travel        | BOB        | FAWCETT   |
| OSCAR GOLD          | Animation     | BOB        | FAWCETT   |
| PELICAN COMFORTS    | Documentary   | BOB        | FAWCETT   |
| PERSONAL LADYBUGS   | Music         | BOB        | FAWCETT   |
| RAGING AIRPLANE     | Sci-Fi        | BOB        | FAWCETT   |
| RUN PACIFIC         | New           | BOB        | FAWCETT   |
| RUNNER MADIGAN      | Music         | BOB        | FAWCETT   |
| SADDLE ANTITRUST    | Comedy        | BOB        | FAWCETT   |
| SCORPION APOLLO     | Drama         | BOB        | FAWCETT   |
| SHAWSHANK BUBBLE    | Travel        | BOB        | FAWCETT   |
| TAXI KICK           | Music         | BOB        | FAWCETT   |
| BERETS AGENT        | Action        | JULIA      | FAWCETT   |
| BOILED DARES        | Travel        | JULIA      | FAWCETT   |
| CHISUM BEHAVIOR     | Family        | JULIA      | FAWCETT   |
| CLOSER BANG         | Comedy        | JULIA      | FAWCETT   |
| DAY UNFAITHFUL      | New           | JULIA      | FAWCETT   |
| HOPE TOOTSIE        | Classics      | JULIA      | FAWCETT   |
| LUKE MUMMY          | Animation     | JULIA      | FAWCETT   |
| MULAN MOON          | Comedy        | JULIA      | FAWCETT   |
| OPUS ICE            | Foreign       | JULIA      | FAWCETT   |
| POLLOCK DELIVERANCE | Foreign       | JULIA      | FAWCETT   |
| RIDGEMONT SUBMARINE | New           | JULIA      | FAWCETT   |
| SHANGHAI TYCOON     | Travel        | JULIA      | FAWCETT   |
| SHAWSHANK BUBBLE    | Travel        | JULIA      | FAWCETT   |
| THEORY MERMAID      | Animation     | JULIA      | FAWCETT   |
| WAIT CIDER          | Animation     | JULIA      | FAWCETT   |
+---------------------+---------------+------------+-----------+

*/
answers_here;

/* That's all, folks! */