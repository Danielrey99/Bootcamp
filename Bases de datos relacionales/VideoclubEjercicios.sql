--Muy fácil
--1 .Devuelve todas las películas
SELECT * FROM movies
--2. Devuelve todos los géneros existentes
SELECT * FROM genres
--3. Devuelve la lista de todos los estudios de grabación que estén activos
SELECT * FROM studios WHERE studio_active = 1
--4. Devuelve una lista de los 20 últimos miembros en anotarse al videoclub
SELECT TOP 20 * FROM members
ORDER BY member_discharge_date DESC

--Fácil
--5. Devuelve las 20 duraciones de películas más frecuentes, ordenados de mayor a menor.
SELECT TOP 20 movie_duration, COUNT(*) AS num
FROM movies
GROUP BY movie_duration
ORDER BY num DESC
--6. Devuelve las películas del año 2000 en adelante que empiecen por la letra A.
SELECT * FROM movies 
WHERE YEAR(movie_launch_date) = 2000
AND movie_name LIKE 'A%'
--7. Devuelve los actores nacidos un mes de Junio
SELECT * FROM actors
WHERE MONTH(actor_birth_date) = 6
--8. Devuelve los actores nacidos cualquier mes que no sea Junio y que sigan vivos.
SELECT * FROM actors 
WHERE actor_dead_date IS NULL
AND MONTH(actor_birth_date) != 6
--9. Devuelve el nombre y la edad de todos los directores menores o iguales de 50 años que estén vivos
SELECT director_name, DATEDIFF(YEAR,director_birth_date,CURDATE()) AS edad 
FROM directors
WHERE DATEDIFF(YEAR,director_birth_date,CURDATE()) <= 50
AND director_dead_date IS NULL
--10. Devuelve el nombre y la edad de todos los actores menores de 50 años que hayan fallecido
SELECT actor_name, DATEDIFF(YEAR,actor_birth_date,actor_dead_date) AS edad 
FROM actors
WHERE DATEDIFF(YEAR,actor_birth_date,CURDATE()) < 50
AND actor_dead_date IS NOT NULL
--11. Devuelve el nombre de todos los directores menores o iguales de 40 años que estén vivos
SELECT director_name FROM directors
WHERE DATEDIFF(YEAR,director_birth_date,CURDATE()) <= 40
AND director_dead_date IS NULL
--12. Indica la edad media de los directores vivos
SELECT AVG(DATEDIFF(YEAR,director_birth_date,CURDATE())) AS media FROM directors
WHERE director_dead_date IS NULL
--13. Indica la edad media de los actores que han fallecido
SELECT AVG(DATEDIFF(YEAR,actor_birth_date,actor_dead_date)) AS media FROM actors
WHERE actor_dead_date IS NOT NULL

--Media
--14. Devuelve el nombre de todas las películas y el nombre del estudio que las ha realizado
SELECT movie_name, studio_name FROM movies
JOIN studios ON movies.studio_id = studios.studio_id
--15. Devuelve los miembros que alquilaron al menos una película entre el año 2010 y el 2015
SELECT member_name, member_rental_date FROM members
JOIN members_movie_rental ON members.member_id = members_movie_rental.member_id
WHERE YEAR(member_rental_date) BETWEEN 2010 AND 2015
--16. Devuelve cuantas películas hay de cada país
SELECT nationality_name, COUNT(movies.movie_id) FROM movies 
JOIN nationalities ON movies.nationality_id = nationalities.nationality_id
GROUP BY nationality_name
--17. Devuelve todas las películas que hay de género documental
SELECT * FROM movies
JOIN genres ON movies.genre_id = genres.genre_id
WHERE genre_name = 'Documentary'
--18. Devuelve todas las películas creadas por directores nacidos a partir de 1980 y que todavía están vivos
SELECT * FROM movies
JOIN directors ON movies.director_id = directors.director_id
WHERE YEAR(director_birth_date) >= 1980
AND director_dead_date IS NULL
--19. Indica si hay alguna coincidencia de nacimiento de ciudad (y si las hay, indicarlas) entre los miembros del videoclub y los directores.
SELECT director_name, member_name, director_birth_place, member_town
FROM directors
JOIN members ON director_birth_place = member_town
--20. Devuelve el nombre y el año de todas las películas que han sido producidas por un estudio que actualmente no esté activo
SELECT movie_name, YEAR(movie_launch_date) AS anho FROM movies
JOIN studios ON movies.studio_id = studios.studio_id
WHERE studio_active = 0
--21. Devuelve una lista de las últimas 10 películas que se han alquilado
SELECT movies.movie_name, member_rental_date
FROM movies
JOIN members_movie_rental ON movies.movie_id = members_movie_rental.movie_id
ORDER BY members_movie_rental.member_rental_date DESC
LIMIT 10
--22. Indica cuántas películas ha realizado cada director antes de cumplir 41 años
SELECT director_name, COUNT(movie_id) AS num
FROM directors
JOIN movies ON directors.director_id = movies.director_id
WHERE DATEDIFF(YEAR,director_birth_date,CURDATE())  < 41
GROUP BY director_name
--23. Indica cuál es la media de duración de las películas de cada director
SELECT directors.director_name, AVG(movies.movie_duration) AS media
FROM directors
JOIN movies ON directors.director_id = movies.director_id
GROUP BY directors.director_name
--24. Indica cuál es el nombre y la duración mínima de la película que ha sido alquilada en los últimos 2 años por los miembros del videoclub (La "fecha de ejecución" en este script es el 25-01-2019)
SELECT movies.movie_name, MIN(movies.movie_duration) AS min_duracion
FROM movies
JOIN members_movie_rental ON movies.movie_id = members_movie_rental.movie_id
WHERE members_movie_rental.member_rental_date >= '2019-01-25'
GROUP BY movies.movie_name
--25. Indica el número de películas que hayan hecho los directores durante las décadas de los 60, 70 y 80 que contengan la palabra "The" en cualquier parte del título
SELECT directors.director_name, COUNT(*) AS num
FROM directors
JOIN movies ON directors.director_id = movies.director_id
WHERE YEAR(movies.movie_launch_date) BETWEEN 1960 AND 1989
AND movies.movie_name LIKE '%The%'
GROUP BY directors.director_name

