CREATE TABLE dim_customer
AS(
	SELECT customer_id,first_name,last_name,email,address,address2,district,city.city,country.country,postal_code,phone,store_id
	FROM customer
	INNER JOIN address ON address.address_id = customer.address_id
	INNER JOIN city ON city.city_id = address.city_id
	INNER JOIN country ON country.country_id = city.country_id)



CREATE TABLE dim_inventory
AS(SELECT inventory_id,
		category.name AS category_name,
		film.title,
		film.description,
		film.release_year,
		film.rental_duration,
		film.rental_rate, 
		film.length, 
		film.replacement_cost,
		film.rating,
		film.fulltext
		
FROM inventory
INNER JOIN film ON film.film_id = inventory.film_id
INNER JOIN film_category ON film_category.film_id = film.film_id
INNER JOIN category ON category.category_id = film_category.category_id)


CREATE TABLE dim_staff
AS(SELECT staff_id,
		store_id,
		first_name,
		last_name,
		email,
		address.address,
		address.address2,
		address.district,
		city.city,
		country.country,
		address.postal_code,
		address.phone,
		username,
		password,
		picture,
		active
FROM staff
INNER JOIN address ON address.address_id = staff.address_id
INNER JOIN city ON city.city_id = address.city_id
INNER JOIN country ON country.country_id = city.country_id)


CREATE TABLE rental_fact
AS(SELECT rental.rental_id,
		inventory_id,
		rental.customer_id,
		rental.staff_id,
		rental_date,
		return_date,
		payment.amount AS payment_amount,
		payment.payment_date
FROM rental
INNER JOIN payment ON payment.rental_id = rental.rental_id
ORDER BY rental_id ASC)





#Task 2
#Question 1

CREATE TABLE dim_inventory
(
	inventory_id integer,
	category_name character varying(25),
	title character varying(225),
	description text,
	release_year integer,
	rental_duration smallint,
	rental_rate numeric(4,2),
	length smallint,
	replacement_cost numeric(5,2),
	rating mpaa_rating,
	fulltext tsvector
)



CREATE TABLE dim_staff
(
	staff_id integer,
	first_name character varying(45),
	last_name character varying(45),
	email character varying(45),
	address character varying(50),
	address2 character varying(45),
	district character varying(20),
	city character varying(45),
	country character varying(50),
	postal_code character varying(10),
	phone character varying(20),
	store_id integer,
	username character varying(16),
	password character varying(40),
	picture bytea,
	active boolean
)

CREATE TABLE dim_customer
(
	customer_id integer,
	first_name character varying(45),
	last_name character varying(45),
	email character varying(45),
	address character varying(50),
	address2 character varying(45),
	district character varying(20),
	city character varying(45),
	country character varying(50),
	postal_code character varying(10),
	phone character varying(20),
	store_id integer
)



CREATE TABLE rental_fact
(
	rental_id integer,
	inventory_id integer,
	customer_id integer,
	staff_id integer,
	rental_date timestamp without time zone,
	return_date timestamp without time zone,
	payment_amount numeric(5,2),
	payment_date timestamp without time zone
)





#Task 2
#Question 2

INSERT INTO dim_customer (customer_id,
						  first_name,
						  last_name,
						  email,
						  address,
						  address2,
						  district,
						  city,
						  country,
						  postal_code,
						  phone,
						  store_id)
SELECT customer_id,first_name,last_name,email,address,address2,district,city.city,country.country,postal_code,phone,store_id
FROM customer
INNER JOIN address ON address.address_id = customer.address_id
INNER JOIN city ON city.city_id = address.city_id
INNER JOIN country ON country.country_id = city.country_id
ORDER BY RANDOM()
LIMIT 100;


INSERT INTO dim_inventory(
						inventory_id,
						category_name,
						title,
						description,
						release_year,
						rental_duration,
						rental_rate,
						length,
						replacement_cost,
						rating,
						fulltext)
SELECT inventory_id,
		category.name AS category_name,
		film.title,
		film.description,
		film.release_year,
		film.rental_duration,
		film.rental_rate, 
		film.length, 
		film.replacement_cost,
		film.rating,
		film.fulltext	
FROM inventory
INNER JOIN film ON film.film_id = inventory.film_id
INNER JOIN film_category ON film_category.film_id = film.film_id
INNER JOIN category ON category.category_id = film_category.category_id
ORDER BY RANDOM()
LIMIT 100;


INSERT INTO dim_staff(
					staff_id,
					first_name,
					last_name,
					email,
					address,
					address2,
					district,
					city,
					country,
					postal_code,
					phone,
					store_id,
					username,
					password,
					picture,
					active)	
SELECT staff_id,
		first_name,
		last_name,
		email,
		address.address,
		address.address2,
		address.district,
		city.city,
		country.country,
		address.postal_code,
		address.phone,
		store_id,
		username,
		password,
		picture,
		active
FROM staff
INNER JOIN address ON address.address_id = staff.address_id
INNER JOIN city ON city.city_id = address.city_id
INNER JOIN country ON country.country_id = city.country_id
ORDER BY RANDOM()
LIMIT 100;


INSERT INTO rental_fact(
						rental_id,
						inventory_id,
						customer_id,
						staff_id,
						rental_date,
						return_date,
						payment_amount,
						payment_date)
SELECT rental.rental_id,
		inventory_id,
		rental.customer_id,
		rental.staff_id,
		rental_date,
		return_date,
		payment.amount AS payment_amount,
		payment.payment_date
FROM rental
INNER JOIN payment ON payment.rental_id = rental.rental_id
ORDER BY RANDOM()
LIMIT 100;