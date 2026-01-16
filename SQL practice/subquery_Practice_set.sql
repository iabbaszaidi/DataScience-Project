--SUBQUERY
--Write a query to find all films whose rental rate is higher than the average rental_rate
SELECT * FROM film
WHERE rental_rate > (SELECT AVG(rental_rate)  FROM film);

--Write a query to list customers whose total payment amount is greater than the average payment amount of all customers
SELECT * FROM payment
WHERE amount > (SELECT AVG(amount) FROM payment);

--Find customers who made at least one payment greater than any single payment made by customer_id = 1
SELECT customer_id FROM payment
WHERE amount > ANY(SELECT amount FROM payment
WHERE customer_id = 1);

--Write a query to display actors who have acted in more films than the average number of films per actor
SELECT AVG(actor_id) 
FROM (SELECT COUNT(film_id) , actor_id FROM film_actor
GROUP BY actor_id)
film_actor
GROUP BY actor_id;

--Write a query to list films whose replacement_cost is greater than the average replacement_cost of films released in the same year
SELECT * FROM payment
WHERE amount > (SELECT AVG(amount) FROM payment);

--Find all cities that belong to a country whose country name stars with P


SELECT * 
FROM city
WHERE country_id IN(SELECT country_id FROM country
WHERE country LIKE 'P%');

--films that are not present in the inventory table
SELECT film_id, title FROM film
WHERE film_id NOT IN(SELECT film_id FROM inventory);

--find customers who have rented more films than the average rental
SELECT customer_id, COUNT(*) FROM rental
GROUP BY customer_id
HAVING COUNT(*)> (
SELECT AVG(rental_count)
FROM(
 SELECT COUNT(*) AS rental_count FROM rental
 GROUP BY customer_id));


--Find all films that belong to categories whose average rental_duration is greater than 5 days
SELECT * FROM category AS cat
INNER JOIN film_category AS fc
ON cat.category_id = fc.category_id;

SELECT f.title, f.rental_duration
FROM 
 film AS f
INNER JOIN film_category AS fc
ON f.film_id = fc.film_id
WHERE fc.category_id IN (
	SELECT fc.category_id 
	FROM film AS f
	INNER JOIN film_category fc ON f.film_id = fc.film_id
	GROUP BY fc.category_id
	HAVING AVG(rental_duration) > 5);

--Write a query to list staff members who have processed more payments than any other staff member
SELECT * FROM staff;
SELECT p.staff_id FROM payment AS p
INNER JOIN staff AS st
ON p.staff_id = st.staff_id
WHERE amount IN (
SELECT st.staff_id FROM payment AS p
INNER JOIN staff st 
ON p.staff_id = st.staff_id
GROUP BY p.amount
HAVING 


SELECT st.staff_id, st.first_name, st.last_name FROM staff AS st
INNER JOIN payment AS p
ON st.staff_id = p.staff_id
	GROUP BY st.staff_id, st.first_name
	HAVING COUNT(*) = (SELECT MAX(payment_count)
	FROM (SELECT COUNT(*) AS payment_count FROM payment
	GROUP BY staff_id
	));

--Find customers whose total payment amount is greater than the total payment amount of customer named MARY
SELECT p.customer_id,  SUM(p.amount) AS total_amount
FROM payment p
GROUP BY p.customer_id
HAVING SUM(p.amount) > (
    SELECT SUM(p.amount)
    FROM payment p
    JOIN customer c ON p.customer_id = c.customer_id
    WHERE c.first_name = 'MARY');


--Write a query to find films that have been rented more times than the average rental count per film
SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) > (
    SELECT AVG(rental_count)
    FROM (
        SELECT COUNT(r.rental_id) AS rental_count
        FROM inventory i
        JOIN rental r ON i.inventory_id = r.inventory_id
        GROUP BY i.film_id
    ) );


--Find actors who have acted in all films that belong to the action category

SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film_category fc ON fa.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(DISTINCT fc.film_id) = (
    SELECT COUNT(DISTINCT fc2.film_id)
    FROM film_category fc2
    JOIN category c2 ON fc2.category_id = c2.category_id
    WHERE c2.name = 'Action');

--Write a query to list customers who have rented films from more than one store
SELECT * FROM store;
SELECT * FROM inventory;
SELECT * FROM customer;
SELECT * FROM rental;

SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN rental r 
ON c.customer_id = r.customer_id
JOIN inventory i 
ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.store_id) > 1;


--Write a query to find films that have never been rented, using a subquery with NOT EXISTS
SELECT * FROM film;
SELECT * FROM rental;
SELECT * FROM inventory;

SELECT f.film_id, f.title FROM film AS f
WHERE NOT EXISTS(SELECT 1 FROM inventory AS i
JOIN rental r
ON r.inventory_id = i.inventory_id
WHERE i.film_id = f.film_id);

