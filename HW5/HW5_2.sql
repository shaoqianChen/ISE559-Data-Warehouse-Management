#Task 2
#Question 1

DROP TABLE IF EXISTS rental_fact;
CREATE TABLE rental_fact
(
	rental_id integer,
	inventory_id integer,
	customer_id integer,
	store_id integer,
	rental_date timestamp without time zone,
	payment_amount numeric(5,2),
);

DROP TABLE IF EXISTS dim_inventory;
CREATE TABLE dim_inventory
(
	inventory_id integer,
	category_name character varying(25),
	title character varying(225)
)

DROP TABLE IF EXISTS dim_customer;
CREATE TABLE dim_customer
(
	customer_id integer,
	first_name character varying(45),
	last_name character varying(45),
	district character varying(20),
	city character varying(45)	
);




#Task 2
#Question 2


CREATE OR REPLACE FUNCTION random_between(low INT, high INT) 
	RETURNS INT AS
$$
BEGIN
	RETURN FLOOR(RANDOM()*(high-low+1)+low);
END;
$$ language 'plpgsql' STRICT;

SELECT random_between(1,10);

DELETE FROM rental_fact;
INSERT INTO rental_fact(
						rental_id,
						inventory_id,
						customer_id,
						store_id,
						rental_date,
						payment_amount)
SELECT rental.rental_id,
		inventory_id,
		rental.customer_id,
		random_between(1,10),
		rental_date,
		payment.amount AS payment_amount
FROM rental
INNER JOIN payment ON payment.rental_id = rental.rental_id
ORDER BY RANDOM()
LIMIT 100;

SELECT * FROM rental_fact







DELETE FROM dim_customer;
INSERT INTO dim_customer (customer_id,
						  first_name,
						  last_name,
						  district,
						  city)
WITH table01 AS(						  
	SELECT customer_id,
			first_name,
			last_name,
			district,
			city.city
	FROM customer
	INNER JOIN address ON address.address_id = customer.address_id
	INNER JOIN city ON city.city_id = address.city_id)
	SELECT 
	table01.customer_id,
	first_name,
	last_name,
	district,
	city
FROM table01
INNER JOIN rental_fact ON rental_fact.customer_id = table01.customer_id
ORDER BY RANDOM();

SELECT * FROM dim_customer;





DELETE FROM dim_inventory;
INSERT INTO dim_inventory(
						inventory_id,
						category_name,
						title)
WITH table0 AS(
SELECT inventory_id,
		category.name AS category_name,
		film.title	
FROM inventory
INNER JOIN film ON film.film_id = inventory.film_id
INNER JOIN film_category ON film_category.film_id = film.film_id
INNER JOIN category ON category.category_id = film_category.category_id)
SELECT 
	table0.inventory_id,
	category_name,
	title
FROM table0
INNER JOIN rental_fact ON rental_fact.inventory_id=table0.inventory_id
ORDER BY RANDOM();

SELECT * FROM dim_inventory;











