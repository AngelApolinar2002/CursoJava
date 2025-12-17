-- TABLAS
CREATE TABLE departamentos (
    id_depto NUMBER PRIMARY KEY,
    nombre_depto VARCHAR2(50)
);

CREATE TABLE empleados (
 id_empleado NUMBER PRIMARY KEY,
 nombre VARCHAR2(50),
 salario NUMBER,
 id_depto NUMBER,
 fecha_ingreso DATE
);

CREATE TABLE proyectos (
 id_proyecto NUMBER PRIMARY KEY,
 nombre_proyecto VARCHAR2(100),
 presupuesto NUMBER,
 fecha_inicio DATE
);

CREATE TABLE asignaciones (
 id_empleado NUMBER,
 id_proyecto NUMBER,
 horas_asignadas NUMBER,
 PRIMARY KEY (id_empleado, id_proyecto)
);

-- DATOS
INSERT INTO departamentos VALUES (1, 'IT');
INSERT INTO departamentos VALUES (2, 'Ventas');
INSERT INTO departamentos VALUES (3, 'Recursos Humanos');

INSERT INTO empleados VALUES (101, 'Alice Smith', 5000, 1, TO_DATE('2022-01-15', 'YYYY-MM-DD'));
INSERT INTO empleados VALUES (102, 'Bob Jones', 4500, 1, TO_DATE('2023-05-20', 'YYYY-MM-DD'));
INSERT INTO empleados VALUES (103, 'Charlie Brown', 3000, 2, TO_DATE('2021-11-10', 'YYYY-MM-DD'));
INSERT INTO empleados VALUES (104, 'David Wilson', 3500, NULL, TO_DATE('2023-12-01', 'YYYY-MM-DD'));
INSERT INTO proyectos VALUES (501, 'Migración Cloud', 100000, TO_DATE('2023-01-01', 'YYYY-MM-DD'));

INSERT INTO proyectos VALUES (502, 'Portal Web', 50000, TO_DATE('2023-06-15', 'YYYY-MM-DD'));
INSERT INTO proyectos VALUES (503, 'App Móvil', 30000, TO_DATE('2024-02-01', 'YYYY-MM-DD'));

INSERT INTO asignaciones VALUES (101, 501, 20);
INSERT INTO asignaciones VALUES (101, 502, 10);
INSERT INTO asignaciones VALUES (102, 501, 40);
COMMIT;

-- Bloque A: Rangos y Fechas (Básico)

-- 1. Empleados que ingresaron entre el 01/01/2022 y el 31/12/2022 (usando BETWEEN).
SELECT id_empleado, nombre, fecha_ingreso
FROM empleados
WHERE fecha_ingreso BETWEEN DATE '2022-01-01' AND DATE '2022-12-31';

-- 101,Alice Smith,2022-01-15

-- 2. Proyectos que iniciaron en el año 2023
SELECT id_proyecto, nombre_proyecto, fecha_inicio
FROM proyectos
WHERE EXTRACT(YEAR FROM fecha_inicio) = 2023;

-- 501,Migración Cloud,2023-01-01
-- 502,Portal Web,2023-06-15

-- 3. Empleados con salario en el rango de 3000 a 4500.
SELECT id_empleado, nombre, salario
FROM empleados
WHERE salario BETWEEN 3000 AND 4500;

-- 102,Bob Jones,4500
-- 103,Charlie Brown,3000
-- 104,David Wilson,3500

-- 4. Nombre del empleado y nombre del mes de ingreso.
SELECT nombre,
TO_CHAR(fecha_ingreso, 'Month', 'NLS_DATE_LANGUAGE=SPANISH') AS mes_ingreso
FROM empleados;

-- Alice Smith,Enero
-- Bob Jones,Mayo
-- Charlie Brown,Noviembre
-- David Wilson,Diciembre

-- 5. Empleados con más de 1 año de antigüedad.
SELECT id_empleado, nombre, fecha_ingreso
FROM empleados
WHERE MONTHS_BETWEEN(SYSDATE, fecha_ingreso) > 12;

-- 101,Alice Smith,2022-01-15
-- 102,Bob Jones,2023-05-20
-- 103,Charlie Brown,2021-11-10
-- 104,David Wilson,2023-12-01

--  Bloque B: Joins y Filtros Combinados

-- 6. Nombre del empleado y su departamento para salarios entre 4000 y 6000.
SELECT e.nombre AS empleado, d.nombre_depto AS departamento
FROM empleados e
JOIN departamentos d ON e.id_depto = d.id_depto
WHERE e.salario BETWEEN 4000 AND 6000;

-- Alice Smith,IT
-- Bob Jones,IT

-- 7. Empleados de 'IT' que ingresaron antes del 2023.
SELECT e.nombre, e.fecha_ingreso
FROM empleados e
JOIN departamentos d ON e.id_depto = d.id_depto
WHERE d.nombre_depto = 'IT'
AND e.fecha_ingreso < DATE '2023-01-01';

-- Alice Smith,2022-01-15

