# Short interview review notes

## Linux

Linux is a kernel used with user-space tools and a package ecosystem to form a distribution (for example Ubuntu, Debian, RHEL, Rocky Linux). The filesystem is one directory tree rooted at `/`; common paths include `/etc` configuration, `/var` changing data/logs, `/home` user files, `/usr` applications/libraries, `/tmp` temporary files, and `/proc` kernel/process information. Users and groups govern identity and access; `sudo` grants selected administrative actions. Processes, services, sockets, filesystems, permissions, package management, and logs are routine support areas.

## SQL and databases

- **DDL** defines objects (`CREATE`, `ALTER`, `DROP`); **DML** reads/changes rows (`SELECT`, `INSERT`, `UPDATE`, `DELETE`); **DCL** controls privileges (`GRANT`, `REVOKE`). Oracle PL/SQL adds procedural blocks, variables, exceptions, functions, and procedures around SQL.
- **INNER JOIN** returns matching rows; **LEFT/RIGHT OUTER JOIN** preserves all rows from one side; **FULL OUTER JOIN** preserves unmatched rows on both sides; **CROSS JOIN** forms combinations; a **self join** relates rows in one table.
- An **RDBMS** stores related data in structured tables with constraints and transactions. **NoSQL** is a broad family (document, key-value, wide-column, graph) with models chosen for access patterns and scale; it is not one database or a universal replacement for relational systems.
- Aggregates include `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`; string functions vary by database (Oracle examples: `UPPER`, `LOWER`, `SUBSTR`, `LENGTH`, `TRIM`, `||`). Oracle date examples include `SYSDATE` for the current database-server date/time; `ADD_MONTHS(date, n)` to add months; `MONTHS_BETWEEN(date1, date2)` to calculate the month difference; `TRUNC(date)` to remove the time portion (or truncate to a specified date unit); and `TO_CHAR(date, 'YYYY-MM-DD')` to format a date as text.
- Constraints enforce data rules: `PRIMARY KEY`, `NOT NULL`, `UNIQUE`, `FOREIGN KEY`, and `CHECK`. Indexes can speed lookup/join/order operations at the cost of storage and write overhead; they are not a substitute for constraints.

## JVM, application servers, WAR, Tomcat

The JVM executes Java bytecode and provides runtime services such as memory management. An application server/container hosts application components and manages concerns such as lifecycle, requests, and integrations. A WAR (Web Application Archive) packages a Java web app. Tomcat is a servlet container/web server: it deploys a WAR placed under its `webapps` directory (or configured deployment location), expands/loads it, and serves its context path. A reverse proxy such as Nginx can accept public HTTP traffic and forward it to Tomcat on an internal port.

## Docker

Docker builds images from layered instructions (Dockerfiles) and runs isolated containers from images. Images are immutable templates; containers are runtime instances. Volumes retain data beyond container lifetime, networks connect services, and Compose describes a multi-container application. Common use cases include creating reproducible development and test environments, packaging an application and its runtime for deployment, and running an application alongside dependencies such as a database or reverse proxy. Common commands: `docker build`, `docker run`, `docker ps`, `docker logs`, `docker exec`, `docker compose up -d`, `docker compose down`. Never bake credentials into an image.

## Kubernetes

Kubernetes reconciles declared desired state. The control plane (API server, scheduler, controllers, backing store) coordinates a cluster; worker nodes run workloads via a container runtime and node agent. Modern clusters can use control-plane nodes for workloads too, so “master” is a control-plane role, not necessarily a dedicated machine. Inspect roles with `kubectl get nodes -o wide` and labels with `kubectl get nodes --show-labels`; a blank `ROLES` field can still indicate a worker. A Deployment manages replicated Pods; a Service supplies a stable endpoint.

## Git

Git tracks snapshots locally; a remote (GitHub/GitLab) hosts a shared copy. Typical flow: `git status`, `git add`, `git commit`, `git remote add origin`, `git push -u origin main`, `git pull`, `git clone`, `git log`, `git diff`, and feature branches. `.gitignore` prevents generated/secrets from being staged, but review `git status` and staged diff before pushing.

## RAID, DevOps, HA/DR, cloud, DNS, load balancing

- **RAID** combines disks for performance and/or redundancy: RAID 0 stripes without redundancy; RAID 1 mirrors; RAID 5 uses distributed parity; RAID 6 dual parity; RAID 10 mirrors striped sets. RAID is not a backup.
- **DevOps** is a culture and set of practices connecting development and operations through shared ownership, automation, feedback, CI/CD, observability, and reliable change management.
- **High Availability (HA)** reduces service interruption through redundancy, health checks, failover, and removal of single points of failure. **Disaster Recovery (DR)** restores service/data after a major outage using tested backups, replication, and documented recovery. RPO is acceptable data loss; RTO is acceptable recovery time. Apache/Nginx, PostgreSQL/Oracle, and Tomcat can be deployed redundantly, but each needs appropriate state, routing, and recovery design.
- Cloud deployment models include public, private, hybrid, and multi-cloud. Examples of providers and services include AWS (EC2 virtual machines, S3 object storage, RDS managed databases, Elastic Beanstalk application platform), Microsoft Azure (Virtual Machines, Blob Storage, Azure SQL Database, App Service), and Google Cloud (Compute Engine, Cloud Storage, Cloud SQL, App Engine). **IaaS** offers virtualized compute/network/storage; **PaaS** manages an application runtime/platform; **SaaS** delivers a finished application such as Microsoft 365 or Google Workspace. These service categories are distinct from public/private/hybrid deployment models.
- **DNS** maps names to records/addresses (A/AAAA, CNAME, MX, TXT, etc.); TTL controls cache duration. **Load balancers** distribute requests among healthy backends (layer 4 transport or layer 7 HTTP); they can terminate TLS and perform health checks. DNS distribution alone is not the same as per-request health-aware balancing.
