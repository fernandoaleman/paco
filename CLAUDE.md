# paco — project instructions for Claude

paco is an opinionated Arch Linux + Hyprland distribution inspired by Omarchy
(github.com/basecamp/omarchy) but trimmed and personalized. Ultimate
deliverable: a downloadable ISO with a `paco update` mechanism.

## Working state

- **Phase:** 2 (build paco step-by-step). Phase 1 (research) is complete.
- **Plan:** `/Users/faleman/.claude/plans/i-want-you-to-pure-deer.md` —
  the 50-question track and full approach.
- **Research repo:** `/Users/faleman/code/paco-research/` — 26 markdown
  pages documenting how Omarchy is built, with file-path citations.
  Consult the matching `docs/NN-<topic>.md` before any design decision.
- **Reference repo:** `/Users/faleman/code/omarchy/` — Omarchy's source.

## Working style

- One focused question at a time (or 2–4 closely-related). No batching.
- Preview before any state-changing command; wait for confirmation.
- Track multi-step work with TaskCreate.
- Save artifacts (resource IDs, etc.) to `responses/NN-description.json`
  when provisioning real infrastructure.

## Tool preferences

User strongly prefers Rust-built CLI tools (e.g., `fd` > `find`, `rg` >
`grep`, `prek` > `pre-commit`, `just` > `make`, `typos`, `committed`).

- When the user mentions a tool by name, and a meaningfully better/newer
  Rust-based alternative exists, **ask before defaulting to the named
  one.** Don't silently substitute.
- When recommending a tool unprompted, default to a mature Rust-built
  option when one exists and call out the Rust pedigree.
- Don't force Rust-only — when no mature Rust alternative exists
  (shellcheck = Haskell, shfmt = Go, bats = bash, markdownlint = JS),
  use what works.

## Bundled apps require per-item approval

For Q19 (web apps), Q20 (commercial apps), Q21 (TUIs/utilities), and
any other "what to bundle by default" decision: ask user per item, do
NOT propose en-masse lists. See auto-memory
`feedback-approve-bundled-apps`.

## Distro-vs-personal philosophy

paco ships a minimal, working base. For every customization decision,
apply the distro-level-vs-personal lens:

- **Distro-level (ship as default):** every user benefits regardless of
  stack/workflow. Examples: file-picker hidden visibility, tmux-nvim
  Ctrl+hjkl, transparency when terminal is opaque, news-alert
  suppression.
