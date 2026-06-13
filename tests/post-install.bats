#!/usr/bin/env bats
# shellcheck shell=bash disable=SC2154
bats_require_minimum_version 1.5.0

setup() {
  ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME}")/.." && pwd)"
}

@test "post-install scripts exist" {
  for f in all paco-install paco-profile pacman-config docker-compose-shim podman-quiet finished; do
    [ -r "${ROOT}/install/post-install/${f}.sh" ]
  done
}

@test "all post-install scripts are syntactically valid" {
  for f in "${ROOT}/install/post-install/"*.sh; do
    run bash -n "${f}"
    [ "${status}" -eq 0 ]
  done
}
