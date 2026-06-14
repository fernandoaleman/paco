#!/usr/bin/env bats
# shellcheck shell=bash disable=SC2154
bats_require_minimum_version 1.5.0

setup() {
  ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME}")/.." && pwd)"
}

@test "login scripts exist" {
  [ -r "${ROOT}/install/login/all.sh" ]
  [ -r "${ROOT}/install/login/wayland-session.sh" ]
  [ -r "${ROOT}/install/login/sddm.sh" ]
  [ -r "${ROOT}/install/login/faillock-sddm.sh" ]
  [ -r "${ROOT}/install/login/plymouth.sh" ]
  [ -r "${ROOT}/install/login/limine-snapper.sh" ]
}

@test "boot stack default configs exist" {
  [ -r "${ROOT}/default/limine/limine.conf" ]
  [ -r "${ROOT}/default/limine/default.conf" ]
  [ -r "${ROOT}/default/snapper/root" ]
}

@test "all login scripts are syntactically valid" {
  for f in "${ROOT}/install/login/"*.sh; do
    run bash -n "${f}"
    [ "${status}" -eq 0 ]
  done
}

@test "paco.desktop session entry exists" {
  [ -r "${ROOT}/default/wayland-sessions/paco.desktop" ]
}
