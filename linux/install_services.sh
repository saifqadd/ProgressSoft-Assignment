#!/usr/bin/env bash
# Install the assignment's database and proxy packages on Ubuntu.
# This changes the target OS; inspect the script before running with sudo.
set -euo pipefail

if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
  echo "Run with sudo: sudo ./install_services.sh" >&2
  exit 1
fi
if [[ ! -r /etc/os-release ]]; then
  echo "Cannot identify the Linux distribution." >&2
  exit 2
fi
# shellcheck disable=SC1091
. /etc/os-release
if [[ ${ID:-} != ubuntu ]]; then
  echo "This package script targets Ubuntu; detected ${PRETTY_NAME:-unknown}." >&2
  exit 3
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y mysql-server haproxy ufw curl
systemctl enable --now mysql haproxy

# Validate the local MySQL socket and packaged HAProxy configuration.
mysqladmin --protocol=socket ping
haproxy -c -f /etc/haproxy/haproxy.cfg

printf '\nInstalled service status:\n'
systemctl --no-pager --full status mysql haproxy || true

cat <<'NOTE'
Firewall rules are intentionally not changed by this script. The assignment's
request to allow only TCP/UDP 3306 is ambiguous and applying a default-deny
policy can sever remote SSH access. Review linux/README.md and existing rules
before changing UFW.
NOTE
