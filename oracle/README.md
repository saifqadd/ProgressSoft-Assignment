# Oracle AI Database Free 26ai

The planned local runtime is the official Oracle Container Registry Full image, `container-registry.oracle.com/database/free:latest`. The Compose configuration binds SQL*Net and Enterprise Manager Express to localhost and stores database files in the named `oracle_data` volume.

## Status

- Phase 1 host compatibility: verified. See [the requirements tracker](../docs/REQUIREMENTS.md).
- Docker Desktop / WSL2: installed and verified; Docker Engine and Compose smoke checks passed.
- Oracle image pull: verified; official full image digest is `sha256:f988b0c04c4c386cd306a2a914c0d7a9702d83acc31b064a28ad8eb6278a8fba`.
- Oracle credential: generated locally without displaying it; its file is Git-ignored and the ACL was verified to allow only the current Windows user and SYSTEM.
- Oracle container: running and healthy as `progresssoft-oracle-free`; SQL*Plus and Windows localhost TCP connectivity verified.
- Persistent storage: named volume `oracle_oracle_data`; a smoke row survived container restart.
- Assignment SQL: Q1–Q6 executed successfully. Q3 uses the agreed department-name interpretation because no job-title field exists; it is not an exact job-title query. The SQL output is in `evidence/command-outputs/02-sql-oracle/q3-department-payroll-verification-2026-11-15.txt`.

## Runtime status and operations

Start/stop without deleting data:

```powershell
docker compose -f oracle/compose.yaml up -d
docker compose -f oracle/compose.yaml ps
docker compose -f oracle/compose.yaml stop
```

`stop` preserves the named volume. Do not use `docker compose down -v`; that removes the database volume. The SYS/SYSTEM password is in the ignored `oracle/secrets/oracle_pwd.txt`. The assignment schema password is in the ignored `oracle/secrets/assignment_schema_pwd.txt`. Both files have ACLs limited to the current Windows user and SYSTEM; neither appears in logs or tracked files. Oracle SQL*Plus OS-authenticated access inside the container was used for administration; assignment scripts were connected to `FREEPDB1` as `PS_ASSIGNMENT` without placing the password in command arguments.

Evidence is in `evidence/command-outputs/02-sql-oracle/`. It includes image digest/pull, container startup and health, SQL*Plus connectivity, actual assignment execution, constraint checks, localhost port check, and restart persistence.

Oracle's Free edition has a 2 CPU core and 2 GB RAM database limit, and up to 12 GB of user data. Keep the VirtualBox guest shut down during database work on this 16 GB host. The running Windows VirtualBox guest list was empty during this work.
