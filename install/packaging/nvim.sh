#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing neovim + LazyVim runtime deps"

# LazyVim's Mason auto-installer fetches LSPs/formatters at runtime. The
# extras paco ships (lang.json, lang.yaml, lang.markdown, lang.toml) need:
#   nodejs/npm:    jsonls, yamlls, prettier, marksman fallback
#   unzip:         common requirement for many Mason packages
#   luarocks/lua51: silences lazy.nvim's hererocks check + future-proofs
#                   user plugins that need luarocks (image.nvim, magick.nvim,
#                   HTTP-based plugins, etc.)
TOOLS=(neovim nodejs npm unzip luarocks lua51)

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
