#!/usr/bin/env bats
# shellcheck shell=bash disable=SC2154
bats_require_minimum_version 1.5.0

setup() {
  ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME}")/.." && pwd)"
}

@test "login scripts exist" {
  [ -r "${ROOT}/install/login/all.sh" ]
  [ -r "${ROOT}/install/login/wayland-session.sh" ]
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