- **Personal preference (don't ship):** some users want, some don't.
  Examples: `jk`→ESC, language-specific LSP pins, jinja autodetect.

Lean Omarchy-minimal for the base. Users layer their own via standard
override paths (e.g., `~/.config/nvim/lua/plugins/*.lua` merges with
LazyVim defaults).

## Reference user's existing configs

Before recommending or drafting config for any tool we're discussing
(terminal, editor, prompt, multiplexer, TUI, CLI), **check the user's
`~/.config/<tool>/` first** for their existing setup. Adopt their
settings by default; deviate only with environment-specific reason
(e.g., Mac retina font-size doesn't translate to Hyprland DPI). Call
out what you're inheriting vs tuning so they can override.

Known configured tools (inventory 2026-06-05): alacritty, ghostty,
nvim, starship.toml, tmux, tmux-ssh, sesh, lazygit, lazydocker, btop,
htop, bat, mise, gh, op, chezmoi, git, zsh.

## XDG Base Directory strategy

User wants paco to follow the XDG Base Directory Specification wherever
possible to keep `$HOME` minimal. Reference: user's own `~/.config/zsh/`
on macOS is the canonical pattern.

- Config → `$XDG_CONFIG_HOME` (default `~/.config`)
- Data → `$XDG_DATA_HOME` (default `~/.local/share`)
- State → `$XDG_STATE_HOME` (default `~/.local/state`)
- Cache → `$XDG_CACHE_HOME` (default `~/.cache`)
- `$HOME` should only contain `.zshenv` (the minimal shim that sets the
  XDG vars + `ZDOTDIR`) and tool dotfiles that don't yet support XDG.
- When a tool doesn't support XDG: check
  [xdg-ninja](https://github.com/b3nj5m1n/xdg-ninja) for workarounds
  before accepting clutter.

## Conventions paco adopts from the start (deltas from Omarchy)

- `prek.toml` (pre-commit hooks) — Omarchy ships none.
- `committed.toml` (conventional commits) — Omarchy ships none.
- `.typos.toml` (typo linting) — Omarchy ships none.
- `tests/` at repo root (Omarchy uses `test/`).

## Current dev environment

- Building paco *from* macOS while user doesn't yet have an Arch machine.
- justfile supports both: `just install` auto-detects OS and dispatches
  to `install-mac` (Homebrew) or `install-arch` (pacman).
- Lint and test recipes work identically on both OSes; only `install`
  differs.

## Decisions log (Phase 2)

- Q1: MIT license, `master` branch, minimal `.gitignore`.
- Q2: Private GitHub repo at `github.com/fernandoaleman/paco`.
- Q3: No directories yet; root meta files only (this file, README, version, .editorconfig).
- Q4: Lint configs `.shellcheckrc` + `.typos.toml`. Shfmt deferred to Q5.
- Q5: prek (`prek.toml`) for pre-commit hooks; `.markdownlint.yaml` relaxed baseline.
- Q6: Conventional Commits via `committed.toml`, applied going forward only.
- Q7: bats-core for tests; `tests/*.bats` one file per top-level subcommand.
- Q8: GitHub Actions CI on Arch container only; justfile drives lint/test
  for both CI and local dev (one source of truth).
- Q9: zsh as default interactive shell. `bin/` scripts stay bash
  (`#!/usr/bin/env bash`). Plugins: zsh-autosuggestions, zsh-completions,
  zsh-syntax-highlighting (all Arch `extra`). Sourcing order at install
  time: completions → autosuggestions → syntax-highlighting (last).
- Q11 (finalized): Starship hybrid config = Omarchy's structure + user's
  vim-mode-aware character. Modules enabled: directory (truncate to 2 +
  repo root highlighted), git_branch (italic cyan), git_status (full
  glyph set), character (with vimcmd_* symbols). `command_timeout=200ms`
  (Arch SSDs are fast). Disabled: aws, battery, package, username,
  hostname, docker_context, git_commit, git_state, git_metrics. Colors
  hard-coded as `cyan` get overridden per-theme via paco's theme system
  (Q15). Source configs: ~/.config/starship.toml (user, vim symbols),
  omarchy/config/starship.toml (Omarchy, structure/glyphs).
- zsh vi mode: `bindkey -v` ships as paco default. Matches user's
  ~/.config/zsh/conf.d/20-keybindings.zsh.
- Layout convention: zsh follows XDG. `~/.zshenv` is a minimal shim that
  sets `XDG_*` and `ZDOTDIR=$XDG_CONFIG_HOME/zsh`. Everything else
  (rc, conf.d/, functions/, completion/) lives under `$ZDOTDIR`. Cache
  `zcompdump` goes to `$XDG_CACHE_HOME/zsh/zcompdump`. Pacman-installed
  plugins are sourced from `/usr/share/zsh/plugins/<name>/<name>.zsh`.
- Q10: ghostty as default terminal. Inherit settings from user's
  `~/.config/ghostty/config`: `copy-on-select=clipboard`,
  `shell-integration=detect`, `mouse-hide-while-typing=true`,
  `background-opacity=0.9`, `window-padding-x/y=25/20`,
  `keybind shift+enter=text:\x1b\r` (Claude Code multi-line input).
  Tune for Hyprland: smaller `font-size` (~11–12 vs Mac's 16), adopt
  `async-backend=epoll` from Omarchy's config (Hyprland slowness fix,
  ghostty discussion #3224), add OSC-52 paste/copy keybinds. Skip
  ghostty's split-pane keybinds — tmux owns multiplexing.
- Multiplexing: **tmux confirmed** (sessions, split panes, windows).
  User also uses `sesh` for session management. Detail decisions
  deferred to Q21 area (TUIs/utilities). Refs: `~/.config/tmux/`,
  `~/.config/tmux-ssh/`, `~/.config/sesh/` on user's Mac.
- Q12: LazyVim as paco's nvim editor. Philosophy: ship a simple,
  working base; users override via `~/.config/nvim/lua/plugins/`.
  - Theme: Omarchy hot-reload pattern (theme.lua symlink,
    all-themes.lua, paco-theme-hotreload.lua, per-theme neovim.lua).
    Catppuccin's integrations block moves into themes/catppuccin/neovim.lua.
  - Extras (7): editor.neo-tree, lang.markdown, lang.json, lang.yaml,
    lang.toml, lang.git, coding.blink.
  - Plugins shipped: blink keymap tweaks, snacks picker config (hidden
    files + lazygit backdrop), vim-tmux-navigator.
  - Distro overrides: disable-news-alert.lua. Animation stays on.
  - Transparency: Omarchy's plugin/after/transparency.lua (~50 groups).
  - Keymaps: `<`/`>` stay-in-visual only.
  - No autocmds, no options overrides, no ftplugin/ftdetect overrides.
  - Stylua: spaces, indent_width=2, column_width=120. prek hook added
    (StyLua v2.5.2).
- Q21 pre-answer: lazygit AND lazydocker ship by default. Specific
  keymaps deferred to TUI/utilities section (Q21 area).
- Q13: Vicinae as default launcher (Raycast-style, Raycast-compatible
  extensions). Subsumes clipboard, emoji, snippets, calculator, and
  shortcuts/quicklinks. Walker (Rust) is fallback if Vicinae fails
  validation. See `project-launcher-vicinae-fallback` in auto-memory
  for the validation gates. Q13a (separate clipboard manager) and the
  emoji-picker question are now moot.
- Q14: Waybar as status bar. Pragmatic distro default — C++ but with
  drop-in module library and CSS theme-pipeline fit. Position/modules
  detail deferred to when we build `config/waybar/` (Q39 area). Paco
  menu button (replaces Omarchy's omarchy.ttf trick) deferred to Q33
  branding.
- Q15: Mako as notification daemon. Wayland-native, layer-shell,
  Omarchy-proven. Theme via INI template (`default/themed/mako.ini.tpl`)
  with text/border/background color injection per theme. DND toggle
  pattern inherited from Omarchy. Config detail deferred to Q39 area.
- Q16: File manager — Thunar (GUI) + yazi (TUI). Thunar chosen over
  Nautilus for lighter dep tree (~15 MB vs ~150 MB of GNOME deps);
  both behave identically under paco's gsettings-driven GTK theming
  (gtk-theme + color-scheme + icon-theme). yazi (Rust) chosen for TUI
  alongside lazygit/lazydocker — Rust pedigree + image preview support
  via ghostty. Hyprland keybind for thunar deferred to Q31 keybindings.
- Q17 (revised): Google Chrome as default browser. Reverses earlier
  Brave pick. Reasoning: user is committing to the Google ecosystem
  (Photos, Contacts, Messages, Maps, Calendar, Gmail as bundled
  web-apps in Q19), so Chrome's native Google Account sync is the
  cleanest fit. AUR `google-chrome`. Preserves PWA `--app=` mode + full
  Google sync. Other browsers installable later via
  `paco-install-browser <name>`.
- Q18: Web-app strategy = clone Omarchy's pattern as `paco-webapp-*`
  commands (`-install`, `-remove`, `-remove-all`, `-launch`). Chrome
  `--app=` mode drives it. Keep generalized Zoom URL-scheme handler.
  **Drop HEY-specific mailto handler** (Basecamp-internal). Default
  bundled web-apps via per-item approval rule (Q19+).
- Q19: Default bundled web-apps (14, per-item approved): Google Photos,
  Google Contacts, Google Messages, Google Maps, Google Calendar, Gmail,
  YouTube, ChatGPT, GitHub, Discord, Zoom (with URL-scheme handler),
  Claude, Slack, 1Password. Skipped Omarchy defaults: HEY, Basecamp,
  Fizzy, WhatsApp, X, Figma. Icons bundled from Omarchy's set (9): Google
  Photos, Google Contacts, Google Messages, Google Maps, YouTube, ChatGPT,
  GitHub, Discord, Zoom. **Do not copy Omarchy icons for apps we aren't
  using** (HEY/Basecamp/Fizzy/WhatsApp/X/Figma/Disk Usage/Docker/imv/
  Retro Gaming/windows). Icons to source (5): Google Calendar, Gmail,
  Claude, Slack, 1Password — try flaticon.com first (see auto-memory
  `feedback-flaticon-for-icons`).

## Pending decisions

- Keymap for lazydocker (user's Mac uses `<leader>dd` via snacks
  terminal). LazyVim already ships `<leader>gg` for lazygit. Decide
  when we reach Q21 (TUIs/utilities).
- Vicinae validation gates (theming, layer-shell, stability, latency,
  shortcuts/quicklinks) to be tested when we build
  `install/packaging/launcher.sh` at Q39. If hard gates fail, swap to
  Walker.
- Source 5 missing web-app icons (Google Calendar, Gmail, Claude, Slack,
  1Password) when building `install/packaging/webapps.sh` at Q39.
  Try flaticon.com first.
- Create `applications/icons/ATTRIBUTION.md` with source + license for
  each bundled icon (Omarchy-derived + new sources).
