-- Q1: Oracle schema based on the four tables and fields in the assignment.
-- Review naming/nullable assumptions in README.md before production use.

CREATE TABLE MyDepartment (
    Dept_ID NUMBER CONSTRAINT pk_mydepartment PRIMARY KEY,
    Name    VARCHAR2(100) CONSTRAINT nn_mydepartment_name NOT NULL
);

CREATE TABLE Gender (
    Gender_ID NUMBER CONSTRAINT pk_gender PRIMARY KEY,
    Name      VARCHAR2(50) CONSTRAINT nn_gender_name NOT NULL
);

CREATE TABLE University (
    ID   NUMBER CONSTRAINT pk_university PRIMARY KEY,
    Name VARCHAR2(200) CONSTRAINT nn_university_name NOT NULL
);

CREATE TABLE MyEmployee (
    ID            NUMBER CONSTRAINT pk_myemployee PRIMARY KEY,
    LAST_NAME     VARCHAR2(100) CONSTRAINT nn_myemployee_last_name NOT NULL,
    FIRST_NAME    VARCHAR2(100) CONSTRAINT nn_myemployee_first_name NOT NULL,
    HIRE_DATE     DATE CONSTRAINT nn_myemployee_hire_date NOT NULL,
    USERID        NUMBER,
    SALARY        NUMBER(12,2),
    DEPT_ID       NUMBER,
    Gender_ID     NUMBER,
    University_ID NUMBER,
    EMP_IMAGE     BLOB,
    CONSTRAINT ck_myemployee_salary CHECK (SALARY IS NULL OR SALARY >= 0),
    CONSTRAINT fk_myemployee_department FOREIGN KEY (DEPT_ID) REFERENCES MyDepartment (Dept_ID),
    CONSTRAINT fk_myemployee_gender FOREIGN KEY (Gender_ID) REFERENCES Gender (Gender_ID),
    CONSTRAINT fk_myemployee_university FOREIGN KEY (University_ID) REFERENCES University (ID)
);

CREATE INDEX ix_myemployee_dept_id ON MyEmployee (DEPT_ID);
CREATE INDEX ix_myemployee_gender_id ON MyEmployee (Gender_ID);
CREATE INDEX ix_myemployee_university_id ON MyEmployee (University_ID);
