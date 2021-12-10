/* Homework SQL - QTM 385 */
/* Lauren Galindo         */

/* Question 1: Use the database sakila */
USE sakila;

/* Question 2: Check the description of table "payment" */
DESCRIBE payment;

/* Question 3: Count all the amounts payed in payments
   table that are greater than zero. */
SELECT COUNT(amount) as "Payment Count" 
	FROM payment
	WHERE amount > 0;
    
/* Question 4: Compute the mean of amounts in the table 
   payments using only values greater than zero. */
SELECT AVG(amount) as "Amount Mean"
	FROM payment
    WHERE amount > 0;
    
/* Question 5: Show all the variables for film_text for
   the first two movies. */
SELECT * 
	FROM film_text
	LIMIT 2;