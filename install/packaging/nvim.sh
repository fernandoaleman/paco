#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing neovim + LazyVim runtime deps"

# LazyVim's Mason auto-installer fetches LSPs/formatters at runtime. The
# extras paco ships (lang.json, lang.yaml, lang.markdown, lang.toml) need:
#   nodejs/npm:    jsonls, yamlls, prettier, marksman fallback
#   unzip:         common requirement for many Mason packages
#   tree-sitter:   CLI used by nvim-treesitter to compile parsers
#   wget:          some Mason install scripts use it instead of curl
#   python-pip:    Mason fetches Python LSPs (pyright, ruff, etc.) via pip
#   python-regex:  faster regex module some Python LSPs/formatters require
#   luarocks/lua51: silences lazy.nvim's hererocks check + future-proofs
#                   user plugins that need luarocks (image.nvim, magick.nvim,
#                   HTTP-based plugins, etc.)
#   imagemagick:   provides `magick` (v7) and `convert` (v6 compat) —
#                   used by image rendering / markdown preview
#   libyaml/libffi: ruby-build needs these to compile Ruby's psych and
#                   fiddle extensions (mise compiles Ruby from source).
# Skipped: rust/cargo — too heavy (~300 MB) for the base; users can
# `mise use -g rust@latest` if needed.
TOOLS=(neovim nodejs npm unzip tree-sitter wget python-pip python-regex luarocks lua51 imagemagick libyaml libffi)

missing=()
for t in "${TOOLS[@]}"; do
  paco-pkg-present "${t}" || missing+=("${t}")
done

if [[ ${#missing[@]} -eq 0 ]]; then
  echo "neovim + LazyVim deps already installed. Skipping."
  exit 0
fi

paco-pkg-add "${missing[@]}"
echo "neovim + LazyVim deps installed: ${TOOLS[*]}"
