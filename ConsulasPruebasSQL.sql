-- crear base de datos
CREATE DATABASE prueba-sql ;


-- crear tablas peliculas y tags
CREATE TABLE peliculas (
    id INTEGER PRIMARY KEY , 
    nombre VARCHAR(225), 
    anno INTEGER
    ) ;

CREATE TABLE tags (
    id INTEGER PRIMARY KEY,
    tag VARCHAR(32),
    peliculas_id INTEGER,
    FOREIGN KEY (peliculas_id)
    REFERENCES peliculas(id)
    );
-- insertar datos de tablas peliculas y tags

INSERT INTO peliculas (id, nombre, anno) VALUES
(1, 'Dune', 2021),
(2, 'No Time to Die', 2021),
(3, 'Spider-Man: No Way Home', 2021),
(4, 'The Batman', 2022),
(5, 'Avatar: The Way of Water', 2022);

INSERT INTO tags (id, tag, peliculas_id) VALUES
(1, 'Sci-Fi', 1),
(2, 'Action', 1),
(3, 'Superhero', 2),
(4, 'Mystery', 1),
(5, 'Fantasy', 2);

-- contar la cantidad de tags que tiene vcada pelicula, si la pelicula no tiene tag debe mostrar 0

SELECT p.nombre, COUNT(t.id) AS tags_total
    FROM peliculas p 
    LEFT JOIN tags t ON p.id = t.peliculas_id
    GROUP BY p.id, p.nombre ;

    
-- crear tablas preguntas, respuestas y usuarios
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255),
    edad INTEGER
);

CREATE TABLE preguntas (
    id INTEGER PRIMARY KEY,
    pregunta VARCHAR(255),
    respuesta_correcta VARCHAR
);

CREATE TABLE respuestas (
    id INTEGER PRIMARY KEY,
    respuesta VARCHAR(255),
    usuario_id INTEGER,
    pregunta_id INTEGER,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (pregunta_id) REFERENCES preguntas(id) 
);

-- insertar datos en tablas usuarios, preguntas y respuestas

INSERT INTO usuarios (id, nombre, edad) VALUES
(1, 'Juan Perez', 25),
(2, 'Ana Gomez', 22),
(3, 'Luis Martinez', 30),
(4, 'Maria Rodriguez', 28),
(5, 'Carlos Sanchez', 35);

INSERT INTO preguntas (id, pregunta, respuesta_correcta) VALUES
(1, '¿Cuál es la raíz cuadrada de 16?', '4'),
(2, '¿Qué planeta es conocido como el Planeta Rojo?', 'Marte'),
(3, '¿Cuántos lados tiene un hexágono?', '6'),
(4, '¿Cuál es el elemento químico con símbolo O?', 'Oxígeno'),
(5, '¿Qué gas se encuentra en mayor proporción en la atmósfera terrestre?', 'Nitrógeno');


INSERT INTO respuestas (id, respuesta, usuario_id, pregunta_id) VALUES
(1, '4', 1, 1),
(2, '4', 2, 1);

INSERT INTO respuestas (id, respuesta, usuario_id, pregunta_id) VALUES
(3, 'Marte', 3, 2);

INSERT INTO respuestas (id, respuesta, usuario_id, pregunta_id) VALUES
(4, '5', 4, 3), -- Incorrecta para la pregunta 3
(5, 'Hidrógeno', 5, 4), -- Incorrecta para la pregunta 4
(6, 'Oxígeno', 1, 5); -- Incorrecta para la pregunta 5

-- contar cantidad de respuestas correctas totales por usuario.Independiente de la pregunta

SELECT u.nombre, COUNT(r.id) AS respuestas_correctas_totales
FROM usuarios u
LEFT JOIN respuestas r ON u.id = r.usuario_id
LEFT JOIN preguntas p ON r.pregunta_id = p.id
WHERE r.respuesta = p.respuesta_correcta
GROUP BY u.id, u.nombre;

-- por cada pregunta en la tabla preguntas , contar cuantos usuarios respondieron correctamente 

SELECT p.pregunta, COALESCE(COUNT(r.id),0) AS respuestas_correctas
    FROM preguntas p 
    LEFT JOIN  respuestas r ON p.id = r.pregunta_id AND r.respuesta = p.respuesta_correcta
    GROUP BY p.id, p.pregunta;

-- implementar borrado en cascada y prueba de borra usuario
-- borrado en cascada aplicado al momento de crear la tabla de respuestas
DELETE FROM usuarios WHERE id= 1 ;

-- crear restriccion de esad para menores de 18 años
ALTER TABLE usuarios
ADD CONSTRAINT verificar_edad CHECK (edad >= 18);

-- alterar la tabla existente de usuarios para agregar campo email, con restriccion de ser unico
ALTER TABLE usuarios
ADD email VARCHAR(255) UNIQUE ;

-- link de video explicativo
https://youtu.be/V224wXNsKS8?si=TwiGkQSu-GU07tbB