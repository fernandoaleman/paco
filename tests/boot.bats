#!/usr/bin/env bats
# shellcheck shell=bash disable=SC2154
# BATS_TEST_FILENAME is provided by bats at runtime.
bats_require_minimum_version 1.5.0

setup() {
  ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME}")/.." && pwd)"
}

@test "boot.sh exists and is executable" {
  [ -x "${ROOT}/boot.sh" ]
}

@test "install.sh exists and is executable" {
  [ -x "${ROOT}/install.sh" ]
}

@test "boot.sh is syntactically valid" {
  run bash -n "${ROOT}/boot.sh"
  [ "${status}" -eq 0 ]
}

@test "install.sh is syntactically valid" {
  run bash -n "${ROOT}/install.sh"
  [ "${status}" -eq 0 ]
}

# Full install.sh runtime test belongs on a real Arch host (it shells out
# to sudo pacman to bootstrap gum). See docs/implementation-plan.md
# iter 2 "Beelink test procedure" for the live test.
