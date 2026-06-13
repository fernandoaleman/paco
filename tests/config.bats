#!/usr/bin/env bats
# shellcheck shell=bash disable=SC2154
bats_require_minimum_version 1.5.0

setup() {
  ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME}")/.." && pwd)"
}

@test "config scripts exist" {
  [ -r "${ROOT}/install/config/all.sh" ]
  [ -r "${ROOT}/install/config/zsh-layout.sh" ]
  [ -r "${ROOT}/install/config/default-shell.sh" ]
  [ -r "${ROOT}/install/config/fontconfig.sh" ]
  [ -r "${ROOT}/install/config/starship.sh" ]
  [ -r "${ROOT}/install/config/git-paco-defaults.sh" ]
  [ -r "${ROOT}/install/config/ghostty.sh" ]
  [ -r "${ROOT}/install/config/tmux.sh" ]
  [ -r "${ROOT}/install/config/nvim.sh" ]
  [ -r "${ROOT}/install/config/mise.sh" ]
  [ -r "${ROOT}/install/config/yay-defaults.sh" ]
  [ -r "${ROOT}/install/config/pacman-makepkg.sh" ]
  [ -r "${ROOT}/install/config/lazydocker.sh" ]
  [ -r "${ROOT}/install/config/podman-socket.sh" ]
  [ -r "${ROOT}/install/config/podman-environment.sh" ]
}

@test "default nvim files exist" {
  [ -r "${ROOT}/default/nvim/init.lua" ]
  [ -r "${ROOT}/default/nvim/lua/config/lazy.lua" ]
  [ -r "${ROOT}/default/nvim/lua/plugins/paco-distro.lua" ]
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
  [ -r "${ROOT}/default/zsh/conf.d/30-aliases.zsh" ]
  [ -r "${ROOT}/default/zsh/conf.d/40-zoxide.zsh" ]
  [ -r "${ROOT}/default/zsh/conf.d/99-plugins.zsh" ]
}

@test "zsh packaging script is syntactically valid" {
  run bash -n "${ROOT}/install/packaging/zsh.sh"
  [ "${status}" -eq 0 ]
}
