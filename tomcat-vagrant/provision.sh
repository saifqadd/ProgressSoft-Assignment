#!/usr/bin/env bash
# Provision the assignment's Ubuntu 24.04 VM with Temurin Java 8 and Apache
# Tomcat 9. Pin the current 9.0 release; verify Apache's published checksum.
set -euxo pipefail
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y ca-certificates curl gnupg

# Eclipse Temurin 8 provides a maintained Java 8 package for Ubuntu releases.
install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://packages.adoptium.net/artifactory/api/gpg/key/public \
  | gpg --batch --yes --dearmor -o /etc/apt/keyrings/adoptium.gpg
chmod 0644 /etc/apt/keyrings/adoptium.gpg
. /etc/os-release
echo "deb [signed-by=/etc/apt/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb ${UBUNTU_CODENAME:-$VERSION_CODENAME} main" \
  > /etc/apt/sources.list.d/adoptium.list
apt-get update
apt-get install -y temurin-8-jdk maven nginx curl tar

# Build the same Java 8 sample WAR used by the Docker task. Build from a copy
# under /tmp so Maven does not write generated files into the synced repo.
install -d -o vagrant -g vagrant /tmp/progresssoft-sample
cp /vagrant-docker/pom.xml /tmp/progresssoft-sample/pom.xml
cp -R /vagrant-docker/src /tmp/progresssoft-sample/src
chown -R vagrant:vagrant /tmp/progresssoft-sample
runuser -u vagrant -- mvn --batch-mode --no-transfer-progress \
  -f /tmp/progresssoft-sample/pom.xml package

TOMCAT_VERSION=9.0.124
TOMCAT_ARCHIVE="apache-tomcat-${TOMCAT_VERSION}.tar.gz"
TOMCAT_BASE="https://dlcdn.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin"
curl -fsSLo "/tmp/${TOMCAT_ARCHIVE}" "${TOMCAT_BASE}/${TOMCAT_ARCHIVE}"
curl -fsSLo "/tmp/${TOMCAT_ARCHIVE}.sha512" "${TOMCAT_BASE}/${TOMCAT_ARCHIVE}.sha512"
(cd /tmp && sha512sum -c "${TOMCAT_ARCHIVE}.sha512")
id tomcat >/dev/null 2>&1 || useradd --system --home-dir /opt/tomcat9 --shell /usr/sbin/nologin tomcat
install -d -o tomcat -g tomcat /opt/tomcat9
tar -xzf "/tmp/${TOMCAT_ARCHIVE}" --strip-components=1 -C /opt/tomcat9
install -m 0644 /vagrant/server.xml /opt/tomcat9/conf/server.xml
install -d -o tomcat -g tomcat /opt/tomcat9/webapps
install -o tomcat -g tomcat -m 0644 \
  /tmp/progresssoft-sample/target/sample.war \
  /opt/tomcat9/webapps/sample.war
chown -R tomcat:tomcat /opt/tomcat9
java_path=$(readlink -f "$(command -v java)")
java_home=${java_path%/bin/java}
cat > /etc/systemd/system/tomcat9.service <<UNIT
[Unit]
Description=Apache Tomcat 9
After=network.target

[Service]
Type=simple
User=tomcat
Group=tomcat
Environment=JAVA_HOME=${java_home}
Environment=CATALINA_HOME=/opt/tomcat9
WorkingDirectory=/opt/tomcat9
ExecStart=/opt/tomcat9/bin/catalina.sh run
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable --now tomcat9

install -m 0644 /vagrant/nginx.conf /etc/nginx/sites-available/progresssoft-tomcat
ln -sfn /etc/nginx/sites-available/progresssoft-tomcat /etc/nginx/sites-enabled/progresssoft-tomcat
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl enable --now nginx
