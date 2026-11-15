-- Q2: USERID is assumed to contain the manager's MyEmployee.ID.
-- If the intended relationship differs, replace the self-join after clarification.
SELECT e.FIRST_NAME || ' ' || e.LAST_NAME AS employee_name,
       e.SALARY AS salary,
       d.Name AS department_name,
       m.FIRST_NAME || ' ' || m.LAST_NAME AS manager_name,
       g.Name AS gender_name,
       u.Name AS university_name
  FROM MyEmployee e
  LEFT JOIN MyDepartment d ON d.Dept_ID = e.DEPT_ID
  LEFT JOIN MyEmployee m ON m.ID = e.USERID
  LEFT JOIN Gender g ON g.Gender_ID = e.Gender_ID
  LEFT JOIN University u ON u.ID = e.University_ID
 ORDER BY e.ID;

-- Q3 agreed interpretation: department name stands in for the missing job
-- title; employees in the Sales department are excluded. This is not an exact
-- job-title query because the supplied schema has no job-title field/table.
SELECT d.NAME AS DEPARTMENT_NAME,
       SUM(e.SALARY) AS TOTAL_MONTHLY_SALARY
  FROM MyEmployee e
  JOIN MyDepartment d ON e.DEPT_ID = d.DEPT_ID
 WHERE UPPER(d.NAME) <> 'SALES'
 GROUP BY d.NAME
HAVING SUM(e.SALARY) > 2500;

-- Q4: In the assignment's Oracle EMP example, SAL is the salary column;
-- use * for multiplication, quote an alias containing a space, and keep the
-- statement terminator after FROM. Four corrections are reflected below.
SELECT empno,
       ename,
       sal * 12 AS "ANNUAL SALARY"
  FROM emp;
