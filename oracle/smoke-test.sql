-- Oracle Free runtime smoke test. Run as PS_ASSIGNMENT in FREEPDB1.
-- The table and row intentionally remain in the named volume for restart tests.
set echo off
set feedback on
set pagesize 100
set linesize 120
set serveroutput on
whenever sqlerror exit sql.sqlcode

begin
  execute immediate 'create table PS_ORACLE_SMOKE (
    id number(10) primary key,
    value_text varchar2(100) not null,
    created_at timestamp default systimestamp not null
  )';
exception
  when others then
    if sqlcode != -955 then raise; end if;
end;
/

merge into PS_ORACLE_SMOKE target
using (select 1 id, 'persistent-check' value_text from dual) source
on (target.id = source.id)
when matched then update set target.value_text = source.value_text
when not matched then insert (id, value_text) values (source.id, source.value_text);
commit;

create or replace function F_ORACLE_SMOKE return varchar2 is
begin
  return 'PLSQL_FUNCTION_OK';
end;
/

create or replace procedure P_ORACLE_SMOKE(p_input in varchar2, p_output out varchar2) is
begin
  p_output := upper(p_input);
end;
/

select id, value_text, to_char(created_at, 'YYYY-MM-DD HH24:MI:SS') created_at
from PS_ORACLE_SMOKE where id = 1;
select F_ORACLE_SMOKE as function_result from dual;
declare
  v_output varchar2(100);
begin
  P_ORACLE_SMOKE('plsql procedure ok', v_output);
  dbms_output.put_line('procedure_result=' || v_output);
end;
/
exit success
