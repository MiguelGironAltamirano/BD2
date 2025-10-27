--------------------------------------------------------------------------------
-- [5] INSERTS
--------------------------------------------------------------------------------
-- EQUIPOS
INSERT INTO EQUIPO (nombre, nacionalidad, director)
VALUES ('Movistar', 'España', 'Unzué');

INSERT INTO EQUIPO (nombre, nacionalidad, director)
VALUES ('Ineos Grenadiers', 'Reino Unido', 'Brailsford');

INSERT INTO EQUIPO (nombre, nacionalidad, director)
VALUES ('UAE Team Emirates', 'Emiratos Árabes', 'Mauro Gianetti');

-- CICLISTAS (asignan id_equipo por subconsulta)
INSERT INTO CICLISTA (nombre, nacionalidad, fecha_nac, id_equipo, inicio_contrato, fin_contrato)
VALUES (
  'Nairo Quintana', 'Colombia', DATE '1990-02-04',
  (SELECT id_equipo FROM EQUIPO WHERE nombre='Movistar'),
  DATE '2012-01-01', DATE '2019-12-31'
);

INSERT INTO CICLISTA (nombre, nacionalidad, fecha_nac, id_equipo, inicio_contrato, fin_contrato)
VALUES (
  'Egan Bernal', 'Colombia', DATE '1997-01-13',
  (SELECT id_equipo FROM EQUIPO WHERE nombre='Ineos Grenadiers'),
  DATE '2018-01-01', DATE '2024-12-31'
);

INSERT INTO CICLISTA (nombre, nacionalidad, fecha_nac, id_equipo, inicio_contrato, fin_contrato)
VALUES (
  'Tadej Pogacar', 'Eslovenia', DATE '1998-09-21',
  (SELECT id_equipo FROM EQUIPO WHERE nombre='UAE Team Emirates'),
  DATE '2019-01-01', DATE '2026-12-31'
);

-- PRUEBAS (ganador por subconsulta)
INSERT INTO PRUEBA (nombre, anio, etapas, km_totales, ganador)
VALUES ('Tour de Francia', 2020, 21, 3500,
        (SELECT id_ciclista FROM CICLISTA WHERE nombre='Egan Bernal'));

INSERT INTO PRUEBA (nombre, anio, etapas, km_totales, ganador)
VALUES ('Tour de Francia', 2021, 21, 3414,
        (SELECT id_ciclista FROM CICLISTA WHERE nombre='Tadej Pogacar'));

INSERT INTO PRUEBA (nombre, anio, etapas, km_totales, ganador)
VALUES ('Giro de Italia', 2014, 21, 3449,
        (SELECT id_ciclista FROM CICLISTA WHERE nombre='Nairo Quintana'));

-- PARTICIPACION (por nombres)
INSERT INTO PARTICIPACION (id_equipo, id_prueba, puesto_final)
VALUES (
  (SELECT id_equipo FROM EQUIPO WHERE nombre='Movistar'),
  (SELECT id_prueba FROM PRUEBA WHERE nombre='Giro de Italia' AND anio=2014),
  1
);

INSERT INTO PARTICIPACION (id_equipo, id_prueba, puesto_final)
VALUES (
  (SELECT id_equipo FROM EQUIPO WHERE nombre='Ineos Grenadiers'),
  (SELECT id_prueba FROM PRUEBA WHERE nombre='Tour de Francia' AND anio=2020),
  1
);

INSERT INTO PARTICIPACION (id_equipo, id_prueba, puesto_final)
VALUES (
  (SELECT id_equipo FROM EQUIPO WHERE nombre='UAE Team Emirates'),
  (SELECT id_prueba FROM PRUEBA WHERE nombre='Tour de Francia' AND anio=2021),
  1
);

INSERT INTO PARTICIPACION (id_equipo, id_prueba, puesto_final)
VALUES (
  (SELECT id_equipo FROM EQUIPO WHERE nombre='Movistar'),
  (SELECT id_prueba FROM PRUEBA WHERE nombre='Tour de Francia' AND anio=2020),
  5
);

--------------------------------------------------------------------------------
-- [6] CONSULTAS FRECUENTES
--------------------------------------------------------------------------------

-- Listado maestro
SELECT * FROM EQUIPO;
SELECT * FROM CICLISTA;
SELECT * FROM PRUEBA;
SELECT * FROM PARTICIPACION;

-- Ganadores (prueba + ganador)
SELECT p.id_prueba, p.nombre, p.anio, p.km_totales,
       c.nombre AS ganador
FROM   PRUEBA p
LEFT JOIN CICLISTA c ON c.id_ciclista = p.ganador
ORDER BY p.anio, p.nombre;

-- Contratos vigentes por equipo (hoy)
SELECT e.nombre AS equipo, c.nombre AS ciclista, c.inicio_contrato, c.fin_contrato
FROM   CICLISTA c
JOIN   EQUIPO e ON e.id_equipo = c.id_equipo
WHERE  (c.inicio_contrato IS NOT NULL AND (c.fin_contrato IS NULL OR c.fin_contrato >= TRUNC(SYSDATE)))
ORDER BY e.nombre, c.nombre;

-- Participaciones y puesto final
SELECT e.nombre AS equipo, p.nombre AS prueba, p.anio, pa.puesto_final
FROM   PARTICIPACION pa
JOIN   EQUIPO e ON e.id_equipo = pa.id_equipo
JOIN   PRUEBA p ON p.id_prueba = pa.id_prueba
ORDER BY p.anio, p.nombre, pa.puesto_final NULLS LAST;

-- Top equipos por podios (puestos 1-3)
SELECT e.nombre AS equipo, COUNT(*) AS podios
FROM   PARTICIPACION pa
JOIN   EQUIPO e ON e.id_equipo = pa.id_equipo
WHERE  pa.puesto_final BETWEEN 1 AND 3
GROUP  BY e.nombre
ORDER  BY podios DESC, e.nombre;

-- Kilómetros totales de pruebas ganadas por ciclista
SELECT c.nombre AS ciclista, SUM(pr.km_totales) AS km_ganados
FROM   PRUEBA pr
JOIN   CICLISTA c ON c.id_ciclista = pr.ganador
GROUP  BY c.nombre
ORDER  BY km_ganados DESC;

-- Pruebas por año (conteo)
SELECT anio, COUNT(*) AS pruebas
FROM   PRUEBA
GROUP  BY anio
ORDER  BY anio;

-- Ciclistas por equipo
SELECT e.nombre AS equipo, COUNT(*) AS total_ciclistas
FROM   EQUIPO e
LEFT JOIN CICLISTA c ON c.id_equipo = e.id_equipo
GROUP  BY e.nombre
ORDER  BY total_ciclistas DESC;

-- Validación de integridad: pruebas sin ganador asignado
SELECT id_prueba, nombre, anio FROM PRUEBA WHERE ganador IS NULL;

--  Vista útil: ganadores por edición
CREATE OR REPLACE VIEW VW_GANADORES AS
SELECT p.id_prueba, p.nombre AS prueba, p.anio, c.nombre AS ganador
FROM   PRUEBA p
LEFT JOIN CICLISTA c ON c.id_ciclista = p.ganador;

-- Ejemplo de uso
SELECT * FROM VW_GANADORES ORDER BY anio, prueba;