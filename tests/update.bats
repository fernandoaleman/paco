#!/usr/bin/env bats
# shellcheck shell=bash disable=SC2154

setup() {
  ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME}")/.." && pwd)"
}

@test "paco-update scripts exist and are executable" {
  [ -x "${ROOT}/bin/paco-update" ]
  [ -x "${ROOT}/bin/paco-update-git" ]
  [ -x "${ROOT}/bin/paco-migrate" ]
}

@test "paco-update scripts are syntactically valid" {
  for f in paco-update paco-update-git paco-migrate; do
    run bash -n "${ROOT}/bin/${f}"
    [ "${status}" -eq 0 ]
  done
}

@test "paco-update-git fails outside a git checkout" {
  run env PACO_PATH="${BATS_TEST_TMPDIR}/notagitrepo" \
    "${ROOT}/bin/paco-update-git"
  [ "${status}" -eq 1 ]
  [[ "${output}" == *"is not a git checkout"* ]]
}

@test "paco-migrate is a no-op when no migrations directory exists" {
  run env PACO_PATH="${BATS_TEST_TMPDIR}" \
    XDG_STATE_HOME="${BATS_TEST_TMPDIR}/state" \
    "${ROOT}/bin/paco-migrate"
  [ "${status}" -eq 0 ]
}