--Difícil
--26. Lista nombre, nacionalidad y director de todas las películas
SELECT movies.movie_name, nationalities.nationality_name, directors.director_name
FROM movies
JOIN nationalities ON movies.nationality_id = nationalities.nationality_id
JOIN directors ON movies.director_id = directors.director_id
--27. Muestra las películas con los actores que han participado en cada una de ellas
SELECT movies.movie_name,GROUP_CONCAT(actors.actor_name SEPARATOR ', ') AS all_actors
FROM movies
JOIN movies_actors ON movies.movie_id = movies_actors.movie_id
JOIN actors ON movies_actors.actor_id = actors.actor_id
GROUP BY movies.movie_name
--28. Indica cual es el nombre del director del que más películas se han alquilado
SELECT directors.director_name, COUNT(members_movie_rental.member_movie_rental_id) AS num FROM directors
JOIN movies ON directors.director_id = movies.director_id
JOIN members_movie_rental ON movies.movie_id = members_movie_rental.movie_id
GROUP BY directors.director_name
ORDER BY num DESC
LIMIT 1
--29. Indica cuantos premios han ganado cada uno de los estudios con las películas que han creado
SELECT studios.studio_name, SUM(awards.award_win) AS award_sum
FROM studios
JOIN movies ON studios.studio_id = movies.studio_id
JOIN awards ON movies.movie_id = awards.movie_id
GROUP BY studios.studio_name
--30. Indica el número de premios a los que estuvo nominado un actor, pero que no ha conseguido (Si una película está nominada a un premio, su actor también lo está)
SELECT actor_name, SUM(award_nomination - award_id) AS nomination_sum_not_win FROM actors
JOIN movies_actors ON actors.actor_id = movies_actors.actor_id
JOIN movies ON movies_actors.movie_id = movies.movie_id
JOIN awards ON movies.movie_id = awards.movie_id
GROUP BY actor_name
--31. Indica cuantos actores y directores hicieron películas para los estudios no activos

--32. Indica el nombre, ciudad, y teléfono de todos los miembros del videoclub que hayan alquilado películas que hayan sido nominadas a más de 150 premios y ganaran menos de 50

--33. Comprueba si hay errores en la BD entre las películas y directores (un director fallecido en el 76 no puede dirigir una película en el 88)
SELECT directors.director_name, directors.director_dead_date, movies.movie_name, movies.movie_launch_date
FROM directors
JOIN movies ON directors.director_id = movies.director_id
WHERE directors.director_dead_date IS NOT NULL 
AND movies.movie_launch_date > directors.director_dead_date
--34. Utilizando la información de la sentencia anterior, modifica la fecha de defunción a un año más tarde del estreno de la película (mediante sentencia SQL)


--Berserk mode (enunciados simples, mucha diversión...)
--35. Indica cuál es el género favorito de cada uno de los directores cuando dirigen una película

--36. Indica cuál es la nacionalidad favorita de cada uno de los estudios en la producción de las películas

--37. Indica cuál fue la primera película que alquilaron los miembros del videoclub cuyos teléfonos tengan como último dígito el ID de alguna nacionalidad

