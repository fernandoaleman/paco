#!/usr/bin/env bats
# shellcheck shell=bash disable=SC2154
bats_require_minimum_version 1.5.0

setup() {
  ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME}")/.." && pwd)"
}

@test "install.sh exists and is executable" {
  [ -x "${ROOT}/install.sh" ]
}

@test "install.sh is syntactically valid" {
  run bash -n "${ROOT}/install.sh"
  [ "${status}" -eq 0 ]
}

@test "install.sh sources expected phases" {
  grep -q "preflight/all.sh" "${ROOT}/install.sh"
  grep -q "packaging/all.sh" "${ROOT}/install.sh"
  grep -q "config/all.sh" "${ROOT}/install.sh"
  grep -q "post-install/all.sh" "${ROOT}/install.sh"
}

@test "all phase orchestrators exist" {
  [ -r "${ROOT}/install/helpers/all.sh" ]
  [ -r "${ROOT}/install/preflight/all.sh" ]
  [ -r "${ROOT}/install/packaging/all.sh" ]
  [ -r "${ROOT}/install/config/all.sh" ]
  [ -r "${ROOT}/install/post-install/all.sh" ]
}
