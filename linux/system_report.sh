#!/usr/bin/env bash
# Read-only system inventory for the Linux section of the assignment.
# Public IP discovery is optional and requires curl plus outbound connectivity.
set -u

first_ipv4() {
  if command -v ip >/dev/null 2>&1; then
    ip -o -4 addr show scope global 2>/dev/null | awk 'NR==1 {sub(/\/.*/, "", $4); print $4}'
  fi
}

total_mem_kib=$(awk '/MemTotal:/ {print $2}' /proc/meminfo 2>/dev/null || true)
avail_mem_kib=$(awk '/MemAvailable:/ {print $2}' /proc/meminfo 2>/dev/null || true)
swap_total_kib=$(awk '/SwapTotal:/ {print $2}' /proc/meminfo 2>/dev/null || true)
swap_free_kib=$(awk '/SwapFree:/ {print $2}' /proc/meminfo 2>/dev/null || true)
mem_used_kib=$(( ${total_mem_kib:-0} - ${avail_mem_kib:-0} ))
swap_used_kib=$(( ${swap_total_kib:-0} - ${swap_free_kib:-0} ))
human_kib() { awk -v k="${1:-0}" 'BEGIN { if(k>=1048576) printf "%.1f GiB", k/1048576; else printf "%.0f MiB", k/1024 }'; }

os_name=Unknown
os_version=Unknown
if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  os_name=${NAME:-Unknown}
  os_version=${VERSION_ID:-Unknown}
fi

public_ip=Unavailable
if command -v curl >/dev/null 2>&1; then
  public_ip=$(curl --fail --silent --show-error --max-time 3 https://api.ipify.org 2>/dev/null || printf 'Unavailable')
  [[ -n "$public_ip" ]] || public_ip=Unavailable
fi

virt=Physical/unknown
if command -v systemd-detect-virt >/dev/null 2>&1; then
  virt=$(systemd-detect-virt 2>/dev/null || printf 'none')
  [[ "$virt" == none ]] && virt=Physical/unknown
fi

printf 'System Information\n'
printf 'Executed By: %s\n' "$(id -un)"
printf 'Hostname: %s\n' "$(hostname -f 2>/dev/null || hostname)"
printf 'Server IP: %s\n' "$(first_ipv4)"
printf 'Public IP: %s\n' "$public_ip"
printf 'OS Type and Version: %s %s\n' "$os_name" "$os_version"
printf 'Kernel Version: %s\n' "$(uname -r)"
printf 'Architecture: %s\n' "$(uname -m)"
printf 'Virtualization: %s\n' "$virt"
printf 'Server Time: %s\n' "$(LC_TIME=C date '+%a %b %d %T %Z %Y')"
printf 'Timezone: %s\n' "$(timedatectl show -p Timezone --value 2>/dev/null || date +%Z)"
printf 'Uptime: %s\n' "$(uptime -p 2>/dev/null || uptime)"
printf '\nResource Usage\n'
printf 'Total Memory: %s\n' "$(human_kib "$total_mem_kib")"
printf 'Memory Usage: %s / %s\n' "$(human_kib "$mem_used_kib")" "$(human_kib "$total_mem_kib")"
printf 'Swap Usage: %s / %s\n' "$(human_kib "$swap_used_kib")" "$(human_kib "$swap_total_kib")"
printf 'CPU Cores: %s\n' "$(nproc 2>/dev/null || getconf _NPROCESSORS_ONLN)"
