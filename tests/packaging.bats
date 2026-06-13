#!/usr/bin/env bats
# shellcheck shell=bash disable=SC2154

setup() {
  ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME}")/.." && pwd)"
}

@test "packaging scripts exist" {
  [ -r "${ROOT}/install/packaging/all.sh" ]
  [ -r "${ROOT}/install/packaging/yay.sh" ]
  [ -r "${ROOT}/install/packaging/zsh.sh" ]
  [ -r "${ROOT}/install/packaging/tools-tier1.sh" ]
  [ -r "${ROOT}/install/packaging/tools-tier2.sh" ]
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
  run "${ROOT}/bin/paco-pkg-aur-add"
  [ "${status}" -eq 2 ]
}
