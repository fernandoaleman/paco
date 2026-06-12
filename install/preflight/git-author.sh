#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

# Skip if already set.
existing_name="$(git config --global user.name 2> /dev/null || true)"
existing_email="$(git config --global user.email 2> /dev/null || true)"

if [[ -n "${existing_name}" ]] && [[ -n "${existing_email}" ]]; then
  echo "Git config already set: ${existing_name} <${existing_email}>. Skipping prompt."
  exit 0
fi

paco_section "Git config (one-time)"
echo "Set up your git author identity. (Change later with"
echo "  git config --global user.name / user.email)"
echo

# Read from /dev/tty so this works under curl-pipe-bash (where stdin
# is the curl stream, not the terminal).
read -rp "Your name: " git_name < /dev/tty
while [[ -z "${git_name}" ]]; do
  read -rp "Name cannot be empty. Your name: " git_name < /dev/tty
done

read -rp "Your email: " git_email < /dev/tty
while [[ -z "${git_email}" ]]; do
  read -rp "Email cannot be empty. Your email: " git_email < /dev/tty
done

git config --global user.name "${git_name}"
git config --global user.email "${git_email}"
echo "Git config saved: ${git_name} <${git_email}>"
