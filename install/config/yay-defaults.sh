#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring yay defaults (removemake + cleanafter)"

yay_config="${XDG_CONFIG_HOME:-${HOME}/.config}/yay/config.json"

# Idempotency: skip if both keys already at desired values.
if [[ -f "${yay_config}" ]] &&
  [[ "$(jq -r '.removemake // ""' "${yay_config}" 2> /dev/null)" == "yes" ]] &&
  [[ "$(jq -r '.cleanAfter // false' "${yay_config}" 2> /dev/null)" == "true" ]]; then
  echo "yay defaults already set. Skipping."
  exit 0
fi

# Use yay's own CLI to persist — it knows its config format/keys.
yay -Y --save --removemake --cleanafter > /dev/null
echo "yay defaults set: removemake=yes, cleanAfter=true."
