#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing container stack (podman)"

# podman:         daemonless, rootless container engine
# podman-docker:  provides `docker` command + man pages so existing
#                 docker-using tools and tutorials work unchanged
# podman-compose: compose orchestration (paco wires lazydocker to use it)
TOOLS=(podman podman-docker podman-compose)

missing=()
for t in "${TOOLS[@]}"; do
  paco-pkg-present "${t}" || missing+=("${t}")
done

if [[ ${#missing[@]} -eq 0 ]]; then
  echo "Container stack already installed. Skipping."
  exit 0
fi

paco-pkg-add "${missing[@]}"
echo "Container stack installed: ${TOOLS[*]}"
