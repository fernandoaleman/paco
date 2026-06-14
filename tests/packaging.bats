#!/usr/bin/env bats
# shellcheck shell=bash disable=SC2154
bats_require_minimum_version 1.5.0

setup() {
  ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME}")/.." && pwd)"
}

@test "packaging scripts exist" {
  [ -r "${ROOT}/install/packaging/all.sh" ]
  [ -r "${ROOT}/install/packaging/yay.sh" ]
  [ -r "${ROOT}/install/packaging/zsh.sh" ]
  [ -r "${ROOT}/install/packaging/tools-tier1.sh" ]
  [ -r "${ROOT}/install/packaging/tools-tier2.sh" ]
  [ -r "${ROOT}/install/packaging/fonts.sh" ]
  [ -r "${ROOT}/install/packaging/starship.sh" ]
  [ -r "${ROOT}/install/packaging/tools-tier4.sh" ]
  [ -r "${ROOT}/install/packaging/dev-tools.sh" ]
  [ -r "${ROOT}/install/packaging/ghostty.sh" ]
  [ -r "${ROOT}/install/packaging/tools-tier3.sh" ]
  [ -r "${ROOT}/install/packaging/nvim.sh" ]
  [ -r "${ROOT}/install/packaging/podman.sh" ]
  [ -r "${ROOT}/install/packaging/hyprland.sh" ]
  [ -r "${ROOT}/install/packaging/sddm.sh" ]
  [ -r "${ROOT}/install/packaging/waybar-mako.sh" ]
  [ -r "${ROOT}/install/packaging/launcher.sh" ]
  [ -r "${ROOT}/install/packaging/boot-stack.sh" ]
  [ -r "${ROOT}/install/packaging/system-services.sh" ]
  [ -r "${ROOT}/install/packaging/chrome.sh" ]
  [ -r "${ROOT}/install/packaging/icons.sh" ]
  [ -r "${ROOT}/install/packaging/webapps.sh" ]
}

@test "all packaging scripts are syntactically valid" {
  for f in "${ROOT}/install/packaging/"*.sh; do
    run bash -n "${f}"
    [ "${status}" -eq 0 ]
  done
}

@test "paco-pkg-aur-add scripts exist and are executable" {
  [ -x "${ROOT}/bin/paco-pkg-aur-add" ]
  [ -x "${ROOT}/bin/paco-pkg-aur-accessible" ]
}

@test "paco-pkg-aur-add requires args" {
  run -2 "${ROOT}/bin/paco-pkg-aur-add"
}