--Find customers who made payments for every film they rented
SELECT * FROM customer;
SELECT * FROM payment;
SELECT * FROM rental;

SELECT c.customer_id, c.first_name FROM customer AS c
WHERE NOT EXISTS(SELECT 1 FROM rental AS r
JOIN customer AS c1
ON r.customer_id = c.customer_id
WHERE r.customer_id = c.customer_id
AND NOT EXISTS(SELECT 1 FROM payment AS p
JOIN rental AS r
ON p.rental_id = r.rental_id 
WHERE p.rental_id = r.rental_id));

--Actors who have acted in films belonging to MORE categories than the AVERAGE categories per actor
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
JOIN film_actor fa
ON a.actor_id = fa.actor_id
JOIN film_category fc 
ON fa.film_id = fc.film_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(DISTINCT fc.category_id) > (
    SELECT AVG(category_count)
    FROM (
        SELECT COUNT(DISTINCT fc2.category_id) AS category_count
        FROM film_actor fa2
        JOIN film_category fc2 
		ON fa2.film_id = fc2.film_id
        GROUP BY fa2.actor_id ));


--Top 3 customers who spent the MOST money
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p 
ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(p.amount) IN (
    SELECT total_spent
    FROM (
        SELECT SUM(amount) AS total_spent
        FROM payment
        GROUP BY customer_id
        ORDER BY total_spent DESC
        FETCH FIRST 3 ROWS ONLY
    ));


--Films whose rental count is greater than the AVERAGE rental count of films in THEIR OWN CATEGORY
SELECT f.film_id, f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN film_category fc ON f.film_id = fc.film_id
GROUP BY f.film_id, f.title, fc.category_id
HAVING COUNT(r.rental_id) > (
    SELECT AVG(rental_count)
    FROM (
        SELECT COUNT(r2.rental_id) AS rental_count
        FROM inventory i2
        JOIN rental r2 ON i2.inventory_id = r2.inventory_id
        JOIN film_category fc2 ON i2.film_id = fc2.film_id
        WHERE fc2.category_id = fc.category_id
        GROUP BY i2.film_id ));


--Write a query to display customer first name last name and along with their store id using an inner join 

SELECT c.first_name, c.last_name, c.email  FROM customer AS c
JOIN store AS st
ON c.customer_id = st.customer_id;

SELECT f.title, f.language_id FROM film AS f
JOIN language AS l
ON l.language_id = f.language_id;

--Show rental ID, rental date and customer first name by joining 
SELECT r.rental_date, r.rental_id, r.customer_id, c.first_name FROM rental AS r
 JOIN customer AS c
ON c.customer_id = r.customer_id;

--Display staff first name last name and the store ID they work at using an INNER JOIN
SELECT st.first_name, st.last_name, s.store_id FROM staff AS st
JOIN store AS s
ON st.store_id = s.store_id;

--List all payments along with the customer first name and last name using an INNER JOIN between payment and customer
SELECT c.first_name, c.last_name, p.amount FROM customer AS c
JOIN payment AS p
ON c.customer_id = p.customer_id;


--Write a query to show all customers and their rentals INCLUDE WHO HAVE NEVER RENTED ANY FILM
SELECT c.customer_id,r.rental_id FROM rental AS r
LEFT JOIN customer AS c
ON c.customer_id = r.customer_id
WHERE r.rental_id IS NULL;

--Display film title and category name by joining film, film category and category
SELECT f.title, c.name FROM film AS f
JOIN film_category AS fc
ON f.film_id = fc.film_id
JOIN category AS c
ON c.category_id = fc.category_id;

--list customers and the total number of rentals they made include customer
SELECT  c.first_name, c.last_name, COUNT(r.rental_id) as total_rentals
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
--HAVING COUNT(r.rental_id) = 0
ORDER BY total_rentals;


--Show staff members and the total payment amount they have processed use join between staff and payment
SELECT p.staff_id, st.first_name, st.last_name, SUM(p.amount) AS total_amount FROM payment AS p
LEFT JOIN staff AS st
ON st.staff_id = p.staff_id
GROUP BY st.first_name, st.last_name, p.staff_id
ORDER BY total_amount;

--display all films and their inventry IDs including films that are not available in inventory

SELECT * FROM inventory;
SELECT * FROM film;

SELECT f.title, i.film_id FROM film AS f
FULL OUTER JOIN inventory AS i
ON i.film_id = f.film_id
GROUP BY f.title, i.film_id;
HAVING i.film_id = 0;

