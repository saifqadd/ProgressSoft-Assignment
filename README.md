# ProgressSoft-Technical-Assignment

Local implementation workspace for the ProgressSoft Associate Support Engineer assignment. The original confidential PDF is intentionally not part of this repository.

## Status at a glance

The source material is a 10-page assignment. This repository contains scripts, configuration, SQL solutions, and test evidence. Runtime statuses and limitations are tracked in [`docs/REQUIREMENTS.md`](docs/REQUIREMENTS.md). The confidential source PDF is kept outside this repository.

| Area | Deliverables | Verification status |
|---|---|---|
| Linux | Bash report, account/service scripts, and safe command guide | SSH, MySQL, HAProxy, account, root metadata and report verified. UFW is active with TCP/UDP 3306 rules and a documented SSH exception from the VirtualBox NAT gateway; this is not strict port-3306-only compliance. SCP transfer is reported complete with matching SHA-256 hashes. |
| Oracle SQL/PLSQL | DDL, query answers, function, procedure, sample data | Q1–Q6 executed against Oracle 26ai. Q3 is verified using the agreed department-name interpretation; this is not an exact job-title query. |
| Tomcat/Nginx/Vagrant | Vagrantfile, provisioner, Tomcat port config, Nginx proxy | Provisioning output records a successful Java 8 WAR build, Tomcat setup and Nginx validation. The user reports successful VM boot/SSH, port forwards 80→80 and 7070→9090, active Tomcat/Nginx, HTTP 200 checks, and local `progresssoft.test` access on port 80. |
| Docker | Java 8 WAR image, Dockerfile, Nginx/PostgreSQL Compose stack | Build and HTTP/PostgreSQL persistence tests passed. Image pushed to Docker Hub and pulled successfully as `saifaddeenn/progresssoft-assignment:latest`. |
| Kubernetes | Nginx Deployment and Service, K3s guide | K3s deployment, readiness and HTTP 200 verified; stack is stopped and volumes retained. |
| Git/GitHub | Git command guide and local repository | A private GitHub project is configured as `origin`. The local `main` branch has no assignment commit; the last remote-head query returned no refs. No commit or push has been performed. |
| Concepts | Study notes for each listed topic | Documentation reviewed; no runtime demonstration required for theory items. |
| Docker Desktop / Oracle 26ai architecture | Verified | Docker Desktop/WSL2 and Oracle 26ai were installed and tested. Runtime states for Oracle, the assignment stack and K3s are recorded in the requirements tracker. |

## Repository map

```text
linux/                 Bash system report and Linux task guide
sql/                   Oracle schema, answers, sample data, PL/SQL
tomcat-vagrant/        Vagrant VM and provisioning, Tomcat/Nginx config
docker/                Tomcat 9 WAR image and Nginx/PostgreSQL Compose stack
kubernetes/            Sample Nginx deployment and service
git/                   Git/GitHub command-line workflow
docs/                  Requirement checklist, execution/testing, concepts, limits
evidence/command-outputs/ Captured terminal/application output by section
```

## Fast execution order

1. Review the completed Linux SCP/checksum evidence for the original Ubuntu desktop VM.
2. Review the intended Git file set. The user will perform the first commit/push and command-line upload/download demonstration; `origin` is already configured.

## Known limits

- The assignment gives no employee job-title field/table. The agreed Q3 department-name query executed successfully, but it is an interpretation and not an exact job-title query.
- The meaning of `MyEmployee.USERID` is unspecified. The manager join in Q2 is conditional on `USERID` being the manager's employee ID.
- The Oracle function's requested “display” behavior is not defined as a return type. This implementation uses a `SYS_REFCURSOR` to return all matching names and hire dates.
- The supplied Ubuntu VM has 4 GiB RAM, while the separate Vagrant guest is required to have 2 GiB. Running both plus Docker/Kubernetes concurrently may exceed available host resources; run the heavy environments sequentially.
- The Vagrant/Tomcat/Nginx requirement is reported verified: Ubuntu boots, SSH works, port forwards are 80→80, 7070→9090, and 22→2222, Tomcat/Nginx are active, guest requests return HTTP 200, and the local `progresssoft.test` name opens the sample app. DNS is local to the Windows hosts file, not public DNS.
- `docker/compose.yaml` binds ports 8088 and 5432 to loopback and uses an ignored password file with restricted ACLs.
- Tomcat's `progresssoft.test` name is local-only. The Windows hosts entry `127.0.0.1 progresssoft.test` is in place; changing the hosts file requires administrator privileges.
- Versions are limited to those explicitly requested: Vagrant input `bento/ubuntu-24.04`, Java 8, Tomcat 9, and the specified existing Ubuntu VM. The assignment does not pin Tomcat 9 patch, Nginx, PostgreSQL, Docker, or Kubernetes versions.
- Generated files are implementation artifacts, not proof of a successful install or deployment. The selected text verification records are listed in [`evidence/EVIDENCE-CHECKLIST.md`](evidence/EVIDENCE-CHECKLIST.md).
- The post-reboot verification, final UFW rules, and new SSH test are saved in [`evidence/command-outputs/01-linux/linux-verification-post-reboot-2026-11-15.txt`](evidence/command-outputs/01-linux/linux-verification-post-reboot-2026-11-15.txt). The public IP is redacted from the repository copy. The firewall keeps an explicit SSH management exception and is not strict port-3306-only.
- The evidence checklist is [`evidence/EVIDENCE-CHECKLIST.md`](evidence/EVIDENCE-CHECKLIST.md).

## Docker Desktop and Oracle 26ai

Docker Desktop, WSL2, Docker Compose and Oracle Database Free 26ai were installed and verified. Oracle SQL/PLSQL Q1–Q6 ran in Oracle; Q3 uses the agreed department-name interpretation because the supplied schema has no job-title field. The Docker assignment stack and K3s deployment passed their tests and are stopped with persistent volumes retained. The Tomcat image was pushed and pulled as `saifaddeenn/progresssoft-assignment:latest` with digest `sha256:52e838f64dc2b992054718f98a9eb1fcccb35e37e3990b0161e86eaa5047a1d5`. See the selected [Q3 output](evidence/command-outputs/02-sql-oracle/q3-department-payroll-verification-2026-11-15.txt), [Docker push/pull output](evidence/command-outputs/04-docker/dockerhub-push-pull-2026-11-15.txt), [Docker stack verification](evidence/command-outputs/04-docker/assignment-stack-verification-2026-11-15.txt), [PostgreSQL persistence output](evidence/command-outputs/04-docker/postgres-restart-persistence-2026-11-15.txt), and [K3s deployment verification](evidence/command-outputs/05-kubernetes/k3s-deployment-verification-2026-11-15.txt).

## Deadline

The deadline supplied by the user is November 15, 2026. Linux, Oracle SQL/PLSQL, Docker, K3s, and the Tomcat/Nginx DNS-name demonstration have verification records. The configured Git remote has no branch refs yet; the user will handle commit and push.
