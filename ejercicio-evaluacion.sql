USE sakila;
/* 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados. 
Utilizo la clausula distint para seleccionar valores unicos de una columna en este caso title*/

SELECT DISTINCT title   
FROM film;

/* Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".*/

SELECT title, rating
FROM film
WHERE rating = "PG-13";

/* 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
Uso el operador de filtro LIKE que busca el patron amazing y le pongo comodin % delante y detras para que lo filtre teniendo letras delante y detras*/

SELECT title, description
FROM film 
WHERE description LIKE "%amazing%";

/*4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.*/

SELECT title,length
FROM film
WHERE length > 120;

/*5. Recupera los nombres de todos los actores.
Uso la funcion Concat para unir 2 registros de una fila en uno solo*/

SELECT first_name
FROM actor;

/* 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.*/

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE "%Gibson%";

/* 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
Uso la clausula Between para seleccionar registros con valores que se encuentren dentro de un rango*/

SELECT actor_id, first_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

/* 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
Uso operador de comparación NOT IN para filtrar valores en las filas y excluir el valor que le indico*/

SELECT title, rating
FROM film
WHERE rating NOT IN("R","PG-13");

/* 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
Uso la funcion agregada COUNT para contar los valores de cada grupo y luego uso group by para agrupar filas en funcion de los valores*/

SELECT rating,COUNT(rating) AS total_rating
FROM film
GROUP BY rating;

/*10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
utilizo la sentencia JOIN para unir las dos tablas por la columna Customer ID */

SELECT c.customer_id, c.first_name, c.last_name, COUNT(rental_id) AS total_peliculas_alquiladas
FROM rental AS r 
INNER JOIN customer AS c
ON c.customer_id = r.customer_id
GROUP BY customer_id;

/*11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres
consulto el diagrama entidad relacion para ver que tablas necesito consultar y como se relacionan y veo que son cinco tablas, la uno con Inner join 
*/

SELECT c.name, COUNT(r.rental_id) AS total_peliculas_alquiladas
FROM rental AS r
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film AS f ON i.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
GROUP BY c.name;

/*12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y
 muestra la clasificación junto con el promedio de duración.*/
 
 SELECT rating, AVG(length) AS promedio_duracion_peliculas
 FROM film
 GROUP BY rating;
 
 /* 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
 compruebo que tablas tengo que usar para encontrar la relacion, son film, actor y film actor */
 
SELECT a.first_name, a.last_name, f.title
FROM film AS f
INNER JOIN film_actor AS fa ON f.film_id = fa.film_id
INNER JOIN actor AS a ON fa.actor_id = a.actor_id
WHERE f.title = "Indian Love";

/*14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.*/

SELECT title, description AS titulo_pelicula_con_dog_cat
FROM film 
WHERE description LIKE "%dog%" OR description LIKE "%cat%";

/*15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
uso el left join para coger solo los valores de la tabla izquierda actor, y 
le indico la condicion WHERE para que me muestre el valor de la tabla izquierda actor que sea nulo en la derecha film_actor 
*/

SELECT a.first_name, a.last_name
FROM actor AS a
LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL;


/* 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010*/

SELECT title, release_year AS año_lanzamiento
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

/*17. Encuentra el título de todas las películas que son de la misma categoría que "Family".*/

SELECT f.title, c.name
FROM film as f
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
WHERE c.name = "Family"; 

/*18.Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
identifico las tablas que voy a usar film, film_actor y actor las uno con inner join ,
uso la condicion having para filtrar en la columna peliculas y que me cuente y  muestre solo los resultados >= que 10 */

SELECT a.first_name, a.last_name, COUNT(f.film_id) AS num_peliculas_aparece
FROM film as f
INNER JOIN film_actor AS fa ON f.film_id = fa.film_id
INNER JOIN actor AS a ON fa.actor_id = a.actor_id
GROUP BY a.first_name, a.last_name
HAVING COUNT(f.film_id) >= 10;

/*19 Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film*/

SELECT title, rating, length
FROM film
WHERE rating = "R" AND length > 120;

/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y 
muestra el nombre de la categoría junto con el promedio de duración
identifico las tablas que necesito conectar que son Category, film category, film  uso inner join*/

SELECT c.name, AVG(f.length) AS promedio_duracion
FROM film AS f
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
GROUP BY c.name
HAVING AVG(f.length) > 120;

/*21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.*/

SELECT a.first_name,last_name, COUNT(fa.film_id) AS total_peliculas
FROM actor AS a
INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
GROUP BY a.first_name,last_name
HAVING COUNT(fa.film_id) >= 5;

/*22 Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes*/


-- primero creo la subconsulta con la funcion datediff calculo la diferencia de las fechas.

SELECT r.inventory_id
FROM rental AS r
WHERE DATEDIFF(r.return_date, rental_date) > 5;

-- ahora necesito llegar a unir de alguna forma mi tabla renta con film que es donde tengo los titulos de las peliculas
-- pero necesito hacer primero un inner join de film con category_film

SELECT DISTINCT(f.title)
FROM film AS f
INNER JOIN inventory AS i ON f.film_id = i.film_id
WHERE i.inventory_id IN (SELECT r.inventory_id
						FROM rental AS r
						WHERE DATEDIFF(r.return_date, rental_date) > 5)
                        ;

/*23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.*/

-- primero realizo la subconsulta para encontrar los actores que ha actuado en peliculas de categoria horror
-- uso INNER JOIN y uno las 4 tablas

SELECT fa.actor_id
FROM film_actor fa
INNER JOIN film as f ON fa.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
WHERE c.name = "Horror";

-- en segundo lugar tengo que usar la subconsulta sobre la tabla actor excluyo con NOT IN los id que tengo en la subconsulta.
SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id NOT IN (SELECT fa.actor_id
						FROM film_actor fa
						INNER JOIN film as f ON fa.film_id = f.film_id
						INNER JOIN film_category AS fc ON f.film_id = fc.film_id
						INNER JOIN category AS c ON fc.category_id = c.category_id
						WHERE c.name = "Horror");
                        

/*24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.
-- primero creo un CTE con las tablas category y film category que relaciona todo lo de categorias 
   llamada peliculas comedia que me selcciona solo las peliculas que son comedia. la cte la contruyo con 2 columnas
   
-- segundo tengo que unir o relacionar mi cte con la tabla film que tiene el titulo y la duracion de las peliculas comedia
    uso inner join para unir la cte con la tabla */

WITH peliculas_comedias AS (SELECT fc.film_id, c.name
							FROM category AS c
                            INNER JOIN film_category AS fc ON c.category_id = fc.category_id
                            WHERE c.name = "Comedy")
SELECT f.title , pc.name, f.length
FROM film AS f
INNER JOIN peliculas_comedias AS pc ON f.film_id = pc.film_id
WHERE f.length > 180;

/*25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. 
	 La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos*/


SELECT a.actor_id, a.first_name, a.last_name, fa1.actor_id, COUNT(fa1.film_id) AS peliculas_coincidentes
FROM actor AS a
INNER JOIN film_actor AS fa1 ON a.actor_id = fa1.actor_id
INNER JOIN film_actor AS fa2 ON a.actor_id = fa2.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;




                                





                            



































 
 
 































