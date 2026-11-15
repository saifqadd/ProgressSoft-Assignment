# Tomcat 9, Nginx, and Vagrant

The Vagrantfile uses exactly the assignment input `bento/ubuntu-24.04`, allocates 2 GiB, and forwards host TCP 9090 to guest TCP 7070 and guest TCP 80 to host TCP 80. The provisioner installs Temurin Java 8 and Maven, builds the sample Java 8 WAR from `docker/`, deploys it to Tomcat 9.0.124, and configures Nginx as a reverse proxy.

The DNS name is local to this Windows host: the Windows hosts file maps `progresssoft.test` to `127.0.0.1`. The assignment app is available at `http://progresssoft.test/sample/` on port 80. Remove that hosts entry when the VM is no longer used. This does not create public DNS.

## Runtime verification

The user reports the Ubuntu VM boots after enabling PAE/NX, `vagrant ssh` works, and Vagrant confirms guest→host mappings 80→80, 7070→9090, and 22→2222. Tomcat 9 and Nginx are active. Guest requests to `127.0.0.1:7070/sample/` and `127.0.0.1/sample/` return HTTP 200. The Windows hosts file resolves `progresssoft.test` to `127.0.0.1`, and the user reports the sample opened at `http://progresssoft.test/sample/`. The final results are recorded in the selected [manual verification record](../evidence/command-outputs/03-tomcat-vagrant/tomcat-vagrant-final-manual-verification-2026-11-15.txt).

## Commands

Prerequisites on Windows host: VirtualBox provider and Vagrant installed, hardware virtualization enabled, and network access for the Bento box/package downloads. From this directory:

```powershell
vagrant validate
vagrant up
vagrant status
```

The verified mappings are guest 7070→host 9090 for Tomcat, guest 80→host 80 for Nginx, and guest 22→host 2222 for SSH. The user reports the guest curl checks return HTTP 200 and Chrome loaded `http://progresssoft.test/sample/`. The previous host 8080 fallback is no longer the assignment mapping.

To recheck from Windows, use `vagrant port`, `curl.exe -I http://127.0.0.1/sample/`, and `curl.exe -I http://progresssoft.test/sample/`. The successful final results are user-reported and documented in the final manual verification record.

Check inside guest:

```bash
vagrant ssh
java -version
systemctl status tomcat9 nginx --no-pager
curl -I http://127.0.0.1:7070/sample/
curl -I http://127.0.0.1/
```

`vagrant destroy` deletes the created guest and its state. It is intentionally not part of routine cleanup instructions; inspect state and retain anything needed first.

## Tomcat connector configuration

`server.xml` configures the HTTP Connector to listen on 7070 and deploys contexts from Tomcat's `webapps` directory. The provisioner installs it as `/opt/tomcat9/conf/server.xml`. Nginx configuration is in `nginx.conf`.
