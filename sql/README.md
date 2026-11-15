# Oracle SQL and PL/SQL

These files use Oracle syntax and have been executed with SQL*Plus against the official Oracle Database Free 26ai container. The work ran in the isolated `PS_ASSIGNMENT` schema in `FREEPDB1`. The database password is stored only in an ignored, ACL-restricted local secret file; no credential is included in the repository or evidence logs.

## Run order

1. `01_schema.sql` creates the four requested tables with Oracle types and constraints.
2. `02_sample_data.sql` inserts example records including SCOTT, AHMAD, and RAMI with the assignment's stated hire dates. Other fields are explicitly illustrative fixture values; an additional post-SCOTT fixture lets Q5 demonstrate a returned row.
3. `03_answers.sql` contains Q2, the agreed department-based Q3 interpretation, and Q4. Q3 groups by department name because the supplied schema has no job-title field/table; it excludes department Sales and is not an exact job-title query. Its Oracle result is recorded in `evidence/command-outputs/02-sql-oracle/q3-department-payroll-verification-2026-11-15.txt`. The corrected Q4 statement was run against a test-only `EMP` fixture in `oracle/fixtures/emp_q4.sql`, since the prompt does not provide that table.
4. `04_plsql.sql` creates Q5 `F_HR_QUERY` and Q6 `P_COPY_EMPLOYEE`.
5. `05_demo.sql` calls the function and procedure and queries the copied table.

### Q4: four corrections

The supplied annual-salary statement contains these four errors for the standard Oracle `EMP` table:

1. It refers to `SALARY`; the standard `EMP` column is `SAL`.
2. It uses `x` for multiplication; SQL uses the `*` operator.
3. The alias `ANNUAL SALARY` contains a space, so it must be delimited as `"ANNUAL SALARY"`.
4. The semicolon appears before the `FROM` clause; it belongs after the complete `SELECT ... FROM emp` statement.

The corrected query in `03_answers.sql` applies all four corrections. It was executed against the clearly identified test-only `EMP` fixture because the assignment does not supply that table.

The actual run created the four tables, inserted the four illustrative employee fixtures, ran Q2/Q4, compiled both PL/SQL objects, invoked Q5/Q6, and verified four source rows were copied. Outputs are in `evidence/command-outputs/02-sql-oracle/progresssoft-assignment-sql-2026-11-15.txt`. Q1 constraints were also checked with metadata and safe rejected inserts, recorded in `oracle-constraint-verification-2026-11-15.txt`.

To rerun in a fresh schema, connect with SQL*Plus or SQLcl and execute `01_schema.sql`, `02_sample_data.sql`, the optional Q4 fixture, `03_answers.sql`, `04_plsql.sql`, and `05_demo.sql`. Re-running the schema script in this existing schema will fail because the objects already exist; do not drop them. Preserve the named Docker volume unless intentionally resetting the database after backup/review.

## Assumptions and open items

- Oracle `VARCHAR2` represents the assignment's generic “String”; `NUMBER`, `DATE`, and `BLOB` map directly to its listed types.
- The DDL uses primary keys on identifiers, non-null for identifiers and core names, checks salary is nonnegative, and foreign keys from employee department/gender/university IDs to lookup tables. The prompt does not specify column lengths, which fields can be nullable, or the meaning of `USERID`.
- Q2 assumes `MyEmployee.USERID` stores the manager's employee ID. If `USERID` means an application/login user instead, obtain the intended manager column/relationship before running the manager join.
- Q3's agreed interpretation uses department name in place of the missing job title and excludes department Sales. This limitation is stated in the SQL comments and tracker; it should not be described as an exact job-title result.
- Q5 uses a `SYS_REFCURSOR` return so callers can display multiple matching employees. The prompt gives no exact function signature or return convention.
- Q6 replaces rows in the destination table each time it runs, making it a full copy rather than accumulating duplicates.

## Example checks

Verified results: four employee rows, `F_HR_QUERY` returned Jane Doe after SCOTT, `P_COPY_EMPLOYEE` copied 4/4 rows, the Q4 test fixture returned annual salary 15,000, and Q3 returned Engineering 2700 and HR 9300 under its documented department interpretation. A separate Oracle smoke table row and function survived a container restart using the named volume.
