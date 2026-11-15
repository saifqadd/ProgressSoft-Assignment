#!/usr/bin/env bash
# Create the requested PS identity and groups, then set the root password
# interactively. No passwords are embedded or written to repository files.
set -euo pipefail

if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
  echo "Run with sudo: sudo ./configure_accounts.sh" >&2
  exit 1
fi

groupadd --force PSgroup
groupadd --force dba
if ! id PS >/dev/null 2>&1; then
  useradd --create-home --gid PSgroup --groups dba --shell /bin/bash PS
else
  usermod --gid PSgroup --append --groups dba PS
fi

echo "Set/modify the root password interactively (no password is stored):"
passwd root
id PS
getent group PSgroup dba
