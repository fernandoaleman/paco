#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Setting zsh as default shell"

current_shell="$(getent passwd "${USER}" | cut -d: -f7)"
zsh_path="$(command -v zsh)"

if [[ "${current_shell}" == "${zsh_path}" ]]; then
  echo "Default shell already ${zsh_path}. Skipping."
  exit 0
fi

# Ensure zsh is registered in /etc/shells (required by chsh).
if ! grep -qFx "${zsh_path}" /etc/shells; then
  echo "Adding ${zsh_path} to /etc/shells..."
  echo "${zsh_path}" | sudo tee -a /etc/shells > /dev/null
fi

echo "Changing default shell: ${current_shell} → ${zsh_path}"
sudo chsh -s "${zsh_path}" "${USER}"
echo "Default shell set. Effective on next login."