--Wrie a query to list all customers and all rentals, including customers with no rentals, rentals not linked to any customer
SELECT c.customer_id, c.first_name, c.last_name, r.rental_id, r.rental_date, r.return_date,
CASE 
	WHEN c.customer_id IS NULL THEN 'Zero'
	WHEN r.rental_id IS NULL THEN ' Zero Rental'
	ELSE 'Has Rental'
	END AS status
FROM customer AS c
FULL OUTER JOIN rental AS r
ON c.customer_id = r.customer_id
--WHERE rental_id IS NULL
ORDER BY c.customer_id, r.rental_date, c.first_name, c.last_name;

--Show film title, customer name and rental_date for all rentals made from store 1 only
SELECT * FROM film;
SELECT * FROM rental;
SELECT * FROM inventory;

SELECT f.title, c.first_name, rental_date FROM film AS f
JOIN inventory AS i
ON i.film_id = f.film_id
JOIN rental AS r
ON i.inventory_id = r.inventory_id
JOIN customer AS c
ON c.customer_id = r.customer_id
WHERE i.store_id =1;

--Find actors who have never acted in any film

SELECT * FROM actor;
SELECT * FROM film_actor;

SELECT a.first_name, a.last_name, a.actor_id FROM actor AS a
LEFT JOIN film_actor AS fa
ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL
ORDER BY a.last_name, a.first_name;


--Dispaly category name and total revenue generated from that category using joins between
SELECT 
    c.category_id,
    c.name AS category_name,
    SUM(p.amount) AS total_revenue,
    COUNT(DISTINCT r.rental_id) AS total_rentals,
    COUNT(DISTINCT p.payment_id) AS total_payments
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.category_id, c.name
ORDER BY total_revenue DESC;

--list customers, films and payment amount where the flim was rented, apayment was made but customers with missing payments should still apper
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    f.film_id,
    f.title,
    f.rental_rate,
    r.rental_id,
    r.rental_date,
    r.return_date,
    p.payment_id,
    p.amount AS payment_amount,
    p.payment_date
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
LEFT JOIN payment p ON r.rental_id = p.rental_id
ORDER BY 
    CASE WHEN p.payment_id IS NULL THEN 0 ELSE 1 END,  -- Missing payments first
    c.last_name,
    c.first_name,
    r.rental_date DESC;


--Retrieve all films along with their categories.
SELECT c.name, f.title FROM film AS f
JOIN film_category AS fc
ON f.film_id = fc.film_id
JOIN category AS c
ON c.category_id = fc.category_id;


--Show all actors and the titles of films they have acted in.
SELECT a.first_name, a.last_name, f.title FROM actor AS a
JOIN film_actor AS fa
ON a.actor_id = fa.actor_id
JOIN film AS f
ON f.film_id = fa.actor_id
GROUP BY a.first_name, a.last_name, f.title;

--List all rentals with customer names and film titles.
SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM film;

SELECT c.first_name, f.film_id  FROM rental AS r
JOIN customer AS c
ON c.customer_id = r.customer_id
JOIN inventory AS i
ON i.inventory_id = r.inventory_id
JOIN film AS f
ON i.film_id = f.film_id;


--Get all payments along with the customer name who made the payment.
SELECT c.first_name, COUNT(amount) FROM payment AS p
JOIN customer AS c
ON p.customer_id = c.customer_id
GROUP BY c.first_name, amount
HAVING COUNT(amount) > 0;

--Show all staff members and the store they work at.

SELECT st.first_name, st.last_name, s.store_id  FROM staff AS st
JOIN store AS s
ON s.store_id = st.store_id;

--Retrieve all inventory items along with the film title and store location.

SELECT f.title, s.address_id FROM inventory AS i
JOIN store AS s
ON i.store_id = s.store_id
JOIN film AS f
ON f.film_id = i.film_id;


--List all customers with their address and postal code.
SELECT c.first_name, c.last_name, a.address, a.postal_code FROM customer AS c
JOIN address AS a
ON c.address_id = a.address_id;

--Show all films and the names of their actors (first and last name).
SELECT a.first_name, a.last_name, f.title FROM actor AS a
JOIN film_actor AS fa
ON fa.actor_id = a.actor_id
JOIN film AS f
ON fa.film_id = f.film_id;

--List all rentals with rental date, customer name, and staff member handling it.
SELECT r.rental_date, c.first_name, st.first_name FROM rental AS r
JOIN customer AS c
ON c.customer_id = r.customer_id
JOIN staff AS st
ON st.staff_id = r.staff_id;

--Find customers who rented films in the category ‘Action’.
SELECT c.name, c1.first_name, f.rental_date FROM category
JOIN film_category AS fc
ON fc.film_id = f.film_id
JOIN category AS c
ON c.category_id = fc.category_id
JOIN 
SELECT * FROM store;

SELECT * FROM film_category





