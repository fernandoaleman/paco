#!/usr/bin/env bats
# shellcheck shell=bash disable=SC2154
# BATS_TEST_FILENAME is provided by bats at runtime.

setup() {
  ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME}")/.." && pwd)"
}

@test "boot.sh exists and is executable" {
  [ -x "${ROOT}/boot.sh" ]
}

@test "install.sh exists and is executable" {
  [ -x "${ROOT}/install.sh" ]
}

@test "install.sh prints skeleton banner and exits 0" {
  run env PACO_PATH=/tmp/paco-test bash "${ROOT}/install.sh"
  [ "${status}" -eq 0 ]
  [[ "${output}" == *"paco install — skeleton (iteration 1)"* ]]
  [[ "${output}" == *"PACO_PATH: /tmp/paco-test"* ]]
}
