#!/usr/bin/env bats
# shellcheck shell=bash disable=SC2154
bats_require_minimum_version 1.5.0

setup() {
  ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME}")/.." && pwd)"
  export PATH="${ROOT}/bin:${PATH}"
}

@test "dispatcher prints help on bare invocation" {
  run paco
  [ "${status}" -eq 0 ]
  [[ "${output}" == *"Usage: paco"* ]]
}

@test "dispatcher --help mirrors bare invocation" {
  run paco --help
  [ "${status}" -eq 0 ]
  [[ "${output}" == *"Usage: paco"* ]]
}

@test "dispatcher --version delegates to version subcommand" {
  run paco --version
  [ "${status}" -eq 0 ]
}

@test "dispatcher rejects unknown subcommand with exit 127" {
  run -127 paco doesnotexist
}

@test "dispatcher lists user-facing subcommands in help" {
  run paco --help
  [[ "${output}" == *"version"* ]]
  [[ "${output}" == *"update"* ]]
  [[ "${output}" == *"pkg-add"* ]]
  [[ "${output}" == *"pkg-aur-add"* ]]
  [[ "${output}" == *"setup-nvim-providers"* ]]
}

@test "dispatcher hides hidden subcommands from help" {
  run paco --help
  [[ "${output}" != *"update-git"* ]]
  [[ "${output}" != *"migrate"* ]]
  [[ "${output}" != *"pkg-aur-accessible"* ]]
}