-- 8. Proyectos donde trabajan empleados que ingresaron en 2021.
SELECT DISTINCT p.nombre_proyecto
FROM proyectos p
JOIN asignaciones a ON p.id_proyecto = a.id_proyecto
JOIN empleados e ON a.id_empleado = e.id_empleado
WHERE EXTRACT(YEAR FROM e.fecha_ingreso) = 2021;

-- SIN RESULTADO

-- 9. Departamentos y empleados contratados después de junio de 2022.
SELECT d.nombre_depto, e.nombre AS empleado, e.fecha_ingreso
FROM empleados e
JOIN departamentos d ON e.id_depto = d.id_depto
WHERE e.fecha_ingreso > DATE '2022-06-30';

-- IT,Bob Jones,2023-05-20

-- 10. Empleados trabajando en proyectos que iniciaron después de su ingreso.
SELECT e.nombre AS empleado, p.nombre_proyecto, e.fecha_ingreso, p.fecha_inicio
FROM empleados e
JOIN asignaciones a ON e.id_empleado = a.id_empleado
JOIN proyectos p ON a.id_proyecto = p.id_proyecto
WHERE p.fecha_inicio > e.fecha_ingreso;

-- Alice Smith,Portal Web,2022-01-15,2023-06-15
-- Alice Smith,Migración Cloud,2022-01-15,2023-01-01

-- Bloque C: Agregación con Fechas y Rangos

-- 11. Salario promedio de empleados contratados entre 2021 y 2023.
SELECT AVG(salario) AS salario_promedio
FROM empleados
WHERE fecha_ingreso BETWEEN DATE '2021-01-01' AND DATE '2023-12-31';

-- 4000

-- 12. Contar cuántos empleados ingresaron por cada año.
SELECT EXTRACT(YEAR FROM fecha_ingreso) AS anio_ingreso,
COUNT(*) AS cantidad_empleados
FROM empleados
GROUP BY EXTRACT(YEAR FROM fecha_ingreso)
ORDER BY anio_ingreso;

-- 2021,1
-- 2022,1
-- 2023,2


-- 13. Presupuesto total de proyectos que iniciaron en el primer semestre de 2023.
SELECT SUM(presupuesto) AS presupuesto_total
FROM proyectos
WHERE fecha_inicio BETWEEN DATE '2023-01-01' AND DATE '2023-06-30';

-- 150000

-- 14. Fecha de ingreso más reciente de empleados del departamento 'Ventas'.
SELECT MAX(e.fecha_ingreso) AS fecha_mas_reciente
FROM empleados e
JOIN departamentos d ON e.id_depto = d.id_depto
WHERE d.nombre_depto = 'Ventas';

-- 2021-11-10

-- 15. Departamentos con gasto salarial > 4000 considerando solo empleados con salario entre 2000 y 5000.
SELECT d.nombre_depto, SUM(e.salario) AS gasto_salarial
FROM empleados e
JOIN departamentos d ON e.id_depto = d.id_depto
WHERE e.salario BETWEEN 2000 AND 5000
GROUP BY d.nombre_depto
HAVING SUM(e.salario) > 4000;

-- IT,9500

-- Bloque D: Subconsultas y Lógica Avanzada

-- 16. Empleados que ganan más que el promedio de los contratados en 2023.
SELECT nombre, salario
FROM empleados
WHERE salario > (
    SELECT AVG(salario)
    FROM empleados
    WHERE EXTRACT(YEAR FROM fecha_ingreso) = 2023
);

-- Alice Smith,5000
-- Bob Jones,4500

-- 17. Proyectos con presupuesto mayor al promedio de los iniciados en 2023.
SELECT nombre_proyecto, presupuesto
FROM proyectos
WHERE presupuesto > (
    SELECT AVG(presupuesto)
    FROM proyectos
    WHERE EXTRACT(YEAR FROM fecha_inicio) = 2023
);

-- Migración Cloud,100000

-- 18. Empleados que no están asignados a proyectos iniciados en 2024.
SELECT e.nombre
FROM empleados e
WHERE e.id_empleado NOT IN (
    SELECT a.id_empleado
    FROM asignaciones a
    JOIN proyectos p ON a.id_proyecto = p.id_proyecto
    WHERE EXTRACT(YEAR FROM p.fecha_inicio) = 2024
);

-- Alice Smith
-- Bob Jones
-- Charlie Brown
-- David Wilson

-- 19. Empleado que ingresó primero (fecha mínima).
SELECT nombre, fecha_ingreso
FROM empleados
WHERE fecha_ingreso = (
    SELECT MIN(fecha_ingreso)
    FROM empleados
);

-- Charlie Brown,2021-11-10

-- 20. Departamentos con empleados contratados en el último trimestre de cualquier año (usando EXISTS).
SELECT DISTINCT d.nombre_depto
FROM departamentos d
WHERE EXISTS (
    SELECT 1
    FROM empleados e
    WHERE e.id_depto = d.id_depto
      AND TO_CHAR(e.fecha_ingreso, 'MM') IN ('10','11','12')
);

