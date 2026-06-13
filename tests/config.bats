#!/usr/bin/env bats
# shellcheck shell=bash disable=SC2154

setup() {
  ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME}")/.." && pwd)"
}

@test "config scripts exist" {
  [ -r "${ROOT}/install/config/all.sh" ]
  [ -r "${ROOT}/install/config/zsh-layout.sh" ]
}

@test "all config scripts are syntactically valid" {
  for f in "${ROOT}/install/config/"*.sh; do
    run bash -n "${f}"
    [ "${status}" -eq 0 ]
  done
}

@test "default zsh files exist" {
  [ -r "${ROOT}/default/zsh/.zshrc" ]
  [ -r "${ROOT}/default/zsh/conf.d/10-options.zsh" ]
  [ -r "${ROOT}/default/zsh/conf.d/20-keybindings.zsh" ]
  [ -r "${ROOT}/default/zsh/conf.d/30-plugins.zsh" ]
}

@test "zsh packaging script is syntactically valid" {
  run bash -n "${ROOT}/install/packaging/zsh.sh"
  [ "${status}" -eq 0 ]
}
