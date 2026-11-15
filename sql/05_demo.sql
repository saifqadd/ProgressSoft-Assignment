-- Q5 demonstration in SQL*Plus / SQLcl; prints each returned row.
SET SERVEROUTPUT ON
DECLARE
    l_rows SYS_REFCURSOR;
    l_name MyEmployee.FIRST_NAME%TYPE;
    l_hire_date MyEmployee.HIRE_DATE%TYPE;
BEGIN
    l_rows := F_HR_QUERY;
    LOOP
        FETCH l_rows INTO l_name, l_hire_date;
        EXIT WHEN l_rows%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(l_name || ' | ' || TO_CHAR(l_hire_date, 'YYYY-MM-DD'));
    END LOOP;
    CLOSE l_rows;
END;
/

-- Q6 demonstration; verify counts after procedure execution.
BEGIN
    P_COPY_EMPLOYEE;
END;
/

SELECT (SELECT COUNT(*) FROM MyEmployee) AS source_rows,
       (SELECT COUNT(*) FROM MyEmployee_update) AS copied_rows
  FROM dual;
