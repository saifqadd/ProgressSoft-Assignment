-- Illustrative data for practicing Q2/Q5. Hire dates for the three named
-- examples follow the assignment. Other attributes/IDs are test fixtures.
INSERT INTO MyDepartment (Dept_ID, Name) VALUES (10, 'HR');
INSERT INTO MyDepartment (Dept_ID, Name) VALUES (20, 'Engineering');
INSERT INTO Gender (Gender_ID, Name) VALUES (1, 'Female');
INSERT INTO Gender (Gender_ID, Name) VALUES (2, 'Male');
INSERT INTO University (ID, Name) VALUES (100, 'Example University');

INSERT INTO MyEmployee (ID, LAST_NAME, FIRST_NAME, HIRE_DATE, USERID, SALARY, DEPT_ID, Gender_ID, University_ID)
VALUES (1, 'SCOTT', 'SCOTT', DATE '1987-09-09', NULL, 3000, 10, 2, 100);
INSERT INTO MyEmployee (ID, LAST_NAME, FIRST_NAME, HIRE_DATE, USERID, SALARY, DEPT_ID, Gender_ID, University_ID)
VALUES (2, 'AHMAD', 'AHMAD', DATE '1980-10-10', 1, 3500, 10, 2, 100);
INSERT INTO MyEmployee (ID, LAST_NAME, FIRST_NAME, HIRE_DATE, USERID, SALARY, DEPT_ID, Gender_ID, University_ID)
VALUES (3, 'RAMI', 'RAMI', DATE '1986-05-24', 1, 2700, 20, 2, 100);
-- Additional illustrative fixture after SCOTT's hire date so Q5 returns a row.
INSERT INTO MyEmployee (ID, LAST_NAME, FIRST_NAME, HIRE_DATE, USERID, SALARY, DEPT_ID, Gender_ID, University_ID)
VALUES (4, 'DOE', 'JANE', DATE '1988-01-15', 1, 2800, 10, 1, 100);

COMMIT;
