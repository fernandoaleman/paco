#!/usr/bin/env bats
# shellcheck shell=bash disable=SC2154
bats_require_minimum_version 1.5.0

setup() {
  ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME}")/.." && pwd)"
}

@test "paco-webapp-* scripts exist and are executable" {
  [ -x "${ROOT}/bin/paco-launch-webapp" ]
  [ -x "${ROOT}/bin/paco-webapp-install" ]
  [ -x "${ROOT}/bin/paco-webapp-remove" ]
  [ -x "${ROOT}/bin/paco-webapp-remove-all" ]
  [ -x "${ROOT}/bin/paco-webapp-handler-zoom" ]
  [ -x "${ROOT}/bin/paco-restart-vicinae" ]
}

@test "all paco-webapp scripts are syntactically valid" {
  for f in "${ROOT}/bin/paco-launch-webapp" \
    "${ROOT}/bin/paco-webapp-install" \
    "${ROOT}/bin/paco-webapp-remove" \
    "${ROOT}/bin/paco-webapp-remove-all" \
    "${ROOT}/bin/paco-webapp-handler-zoom" \
    "${ROOT}/bin/paco-restart-vicinae"; do
    run bash -n "${f}"
    [ "${status}" -eq 0 ]
  done
}

@test "paco-launch-webapp refuses to run without a URL" {
  run -2 "${ROOT}/bin/paco-launch-webapp"
}

@test "13 bundled webapp icons are present" {
  for name in "Google Photos" "Google Contacts" "Google Messages" \
    "Google Maps" "Google Calendar" "Gmail" \
    "ChatGPT" "Gemini" "Claude" \
    "YouTube" "GitHub" "Discord" "Zoom"; do
    [ -r "${ROOT}/applications/icons/${name}.png" ]
  done
}

@test "icon attribution file exists" {
  [ -r "${ROOT}/applications/icons/ATTRIBUTION.md" ]
}

@test "webapp install scripts exist" {
  [ -r "${ROOT}/install/packaging/chrome.sh" ]
  [ -r "${ROOT}/install/packaging/icons.sh" ]
  [ -r "${ROOT}/install/packaging/webapps.sh" ]
  [ -r "${ROOT}/install/config/default-browser.sh" ]
}

@test "webapp install scripts are syntactically valid" {
  for f in "${ROOT}/install/packaging/chrome.sh" \
    "${ROOT}/install/packaging/icons.sh" \
    "${ROOT}/install/packaging/webapps.sh" \
    "${ROOT}/install/config/default-browser.sh"; do
    run bash -n "${f}"
    [ "${status}" -eq 0 ]
  done
}
