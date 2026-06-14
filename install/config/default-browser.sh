#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Setting Google Chrome as the default web browser"

# Per Q17: Chrome is paco's default browser. xdg-settings stores the
# user-level association; xdg-mime registers the http(s)/x-scheme
# handlers so `xdg-open https://...` finds Chrome too.
#
# Broader mimetype handlers (images → imv, videos → mpv, PDFs → viewer)
# are deferred to iter 20c once those bundled apps land.
target="google-chrome.desktop"

current="$(xdg-settings get default-web-browser 2> /dev/null || true)"
if [[ ${current} == "${target}" ]]; then
  echo "Default browser already ${target}."
else
  xdg-settings set default-web-browser "${target}"
  echo "Set default browser to ${target} (was: ${current:-unset})."
fi

# Scheme handlers — idempotent: xdg-mime default no-ops when already
# set to the requested value.
xdg-mime default "${target}" x-scheme-handler/http
xdg-mime default "${target}" x-scheme-handler/https
echo "x-scheme-handler/http(s) → ${target}"
