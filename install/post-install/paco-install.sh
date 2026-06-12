#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing paco command-line tools"

# Check if any file differs from its target. If nothing changed, skip
# entirely (no sudo prompt, fast exit).
needs_install=false

if [[ ! -f /usr/bin/paco ]] || ! cmp -s "${PACO_PATH}/bin/paco" /usr/bin/paco; then
  needs_install=true
fi

if [[ ! -f /usr/share/paco/version ]] || ! cmp -s "${PACO_PATH}/version" /usr/share/paco/version; then
  needs_install=true
fi

if [[ "${needs_install}" == "false" ]]; then
  for sub in "${PACO_PATH}/bin/"paco-*; do
    [[ -f "${sub}" ]] || continue
    name="$(basename "${sub}")"
    if [[ ! -f "/usr/share/paco/bin/${name}" ]] || ! cmp -s "${sub}" "/usr/share/paco/bin/${name}"; then
      needs_install=true
      break
    fi
  done
fi

if [[ "${needs_install}" == "false" ]]; then
  echo "paco system files already up to date."
  exit 0
fi

# Something changed; install everything.
sudo install -Dm755 "${PACO_PATH}/bin/paco" /usr/bin/paco
sudo install -Dm644 "${PACO_PATH}/version" /usr/share/paco/version
sudo install -d /usr/share/paco/bin
for sub in "${PACO_PATH}/bin/"paco-*; do
  [[ -f "${sub}" ]] || continue
  name="$(basename "${sub}")"
  sudo install -Dm755 "${sub}" "/usr/share/paco/bin/${name}"
done

echo "paco installed system-wide at /usr/bin/paco"
echo "  + version, paco-* subcommands at /usr/share/paco/"
