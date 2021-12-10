--
-- QTM 385
-- Elements of Data Science
-- Prof.: Umberto Mignozzetti
--
-- SQL Class 01
--

-- 2 dashes=Comment in one line

/* Also work for commenting */
/* Could potentially
   work for more 
   general comments */
   
-- As a pattern, we write SQL commands in upper case
-- and other things in lower case
-- Example:

/* 
SELECT * FROM my_table;
The `*` symbol means "everything"
*/

-- And this prints the table my_table in the screen

/* Operations with databases */

-- To create a new database:
CREATE DATABASE mydb;

-- To erase a database (warning: no way back!)
DROP DATABASE mydb;

-- Exercise: create a database and name it newdb.
CREATE DATABASE newdb;

-- To show all the databases in memory:
SHOW DATABASES;

-- To use a particular database:
-- USE database_name;
-- Exercise: use the database that we created.
USE newdb;

-- The new dataset has no tables inside it
-- but if it had, to display the tables we do:
SHOW TABLES;

-- show tables = Same output as the all caps. Not Case Sensitive

/* Data types */

-- See the slides for the data types
SHOW CHARACTER SET;

/* Create a new table */

-- Create table to store personal info:
CREATE TABLE person
  (person_id SMALLINT UNSIGNED,
  fname VARCHAR(20),
  lname VARCHAR(20),
  eye_color ENUM('BR','BL','GR', 'HZ'),
  birth_date DATE,
  street VARCHAR(30),
  city VARCHAR(20),
  state VARCHAR(20),
  country VARCHAR(20),
  postal_code VARCHAR(20),
  CONSTRAINT pk_person PRIMARY KEY (person_id)
);

-- Table description
DESC person;

-- Change something in my Table Structure:
ALTER TABLE person
  MODIFY person_id SMALLINT
  UNSIGNED AUTO_INCREMENT;

-- Insert data:
INSERT INTO person
  (person_id, fname, 
  lname, eye_color, 
  birth_date) VALUES 
  (null, 'William',
  'Turner', 'BR', 
  '1972-05-27');

-- Check my new table:
SELECT * FROM person;

-- Exercise: insert info person slides:
INSERT INTO person
  (person_id, fname, 
  lname, eye_color, 
  birth_date, 
  street, city, 
  state, country, postal_code) VALUES 
  (null, 'Susan', 
  'Smith', 'BL',
  '1975-11-02', 
  '23 Maple St', 'Arlington', 
  'VA', 'US', '20220');

-- And to do a quick SELECT in here:
SELECT person_id, fname, lname, birth_date FROM person;

-- Or to select all columns, use the star:
SELECT * FROM person;

-- And to update the William's data:
UPDATE person
  SET street = '1225 Tremont St.',
  city = 'Boston',
  state = 'MA',
  country = 'USA',
  postal_code = '02138'
  WHERE person_id = 1;

-- Note the pattern: COMMAND1 place1 COMMAND2 place2 and etc...

-- Deleting rows (warning: be careful with this!)
DELETE FROM person
  WHERE person_id = 2;

SELECT * FROM person;
-- Exercise:
-- 1. Add your info to the dataset. 
-- 2. Change your address to '200 Dowman Dr'. 
-- 3. Show your dataset.
-- 4. Erase the entry with your info.
INSERT INTO person
  (person_id, fname, 
  lname, eye_color, 
  birth_date, 
  street, city, 
  state, country, postal_code) VALUES 
  (null, 'Lauren', 
  'Galindo', 'BR',
  '2000-11-02', 
  '23 Maple St', 'Arlington', 
  'VA', 'US', '20220');

UPDATE person
  SET street = '200 Dowman Dr.',
  city = 'Boston',
  state = 'MA',
  country = 'USA',
  postal_code = '02138'
  WHERE person_id = 2;
  
  DELETE FROM person
  WHERE person_id = 3;
  
  SELECT * FROM person;
/* Import the databases we will need */

-- sakila
-- Check the sakila database on mysql website
-- Two steps: 
-- 		First, import the schema
-- 		Second, import the data

-- world
-- Check the world database on mysql website

--
/* See you next class */
-- 