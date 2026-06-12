#!/usr/bin/env bash
# shellcheck disable=SC1091
set -euo pipefail

# Disk: ≥ 20 GB free on /
disk_avail_kb="$(df --output=avail / | tail -n 1)"
disk_avail_gb=$((disk_avail_kb / 1024 / 1024))
if [[ "${disk_avail_gb}" -lt 20 ]]; then
  paco_abort "paco needs at least 20 GB free on /. Found: ${disk_avail_gb} GB."
fi

# RAM: ≥ 4 GB total
ram_total_kb="$(awk '/MemTotal/ {print $2}' /proc/meminfo)"
ram_total_gb=$((ram_total_kb / 1024 / 1024))
if [[ "${ram_total_gb}" -lt 4 ]]; then
  paco_abort "paco needs at least 4 GB RAM. Found: ${ram_total_gb} GB."
fi

# Internet: reach archlinux.org
if ! curl -fsSL --max-time 10 https://archlinux.org/ -o /dev/null; then
  paco_abort "paco needs internet to download packages. Cannot reach archlinux.org."
fi

echo "Hardware minimums met: ${disk_avail_gb} GB disk, ${ram_total_gb} GB RAM, internet OK."
