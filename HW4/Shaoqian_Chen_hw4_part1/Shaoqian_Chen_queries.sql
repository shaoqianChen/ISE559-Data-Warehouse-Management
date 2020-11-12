#Shaoqian Chen
#USC ID: 8831737894
#INF559 HW4

#Question 1

WITH table1 AS(
SELECT category_id,count(category_id)
	FROM film_category
	GROUP by category_id
	ORDER BY count DESC)
	
SELECT category.name, table1.count
FROM table1
INNER JOIN category
ON category.category_id = table1.category_id;




#Question 2

DROP TABLE IF EXISTS q2;
CREATE TABLE Q2
AS(
	SELECT film_category.film_id,category.category_id,category.name,film.rental_rate
	FROM category
	INNER JOIN film_category ON category.category_id=film_category.category_id
	INNER JOIN film ON film.film_id = film_category.film_id
	ORDER BY category_id ASC);

SELECT name AS "Film_category", 
	   AVG(rental_rate) AS "Average_Rating"
FROM q2
GROUP BY "Film_category"
ORDER BY "Average_Rating" DESC;





#Question 3

WITH table3_1 AS (
	WITH table3 AS(
		SELECT inventory_id,count(inventory_id)
		FROM rental
		GROUP BY inventory_id
		ORDER BY count DESC)
	SELECT film.title,table3.inventory_id,table3.count
	FROM table3
	INNER JOIN inventory ON inventory.inventory_id = table3.inventory_id
	INNER JOIN film ON film.film_id = inventory.film_id
	ORDER BY inventory_id)
SELECT title AS "Film_Title",
	   sum(count) AS "Num_Rented"
FROM table3_1
GROUP BY "Film_Title"
ORDER BY "Num_Rented" DESC
LIMIT 5;




#Question 4

SELECT
	film.title AS "Film Title",
	category.name AS "Film Genre/Category",
	SUM(payment.amount) AS "Total_Sales_Amount"
FROM payment
INNER JOIN rental ON rental.rental_id = payment.rental_id
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film ON film.film_id = inventory.film_id
INNER JOIN film_category ON film_category.film_id = film.film_id
INNER JOIN category ON category.category_id = film_category.category_id
GROUP BY 
	"Film Title",
	"Film Genre/Category"
ORDER BY "Total_Sales_Amount" DESC
LIMIT 10;
	





# Question 5

WITH table5 AS(
	SELECT category.name AS category_name,
           NTILE(4) OVER(ORDER BY film.rental_duration) AS Q
    FROM category
    INNER JOIN film_category ON category.category_id = film_category.category_id
    INNER JOIN film ON film_category.film_id = film.film_id
    WHERE category.name LIKE 'Animation'
          OR category.name LIKE 'Comedy'
          OR category.name LIKE 'Music')

SELECT table5 .category_name AS "Film Category",
       table5 .Q AS "Rental Length Quartile",
       COUNT(*) AS "Count"
FROM table5 
GROUP BY 1,2
ORDER BY 1,2;







#Question 6
DROP TABLE IF EXISTS q6;
CREATE TABLE q6 
AS
	(SELECT
		actor.actor_id,
		actor.first_name AS First_Name,
		actor.last_name AS Last_Name,
		customer.email AS Customer_Email_ID,
		COUNT(*) AS Num_Rented
	FROM customer
	INNER JOIN rental ON rental.customer_id = customer.customer_id
	INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
	INNER JOIN film_actor ON film_actor.film_id = inventory.film_id
	INNER JOIN actor ON actor.actor_id = film_actor.actor_id
	GROUP BY
		Customer_Email_ID,
		actor.actor_id
	ORDER BY 
		Customer_Email_ID ASC,
		Num_Rented DESC);


DROP TABLE IF EXISTS q6_maxed;
CREATE TABLE q6_maxed 
AS
	(SELECT customer_email_id,
			MAX(q6.num_rented) AS max_rented
	 FROM q6
     GROUP BY customer_email_id);

WITH table6_3 AS(
SELECT 
	q6_maxed.customer_email_id,
	q6.first_name,
	q6.last_name,
	q6_maxed.max_rented,
	ROW_NUMBER() OVER(PARTITION BY q6_maxed.customer_email_id ORDER BY q6_maxed.max_rented DESC) AS rk
FROM
	q6
INNER JOIN q6_maxed ON
	q6_maxed.max_rented = q6.num_rented AND
	q6_maxed.customer_email_id = q6.customer_email_id
ORDER BY max_rented DESC)
SELECT customer_email_id, first_name, last_name,max_rented
FROM table6_3
WHERE rk = 1;

