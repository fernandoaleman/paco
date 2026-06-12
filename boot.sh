#!/usr/bin/env bash
# paco bootstrap — clones the paco repo and runs the installer.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/fernandoaleman/paco/master/boot.sh | bash
#
# Env vars:
#   PACO_REPO   GitHub repo slug   (default: fernandoaleman/paco)
#   PACO_REF    Branch/tag/SHA     (default: master)
#   PACO_PATH   Clone destination  (default: $HOME/.local/share/paco)

set -euo pipefail

PACO_REPO="${PACO_REPO:-fernandoaleman/paco}"
PACO_REF="${PACO_REF:-master}"
PACO_PATH="${PACO_PATH:-${HOME}/.local/share/paco}"

# Ensure git is available.
if ! command -v git > /dev/null 2>&1; then
  echo "==> Installing git..."
  sudo pacman -S --needed --noconfirm git
fi

# Clone or update the paco repo.
if [[ -d "${PACO_PATH}/.git" ]]; then
  echo "==> Updating existing paco repo at ${PACO_PATH}..."
  git -C "${PACO_PATH}" fetch origin
  git -C "${PACO_PATH}" checkout "${PACO_REF}"
  git -C "${PACO_PATH}" reset --hard "origin/${PACO_REF}"
else
  echo "==> Cloning paco from github.com/${PACO_REPO} (${PACO_REF})..."
  mkdir -p "$(dirname "${PACO_PATH}")"
  git clone --branch "${PACO_REF}" "https://github.com/${PACO_REPO}.git" "${PACO_PATH}"
fi

# Hand off to the installer.
export PACO_PATH
exec bash "${PACO_PATH}/install.sh"
