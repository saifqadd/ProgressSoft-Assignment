-- Q5: Return a cursor so the caller can display all employees hired after
-- SCOTT. This is an explicit interface choice because the assignment does not
-- specify a scalar/table return type or parameter list.
CREATE OR REPLACE FUNCTION F_HR_QUERY
    RETURN SYS_REFCURSOR
IS
    l_result SYS_REFCURSOR;
BEGIN
    OPEN l_result FOR
        SELECT e.FIRST_NAME || ' ' || e.LAST_NAME AS employee_name,
               e.HIRE_DATE
          FROM MyEmployee e
         WHERE e.HIRE_DATE > (
                   SELECT MIN(s.HIRE_DATE)
                     FROM MyEmployee s
                    WHERE UPPER(s.LAST_NAME) = 'SCOTT'
               )
         ORDER BY e.HIRE_DATE, e.ID;
    RETURN l_result;
END F_HR_QUERY;
/

-- Q6: Create the destination on first run, then replace its contents with a
-- complete copy. Dynamic SQL allows compilation before the target exists.
CREATE OR REPLACE PROCEDURE P_COPY_EMPLOYEE
IS
BEGIN
    BEGIN
        EXECUTE IMMEDIATE
            'CREATE TABLE MyEmployee_update AS SELECT * FROM MyEmployee WHERE 1 = 0';
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE != -955 THEN -- ORA-00955: object name already exists
                RAISE;
            END IF;
    END;

    EXECUTE IMMEDIATE 'DELETE FROM MyEmployee_update';
    EXECUTE IMMEDIATE 'INSERT INTO MyEmployee_update SELECT * FROM MyEmployee';
    COMMIT;
END P_COPY_EMPLOYEE;
/
