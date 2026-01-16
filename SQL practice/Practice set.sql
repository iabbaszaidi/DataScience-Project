CREATE TABLE movie_review (
    review_id SERIAL PRIMARY KEY,
    film_id INT NOT NULL,
	reviewer_name VARCHAR(100),
    review_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);

select * from movie_review


INSERT INTO movie_review(review_id, film_id, reviewer_name, review_date )
VALUES('2','6','qwe','2024-03-01'),
('3','1','cvb','2024-05-01'),
('4','2','bnm','2024-07-01'),
('5','3','zxc','2024-09-01'),
('6','4','fgh','2024-08-01');

SELECT * FROM movie_review;

SELECT * FROM film;


SELECT 
    f.film_id,
    f.title,
    f.rating,
    r.reviewer_name,
    r.review_date
FROM film f
JOIN movie_review r
    ON f.film_id = r.film_id;


--Display all records from the film table.
SELECT * FROM film;

--Retrieve only the film title and rental rate from the film table.
SELECT title, rental_rate FROM film;

--List all customers sorted by last name in ascending order.
SELECT first_name FROM customer
GROUP BY first_name;

--Show the first 10 rows from the rental table
SELECT * FROM rental
LIMIT 10;

--Display 10 rentals starting from the 11th record
SELECT * FROM rental
LIMiT 10
OFFSET 10;

--Find all films whose rental rate is between 2 and 4.
SELECT * FROM film
WHERE film_id BETWEEN 2 AND 4;

--List films whose rating is either ‘G’, ‘PG’, or ‘PG-13’.
SELECT * FROM film
WHERE rating IN ('PG','G','PG-13' );

--Retrieve customers whose first name starts with the letter ‘A’
SELECT * FROM customer
WHERE first_name LIKE 'A%';

--Find all rentals that have not yet been returned.
SELECT * FROM rental
WHERE return_date IS NULL;

--Display distinct film ratings available in the film table
SELECT DISTINCT(rating) FROM film;

--Display all film titles in uppercase
SELECT UPPER(title) FROM film;

--Show film titles along with the number of characters in each title.
SELECT LENGTH(title) FROM film;

--Remove leading and trailing spaces from customer email addresses
SELECT TRIM(BOTH ' ' FROM email) FROM customer;

--Extract the first 5 characters from each film title.
SELECT SUBSTR(title, 1,5) FROM film;

--Display customer first names in lowercase.
SELECT LOWER(first_name) FROM customer;

--Count the total number of films in the database.
SELECT COUNT(title) FROM film;

--AVG rental rate
SELECT ROUND(AVG(rental_rate)) FROM film;

--MINIMUN AND MAXIMUM flim lenght
SELECT MIN(length) FROM film;
SELECT MAX(length) FROM film;

--Calculate the total revenue collected from all payments.
SELECT COUNT(amount) FROM payment;

--Count the total number of customers.
SELECT COUNT(first_name) FROM customer;

--Count the number of films for each rating.
SELECT rating, COUNT(*) FROM film
GROUP BY rating;

--Calculate total payment amount collected per customer.
SELECT customer_id, COUNT(amount) FROM payment
GROUP BY customer_id;

--Display customers whose total payment amount exceeds 150.
SELECT * FROM payment
WHERE amount > 150;

--Count the number of rentals handled by each staff member.
SELECT  COUNT(staff_id) FROM payment;

--Find the average rental rate grouped by film rating.
SELECT rating, AVG(rental_rate) FROM film
GROUP BY rating;

select * from rental

--Rentals per category
SELECT c.name, COUNT(r.rental_id) as rental_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.category_id, c.name;

--31 32 33 34 35 JOIN not done


SELECT MAX(amount) FROM payment
WHERE  amount > 6;

SELECT * FROM payment
WHERE amount = (SELECT MAX(amount) FROM payment);