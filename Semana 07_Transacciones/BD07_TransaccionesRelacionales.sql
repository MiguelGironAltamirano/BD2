
-- 1er Ejercicio
    UPDATE EMPLOYEES
    SET SALARY = SALARY * 1.10
    WHERE DEPARTMENT_ID = 90;

    SAVEPOINT punto1;
    UPDATE EMPLOYEES
    SET SALARY = SALARY * 1.05
    WHERE DEPARTMENT_ID = 60;

    ROLLBACK TO punto1;

    COMMIT;
-- Verificacion
SELECT FIRST_NAME AS nombre,  LAST_NAME AS nombre, DEPARTMENT_ID, SALARY AS salario  FROM EMPLOYEES
WHERE DEPARTMENT_ID = 90 OR DEPARTMENT_ID = 60
ORDER BY DEPARTMENT_ID;
-- a. Solo el departamento 90 mantuvo los cambios
-- b. Los cambios despues del savepoint fueron revertidos
-- c. Revertiría todos los cambios de la transaccion activa, asi que
--    afectaría a los empleados del departamento 90 tambien.

-- 2do Ejercicio
SELECT FIRST_NAME AS nombre,  LAST_NAME AS nombre, SALARY AS salario  FROM EMPLOYEES
WHERE employee_id = 103;

UPDATE employees
SET salary = salary + 500
WHERE employee_id = 103;

rollback;
-- a. Porque Oracle bloquea las transacciones para otras sesiones
-- si no se ha hecho commit o rollback
-- b. No permitio la ejecución del update de l asegunda sesión
-- c. V$LOCK, V$SESSION, V$LOCKED_OBJECT, DBA_BLOCKERS, DBA_WAITERS

--3er Ejercicio
SET SERVEROUTPUT ON;

DECLARE
    v_employee_id   employees.employee_id%TYPE := 104;
    v_old_dept_id   employees.department_id%TYPE;
    v_new_dept_id   employees.department_id%TYPE := 110;
    v_job_id        employees.job_id%TYPE;
    v_start_date    DATE;
BEGIN

    SELECT department_id, job_id, hire_date
    INTO v_old_dept_id, v_job_id, v_start_date
    FROM employees
    WHERE employee_id = v_employee_id;

    UPDATE employees
    SET department_id = v_new_dept_id
    WHERE employee_id = v_employee_id;

    INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id)
    VALUES (v_employee_id, v_start_date, SYSDATE, v_job_id, v_old_dept_id);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Transferencia exitosa: empleado ' || v_employee_id ||
                         ' movido del depto ' || v_old_dept_id || ' al ' || v_new_dept_id);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: el empleado no existe.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error durante la transferencia: ' || SQLERRM);
        ROLLBACK;
END;
/
-- a. Porque ambas pertencen a una transaccion logica, no tiene sentido que se ejecute una sin la otra
-- b. La clausula exceptioin intercetaría el fallo y ejecutaría un rollback
-- c. Mediante las claves foráneas

-- 4to Ejercicio

    UPDATE employees
    SET salary = salary * 1.08
    WHERE department_id = 100;
    SAVEPOINT A;

    UPDATE employees
    SET salary = salary * 1.05
    WHERE department_id = 80;
    SAVEPOINT B;

    DELETE FROM employees
    WHERE department_id = 50;

    ROLLBACK TO B;

    COMMIT;


-- a. Los primeros 2 cambios persisten pues se guardarone en el savepoint
-- b. No persiste, pues fue ejecutado antes del savepoint
-- c. Usando la siguiente sentencia:
SELECT department_id, employee_id, salary
FROM employees
WHERE department_id IN (50, 80, 100);



