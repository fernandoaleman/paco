#!/usr/bin/env bats
# shellcheck shell=bash disable=SC2154
# BATS_TEST_FILENAME is provided by bats at runtime.

setup() {
  ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME}")/.." && pwd)"
}

@test "all helper scripts exist" {
  [ -r "${ROOT}/install/helpers/all.sh" ]
  [ -r "${ROOT}/install/helpers/errors.sh" ]
  [ -r "${ROOT}/install/helpers/logging.sh" ]
  [ -r "${ROOT}/install/helpers/presentation.sh" ]
  [ -r "${ROOT}/install/helpers/chroot.sh" ]
}

@test "paco-pkg-* scripts exist and are executable" {
  [ -x "${ROOT}/bin/paco-pkg-add" ]
  [ -x "${ROOT}/bin/paco-pkg-present" ]
  [ -x "${ROOT}/bin/paco-pkg-missing" ]
}

@test "paco-pkg-add requires args" {
  run "${ROOT}/bin/paco-pkg-add"
  [ "${status}" -eq 2 ]
}

@test "paco-pkg-present requires one arg" {
  run "${ROOT}/bin/paco-pkg-present"
  [ "${status}" -eq 2 ]
}

@test "logo.txt exists" {
  [ -r "${ROOT}/logo.txt" ]
}
