-- Test-only fixture for the corrected Q4 query. The assignment's EMP table is
-- not part of the requested four-table schema and is not present in this new
-- schema. This minimal Oracle-compatible fixture provides the columns used by
-- the query; it is not represented as supplied assignment data.
create table emp (
  empno number(4) primary key,
  ename varchar2(10) not null,
  sal number(7,2)
);

insert into emp (empno, ename, sal) values (9001, 'DEMO', 1250);
commit;
