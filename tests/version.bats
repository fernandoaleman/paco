#!/usr/bin/env bats
# shellcheck shell=bash disable=SC2154
# BATS_TEST_FILENAME is provided by bats at runtime.

setup() {
  ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME}")/.." && pwd)"
  export PATH="${ROOT}/bin:${PATH}"
}

@test "paco version prints contents of version file" {
  expected="$(cat "${ROOT}/version")"
  run paco version
  [ "${status}" -eq 0 ]
  [ "${output}" = "${expected}" ]
}

@test "paco-version (direct) prints contents of version file" {
  expected="$(cat "${ROOT}/version")"
  run paco-version
  [ "${status}" -eq 0 ]
  [ "${output}" = "${expected}" ]
}

@test "paco --help lists version subcommand" {
  run paco --help
  [ "${status}" -eq 0 ]
  [[ "${output}" == *"version"* ]]
}

@test "paco unknown subcommand returns 127" {
  run paco doesnotexist
  [ "${status}" -eq 127 ]
}

@test "paco --version delegates to paco version" {
  expected="$(cat "${ROOT}/version")"
  run paco --version
  [ "${status}" -eq 0 ]
  [ "${output}" = "${expected}" ]
}
