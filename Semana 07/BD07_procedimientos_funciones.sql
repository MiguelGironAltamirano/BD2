
-- =======================================
-- FUNCIONES Y PROCEDIMIENTOS (EJERCICIOS)
-- =======================================

-- 4.1.1
CREATE OR REPLACE FUNCTION f_partes_no_paris
RETURN SYS_REFCURSOR AS rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT color, city FROM parts WHERE UPPER(city) <> 'PARIS' AND weight > 10;
  RETURN rc;
END;
/

-- 4.1.2
CREATE OR REPLACE FUNCTION f_peso_gramos
RETURN SYS_REFCURSOR AS rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT id_part, weight * 453.59237 AS peso_gramos FROM parts;
  RETURN rc;
END;
/

-- 4.1.3
CREATE OR REPLACE FUNCTION f_todos_proveedores
RETURN SYS_REFCURSOR AS rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT * FROM suppliers;
  RETURN rc;
END;
/

-- 4.1.4
CREATE OR REPLACE FUNCTION f_colocalizados
RETURN SYS_REFCURSOR AS rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT s.id_supplier, p.id_part FROM suppliers s JOIN parts p ON s.city = p.city;
  RETURN rc;
END;
/

-- 4.1.5
CREATE OR REPLACE FUNCTION f_ciudades_abastecimiento
RETURN SYS_REFCURSOR AS rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT DISTINCT s.city AS ciudad_proveedor, p.city AS ciudad_parte
              FROM sp
              JOIN suppliers s ON s.id_supplier = sp.id_supplier
              JOIN parts p ON p.id_part = sp.id_part;
  RETURN rc;
END;
/

-- 4.1.6
CREATE OR REPLACE FUNCTION f_pares_proveedores
RETURN SYS_REFCURSOR AS rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT s1.id_supplier AS proveedor1, s2.id_supplier AS proveedor2
              FROM suppliers s1 JOIN suppliers s2
              ON s1.city = s2.city AND s1.id_supplier < s2.id_supplier;
  RETURN rc;
END;
/

-- 4.1.7
CREATE OR REPLACE PROCEDURE p_total_proveedores(p_total OUT NUMBER) AS
BEGIN
  SELECT COUNT(*) INTO p_total FROM suppliers;
END;
/

-- 4.1.8
CREATE OR REPLACE PROCEDURE p_min_max_cant_parte(p_id_part IN CHAR, p_min OUT NUMBER, p_max OUT NUMBER) AS
BEGIN
  SELECT MIN(qty), MAX(qty) INTO p_min, p_max FROM sp WHERE id_part = p_id_part;
END;
/

-- 4.1.9
CREATE OR REPLACE FUNCTION f_total_por_parte
RETURN SYS_REFCURSOR AS rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT id_part, SUM(qty) AS total_qty FROM sp GROUP BY id_part;
  RETURN rc;
END;
/

-- 4.1.10
CREATE OR REPLACE FUNCTION f_partes_varios_proveedores
RETURN SYS_REFCURSOR AS rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT id_part FROM sp GROUP BY id_part HAVING COUNT(DISTINCT id_supplier) > 1;
  RETURN rc;
END;
/

-- 4.1.11
CREATE OR REPLACE FUNCTION f_proveedores_de_parte(p_id_part IN CHAR)
RETURN SYS_REFCURSOR AS rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT DISTINCT s.supplier_name
              FROM suppliers s JOIN sp ON sp.id_supplier = s.id_supplier
              WHERE sp.id_part = p_id_part;
  RETURN rc;
END;
/

-- 4.1.12
CREATE OR REPLACE FUNCTION f_proveedores_con_partes
RETURN SYS_REFCURSOR AS rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT DISTINCT s.supplier_name FROM suppliers s
              WHERE EXISTS (SELECT 1 FROM sp sp2 WHERE sp2.id_supplier = s.id_supplier);
  RETURN rc;
END;
/

-- 4.1.13
CREATE OR REPLACE FUNCTION f_estado_menor_max
RETURN SYS_REFCURSOR AS rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT id_supplier FROM suppliers WHERE status < (SELECT MAX(status) FROM suppliers);
  RETURN rc;
END;
/

-- 4.1.14
CREATE OR REPLACE FUNCTION f_existe_parte(p_id_part IN CHAR)
RETURN SYS_REFCURSOR AS rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT supplier_name FROM suppliers s
              WHERE EXISTS (SELECT 1 FROM sp WHERE sp.id_supplier = s.id_supplier AND sp.id_part = p_id_part);
  RETURN rc;
END;
/

-- 4.1.15
CREATE OR REPLACE FUNCTION f_no_abastece_parte(p_id_part IN CHAR)
RETURN SYS_REFCURSOR AS rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT supplier_name FROM suppliers s
              WHERE NOT EXISTS (SELECT 1 FROM sp WHERE sp.id_supplier = s.id_supplier AND sp.id_part = p_id_part);
  RETURN rc;
END;
/

-- 4.1.16
CREATE OR REPLACE FUNCTION f_abastece_todas_partes
RETURN SYS_REFCURSOR AS rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT s.supplier_name FROM suppliers s
              WHERE NOT EXISTS (
                SELECT 1 FROM parts p
                WHERE NOT EXISTS (
                  SELECT 1 FROM sp WHERE sp.id_supplier = s.id_supplier AND sp.id_part = p.id_part
                )
              );
  RETURN rc;
END;
/

-- 4.1.17
CREATE OR REPLACE FUNCTION f_partes_peso_o_proveedor(p_id_supplier IN CHAR)
RETURN SYS_REFCURSOR AS rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT DISTINCT p.id_part
              FROM parts p LEFT JOIN sp ON sp.id_part = p.id_part
              WHERE p.weight > 16 OR sp.id_supplier = p_id_supplier;
  RETURN rc;
END;
/