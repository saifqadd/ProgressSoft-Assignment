# Docker sample

This builds a small Java 8 WAR, deploys it to a Tomcat 9 image, and starts Nginx plus PostgreSQL using Compose. Nginx is bound to `127.0.0.1:8088`; PostgreSQL is bound to `127.0.0.1:5432`. Both ports are local to the Windows host.

```bash
./create-postgres-secret.ps1
docker compose config --quiet
docker compose build
docker compose up -d
docker compose ps
docker compose logs --tail=100
curl http://localhost:8088/
docker compose exec postgres pg_isready -U assignment -d assignment
```

Create the random PostgreSQL credential with `./create-postgres-secret.ps1` before starting the stack. It writes an ignored `secrets/postgres_password.txt` and restricts the ACL to the current Windows user and SYSTEM. The secret file is supplied through the official PostgreSQL image's `POSTGRES_PASSWORD_FILE` support; its contents are never printed. No Postgres connection is needed by the sample app. A named volume persists data. Stop services with `docker compose down`; `docker compose down -v` deletes the database volume and is destructive, so inspect/backup before choosing it.

Compose validation passed. The Java 8 WAR built successfully, the Tomcat 9 image was created, and the app/Nginx/PostgreSQL Compose stack was tested. HTTP returned 200; PostgreSQL became healthy and passed insert/select and restart-persistence checks. See the selected [stack verification](../evidence/command-outputs/04-docker/assignment-stack-verification-2026-11-15.txt) and [PostgreSQL persistence record](../evidence/command-outputs/04-docker/postgres-restart-persistence-2026-11-15.txt). The generated PostgreSQL credential is stored in an ignored local file; its value is not included in the repository.

The verified image is published as `saifaddeenn/progresssoft-assignment:latest`. Docker Hub push and subsequent pull succeeded with digest `sha256:52e838f64dc2b992054718f98a9eb1fcccb35e37e3990b0161e86eaa5047a1d5`; see the [push/pull verification](../evidence/command-outputs/04-docker/dockerhub-push-pull-2026-11-15.txt). No credentials are included in the image documentation or selected evidence. The confidential assignment PDF was not part of the Docker build context.
