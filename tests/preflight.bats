#!/usr/bin/env bats
# shellcheck shell=bash disable=SC2154

setup() {
  ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME}")/.." && pwd)"
}

@test "preflight scripts exist" {
  for f in all begin show-env guard hardware-mins git-author first-run-mode migrations-bootstrap; do
    [ -r "${ROOT}/install/preflight/${f}.sh" ]
  done
}

@test "all preflight scripts are syntactically valid" {
  for f in "${ROOT}/install/preflight/"*.sh; do
    run bash -n "${f}"
    [ "${status}" -eq 0 ]
  done
}