-- Ventas

-- 21. Empleados y salario, solo de departamentos con al menos un empleado ingresado en 2021.
SELECT e.nombre, e.salario
FROM empleados e
WHERE e.id_depto IN (
    SELECT DISTINCT id_depto
    FROM empleados
    WHERE EXTRACT(YEAR FROM fecha_ingreso) = 2021
);

-- Charlie Brown,3000

-- Bloque E: Desafíos Finales (Joins + Subconsultas + Fechas)

-- 22.Nombre de empleado, proyecto y duración en días desde inicio hasta hoy.
SELECT e.nombre AS empleado,
       p.nombre_proyecto,
       TRUNC(SYSDATE - p.fecha_inicio) AS dias_duracion
FROM empleados e
JOIN asignaciones a ON e.id_empleado = a.id_empleado
JOIN proyectos p ON a.id_proyecto = p.id_proyecto;

-- Alice Smith,Migración Cloud,1081
-- Alice Smith,Portal Web,916
-- Bob Jones,Migración Cloud,1081

-- 23. Empleados en proyectos con presupuesto entre 50,000 y 150,000.
SELECT DISTINCT e.nombre
FROM empleados e
JOIN asignaciones a ON e.id_empleado = a.id_empleado
JOIN proyectos p ON a.id_proyecto = p.id_proyecto
WHERE p.presupuesto BETWEEN 50000 AND 150000;

-- Alice Smith
-- Bob Jones

-- 24. Nombre de cada departamento y cuántos proyectos activos tienen.
SELECT d.nombre_depto, COUNT(DISTINCT p.id_proyecto) AS proyectos_activos
FROM departamentos d
JOIN empleados e ON d.id_depto = e.id_depto
JOIN asignaciones a ON e.id_empleado = a.id_empleado
JOIN proyectos p ON a.id_proyecto = p.id_proyecto
GROUP BY d.nombre_depto;

-- IT,2

-- 25. Proyecto con presupuesto más alto entre los iniciados antes de julio 2023.
SELECT nombre_proyecto, presupuesto
FROM proyectos
WHERE fecha_inicio < DATE '2023-07-01'
ORDER BY presupuesto DESC
FETCH FIRST 1 ROWS ONLY;

-- Migración Cloud,100000

-- 26. Empleados cuyo salario es mayor al de cualquier empleado contratado antes de 2022.
SELECT nombre, salario
FROM empleados
WHERE salario > ALL (
    SELECT salario
    FROM empleados
    WHERE fecha_ingreso < DATE '2022-01-01'
);

-- David Wilson,3500
-- Bob Jones,4500
-- Alice Smith,5000

-- 27. Departamento que contrató más personal en 2023.
SELECT d.nombre_depto, COUNT(*) AS cantidad
FROM empleados e
JOIN departamentos d ON e.id_depto = d.id_depto
WHERE EXTRACT(YEAR FROM e.fecha_ingreso) = 2023
GROUP BY d.nombre_depto
ORDER BY cantidad DESC
FETCH FIRST 1 ROWS ONLY;

-- IT,1

-- 28. Consulta con formato: "El empleado [Nombre] ingresó el [Día] de [Mes] de [Año]".
SELECT 'El empleado ' || nombre || ' ingresó el ' ||
       TO_CHAR(fecha_ingreso, 'DD') || ' de ' ||
       TO_CHAR(fecha_ingreso, 'Month', 'NLS_DATE_LANGUAGE=SPANISH') || ' de ' ||
       TO_CHAR(fecha_ingreso, 'YYYY') AS mensaje
FROM empleados;

-- El empleado Alice Smith ingresó el 15 de Enero      de 2022
-- El empleado Bob Jones ingresó el 20 de Mayo       de 2023
-- El empleado Charlie Brown ingresó el 10 de Noviembre  de 2021
-- El empleado David Wilson ingresó el 01 de Diciembre  de 2023

-- 29. Empleados que trabajan en más de un proyecto iniciado en el mismo año.
SELECT e.nombre
FROM empleados e
JOIN asignaciones a ON e.id_empleado = a.id_empleado
JOIN proyectos p ON a.id_proyecto = p.id_proyecto
GROUP BY e.nombre, EXTRACT(YEAR FROM p.fecha_inicio)
HAVING COUNT(DISTINCT p.id_proyecto) > 1;

-- Alice Smith

-- 30. Empleado con más horas asignadas en proyectos iniciados hace menos de 2 años.
SELECT e.nombre, SUM(a.horas_asignadas) AS total_horas
FROM empleados e
JOIN asignaciones a ON e.id_empleado = a.id_empleado
JOIN proyectos p ON a.id_proyecto = p.id_proyecto
WHERE MONTHS_BETWEEN(SYSDATE, p.fecha_inicio) < 24
GROUP BY e.nombre
ORDER BY total_horas DESC
FETCH FIRST 1 ROWS ONLY;

-- SIN RESULTADO