#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing paco command-line tools"

# Dispatcher → /usr/bin/paco
sudo install -Dm755 "${PACO_PATH}/bin/paco" /usr/bin/paco

# Version file → /usr/share/paco/version
sudo install -Dm644 "${PACO_PATH}/version" /usr/share/paco/version

# Subcommands → /usr/share/paco/bin/
sudo install -d /usr/share/paco/bin
for sub in "${PACO_PATH}/bin/"paco-*; do
  [[ -f "${sub}" ]] || continue
  name="$(basename "${sub}")"
  sudo install -Dm755 "${sub}" "/usr/share/paco/bin/${name}"
done

echo "paco installed system-wide at /usr/bin/paco"
echo "  + version, paco-* subcommands at /usr/share/paco/"
