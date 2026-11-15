# Final evidence checklist

This checklist points only to files selected for the proposed submission. The original confidential assignment PDF is not included. Statuses distinguish captured test output, user-reported results, and documentation-only requirements.

## Linux

| Requirement | Status and provenance | Selected evidence |
|---|---|---|
| System report, account/group checks, MySQL, HAProxy and UFW | Verified; terminal output includes final results and identifies the SSH firewall exception. | [Post-reboot Linux verification](command-outputs/01-linux/linux-verification-post-reboot-2026-11-15.txt) |
| SCP transfer to original Ubuntu desktop VM | User reports successful transfer and matching Windows/Ubuntu SHA-256 hashes. | [SCP transfer verification](command-outputs/01-linux/scp-transfer-verification-2026-11-15.txt) |
| Linux architecture, filesystem and distributions | Documented; no runtime test required. | [Concepts](../docs/CONCEPTS.md), [Linux guide](../linux/README.md) |

## SQL and Oracle

| Requirement | Status and provenance | Selected evidence |
|---|---|---|
| Q1 schema and constraints | Oracle execution and constraint checks recorded. | [SQL execution](command-outputs/02-sql-oracle/progresssoft-assignment-sql-2026-11-15.txt), [constraint verification](command-outputs/02-sql-oracle/oracle-constraint-verification-2026-11-15.txt) |
| Q2 and Q4 | Oracle execution recorded; Q2 assumes `USERID` stores the manager employee ID. Q4 uses a test-only `EMP` fixture because the assignment supplies no `EMP` table. | [SQL execution](command-outputs/02-sql-oracle/progresssoft-assignment-sql-2026-11-15.txt) |
| Q3 payroll query | Oracle execution recorded under the agreed department-name interpretation; supplied schema has no job-title field/table. | [Q3 verification](command-outputs/02-sql-oracle/q3-department-payroll-verification-2026-11-15.txt) |
| Q5 function and Q6 procedure | Oracle compilation and execution recorded; Q6 copied all four fixture rows. | [SQL execution](command-outputs/02-sql-oracle/progresssoft-assignment-sql-2026-11-15.txt) |
| SQL/PLSQL, JOIN, database, function, constraint and index concepts | Documented; no runtime test required. | [Concepts](../docs/CONCEPTS.md), [SQL guide](../sql/README.md) |

## Tomcat, Vagrant and Nginx

| Requirement | Status and provenance | Selected evidence |
|---|---|---|
| Java 8 WAR build, Tomcat 9 provisioning and Nginx configuration | Provisioning output records build success, Tomcat archive checksum/deployment and Nginx configuration validation. | [Successful Vagrant provisioning](command-outputs/03-tomcat-vagrant/vagrant-provision-retry-2026-11-15.txt) |
| VM boot/SSH, port forwarding, active services, HTTP 200 and local DNS-name access | User-reported manual verification. `progresssoft.test` resolves through the Windows hosts file; it is local DNS, not public DNS. | [Final manual verification](command-outputs/03-tomcat-vagrant/tomcat-vagrant-final-manual-verification-2026-11-15.txt) |
| JVM, application server, WAR, proxy and DNS explanations | Documented. | [Concepts](../docs/CONCEPTS.md), [Tomcat guide](../tomcat-vagrant/README.md) |

## Docker

| Requirement | Status and provenance | Selected evidence |
|---|---|---|
| Tomcat WAR application, Nginx and PostgreSQL stack | Captured HTTP 200, PostgreSQL health and insert/select results. | [Stack verification](command-outputs/04-docker/assignment-stack-verification-2026-11-15.txt) |
| PostgreSQL data survives container restart | Persistence result recorded. | [PostgreSQL persistence verification](command-outputs/04-docker/postgres-restart-persistence-2026-11-15.txt) |
| Registry push and fresh pull | Push and pull output records the image digest. | [Docker Hub push/pull verification](command-outputs/04-docker/dockerhub-push-pull-2026-11-15.txt) |
| Docker concepts, use cases and commands | Documented. | [Concepts](../docs/CONCEPTS.md), [Docker guide](../docker/README.md) |

## Kubernetes, Git and key concepts

| Requirement | Status and provenance | Selected evidence |
|---|---|---|
| K3s node, sample Nginx deployment and service | Captured node Ready, deployment 1/1 and service details. | [K3s deployment verification](command-outputs/05-kubernetes/k3s-deployment-verification-2026-11-15.txt) |
| HTTP response through the Kubernetes service | Captured HTTP 200 and expected Nginx response. | [K3s HTTP verification](command-outputs/05-kubernetes/k3s-http-test-2026-11-15.txt) |
| Kubernetes control-plane/worker roles and role identification | Documented; the practical cluster was single-node. | [Concepts](../docs/CONCEPTS.md), [Kubernetes guide](../kubernetes/README.md) |
| GitHub project and Git commands | Private remote is configured. First assignment commit/push and CLI upload/download remain user-managed and have not been performed. | [Git guide](../git/README.md) |
| RAID, DevOps, HA/DR, cloud models, SaaS/PaaS/IaaS, DNS and load balancers | Documented; no runtime test required. | [Concepts](../docs/CONCEPTS.md) |
