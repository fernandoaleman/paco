#!/usr/bin/env bats
# shellcheck shell=bash disable=SC2154

setup() {
  ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME}")/.." && pwd)"
}

@test "preflight scripts exist" {
  [ -r "${ROOT}/install/preflight/all.sh" ]
  [ -r "${ROOT}/install/preflight/begin.sh" ]
  [ -r "${ROOT}/install/preflight/show-env.sh" ]
  [ -r "${ROOT}/install/preflight/guard.sh" ]
}

@test "all preflight scripts are syntactically valid" {
  for f in "${ROOT}/install/preflight/"*.sh; do
    run bash -n "${f}"
    [ "${status}" -eq 0 ]
  done
}
