# paco — project instructions for Claude

paco is an opinionated Arch Linux + Hyprland distribution inspired by Omarchy
(github.com/basecamp/omarchy) but trimmed and personalized. Ultimate
deliverable: a downloadable ISO with a `paco update` mechanism.

## Working state

- **Phase:** 2 implementation sprint. Iterations 1–6 of 21 complete
  (2026-06-12, latest commit `a4d68e8`).
  - paco installed system-wide at `/usr/bin/paco`
  - 6 user-facing subcommands: `update`, `version`, `pkg-add`,
    `pkg-aur-add`, `pkg-present`, `pkg-missing`. Hidden internals:
    `update-git`, `migrate`, `pkg-aur-accessible`.
  - `/usr/share/paco/bin` on PATH via `/etc/profile.d/paco.sh` (new
    shells); install.sh prepends `${PACO_PATH}/bin` for current session
  - yay (AUR helper) installs from AUR on first run; `paco pkg-aur-add
    <pkg>` works
  - All phases fully idempotent (zero sudo prompts when nothing changed)
- **Next iteration:** Iteration 7 — zsh + 3 plugins + XDG layout
  (zsh-autosuggestions, zsh-completions, zsh-syntax-highlighting;
  `~/.zshenv` shim + `$ZDOTDIR=$XDG_CONFIG_HOME/zsh`). Default shell
  stays bash for now — chsh happens in iter 8. See
  `docs/implementation-plan.md` iter 7 for files + test procedure.
- **Plan:** `/Users/faleman/code/paco/docs/implementation-plan.md`
  (also persisted at `~/.claude/plans/continue-paco-before-we-giggly-blanket.md`)
- **Original 50-question plan:** `/Users/faleman/.claude/plans/i-want-you-to-pure-deer.md`
  (Q1–Q50 all answered; archived reference).
- **Research repo:** `/Users/faleman/code/paco-research/` — 26 markdown
  pages documenting how the reference distro is built. Consult the
  matching `docs/NN-<topic>.md` before any implementation step.
- **Reference repo:** `/Users/faleman/code/omarchy/` — reference
  distro's source.
- **Test machine:** Beelink SER8 at `ssh beelink` (Mac Host alias
  in `~/.ssh/config`). See auto-memory `project-beelink-ssh-setup`.

## How to resume

Open this directory in Claude Code. Say "continue paco" or "start
implementation." Claude will:

1. Read this file
2. See Phase 2 implementation sprint is next
3. Check the "Pending decisions" section for deferred wiring items
4. Propose starting with `install/helpers/` + `install.sh` skeleton

_(The "Working state" tracker and this "How to resume" section can be
removed when the implementation sprint is fully complete and paco
v1 is shipped.)_

## First-time setup on a new machine

The bootstrap is chicken-and-egg (justfile references `just`).

**macOS:**

```bash
brew install just
just install   # installs bats-core, pipx, prek
just hooks     # wires prek into .git/hooks/pre-commit + commit-msg
```

**Arch Linux:**

```bash
sudo pacman -S --needed just
just install   # installs git python python-pipx bats; pipx install prek
just hooks     # wires prek into .git/hooks/pre-commit + commit-msg
```

After this, every `git commit` runs the full prek hook suite locally —
markdownlint, shellcheck, shfmt, typos, trailing whitespace, conventional
commits validation. Lint failures get caught before push, not in CI.

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

## paco branding hygiene

User-facing paco content (README, install scripts, runtime help/errors,
shipped command output) must not contain "Omarchy" as a brand name.
CLAUDE.md retains Omarchy references as internal design-history
context. See auto-memory `project-no-omarchy-in-user-facing`.

## Verify CI after every push

After every `git push`, wait for GitHub Actions CI to complete and
verify it passes before moving on to the next step. Catches failures
immediately instead of letting them pile up. See auto-memory
`feedback-verify-ci-after-push`.

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

- Building paco _from_ macOS while user doesn't yet have an Arch machine.
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
- Q19 (revised): Default bundled web-apps (12, per-item approved):
  Google Photos, Google Contacts, Google Messages, Google Maps, Google
  Calendar, Gmail, YouTube, ChatGPT, GitHub, Discord, Zoom (with
  URL-scheme handler), Claude. 1Password and Slack moved to native in
  Q20 (Omarchy pattern: one mode per app). Skipped Omarchy defaults:
  HEY, Basecamp, Fizzy, WhatsApp, X, Figma. Icons bundled from
  Omarchy's set (9): Google Photos, Google Contacts, Google Messages,
  Google Maps, YouTube, ChatGPT, GitHub, Discord, Zoom. **Do not copy
  Omarchy icons for apps we aren't using** (HEY/Basecamp/Fizzy/WhatsApp/
  X/Figma/Disk Usage/Docker/imv/Retro Gaming/windows). Icons to source
  (3): Google Calendar, Gmail, Claude — try flaticon.com first (see
  auto-memory `feedback-flaticon-for-icons`).
- Q20: Default bundled native apps (5, per-item approved): 1Password
  (`1password` + `1password-cli`), Claude Code (`claude-code`), Slack
  (`slack-desktop`), Spotify (`spotify`), Obsidian (`obsidian`). Stable
  branch (not Omarchy's `1password-beta`) — to confirm at install
  script time (Q39). Skipped: Typora (paid), Cursor, VS Code (user
  uses LazyVim; both would be optional `paco-install-<name>` later).
- Q21: Default bundled CLI/TUI tools (21, per-item approved):
  - Tier 1 (5): bat, **bottom/btm** (Rust, replacing btop — Rust pedigree
    with theme integration via `default/themed/bottom.toml.tpl` and
    `paco-restart-bottom` helper), lazydocker, lazygit, tmux.
  - Tier 2 (10): dust, eza, fd, fzf, gum, jq, ripgrep, tldr, zoxide,
    fastfetch.
  - Tier 3 (3): mise (Rust version manager — needs shell activation
    line in `default/zsh/conf.d/`), sesh (Go tmux session manager —
    needs tmux keybind to invoke), gh (GitHub CLI).
  - Tier 4 (3): delta (Rust git diff prettifier — needs git pager
    config in `default/git/config`), procs, hyperfine.
  - Skipped: inxi, htop (redundant with bottom), chezmoi (personal),
    thefuck (personal), atuin, yq.
- Q21 keymap: ship `<leader>dd` → lazydocker via snacks terminal in
  paco's nvim defaults. `<leader>gg` → lazygit is LazyVim default.
- Q22: SDDM as login manager (Omarchy current pattern). Includes:
  - Autologin enabled by default for single-user laptops
    (`/etc/sddm.conf.d/autologin.conf` with `User=$USER`, `Session=paco`)
  - Custom paco QML theme at `/usr/share/sddm/themes/paco/`
    (replaces Omarchy's QML — deferred to Q33 branding for paco logo +
    color palette injection)
  - "Hyprland renders SDDM's login UI" pattern (`CompositorCommand=
    start-hyprland --config /usr/share/sddm/hyprland.lua`)
  - Passwordless `Default_keyring` + `pam_gnome_keyring.so` stripped
    from `/etc/pam.d/sddm` (Omarchy's pattern — single-user/LUKS
    assumption; revisit security model in Q44)
  - paco session entry: `/usr/local/share/wayland-sessions/paco.desktop`
    with `Exec=uwsm start -g -1 -e -D Hyprland hyprland.desktop`
- Wayland-session decision: `uwsm` wrapper (Omarchy pattern) for proper
  systemd `graphical-session.target` integration. Confirms the
  uwsm dependency in paco's base packages.
- Q23: Plymouth boot splash enabled (Omarchy pattern). Graphical boot
  splash + graphical LUKS unlock prompt. paco theme assets (logo,
  bullet, lock/lock-failed, entry/entry-failed, progress bar) deferred
  to Q33 branding. Background color sourced from active paco theme's
  colors.toml (not hardcoded like Omarchy's `#1a1b26`).
- Plymouth requires: mkinitcpio HOOKS list includes `plymouth`,
  `plymouth-quit-wait.service` unmasked.
- Q24: Limine bootloader (Omarchy pattern) with `limine-snapper-sync`
  for boot-into-snapshot rollback. Both UEFI and BIOS supported.
  Snapper integration assumes btrfs — formal stance on filesystem
  decided in Q43. Config templates at `default/limine/{default.conf,
  limine.conf}` (Omarchy pattern; paco-rebrand to match).
- mkinitcpio HOOKS list (Omarchy-derived): `base udev plymouth keyboard
  autodetect microcode modconf kms keymap consolefont block encrypt
  filesystems fsck btrfs-overlayfs`
- Snapper for `/` only (NOT `/home`) — user data shouldn't roll back.
- `btrfs quota disable /` for performance.
- Q25: Audio = PipeWire + wireplumber. easyeffects skipped (personal —
  GUI EQ users install themselves via `paco-install-easyeffects` later).
  Packages: `pipewire`, `pipewire-alsa`, `pipewire-pulse`,
  `pipewire-jack`, `wireplumber` (Omarchy's set).
- Q26: Power management = `power-profiles-daemon` (Omarchy default).
  3-mode picker (Power Saver / Balanced / Performance) integrated via
  waybar. tlp / auto-cpufreq available as opt-in via
  `paco-install-tlp` / `paco-install-auto-cpufreq`.
- Q27: Networking = **NetworkManager** (deviation from Omarchy's iwd
  choice). Heavier but GUI-friendly. Click-to-connect UX out of box,
  nm-applet integrates with waybar. Handles wifi + ethernet + VPN +
  proxy in one daemon. Package: `networkmanager` (with
  `nm-connection-editor` GUI). systemd-networkd-wait-online disabled
  to avoid boot timeout (Omarchy pattern carried over).
- Q27 firewall: UFW enabled by default with default-deny incoming.
  Standard desktop hardening. Package: `ufw`. Service enabled in
  install scripts.
- Q28: Bluetooth = bluez + blueman (with GTK tray applet).
  Click-to-pair via waybar tray. Packages: `bluez`, `bluez-utils`,
  `blueman`. Service `bluetooth.service` enabled at install.
- Q29: Theme system architecture (Omarchy pattern adapted to paco's
  app set). Three layers:
  - **Theme directory** at `themes/<name>/` with: `colors.toml`
    (palette: color0-15, background, foreground, accent, cursor),
    `backgrounds/`, `icons.theme`, `bottom.toml`, `neovim.lua`
    (colorscheme spec + Catppuccin's integrations block per Q12),
    `preview.png` / `preview-unlock.png` / `unlock.png`. Drop:
    `vscode.json`, `btop.theme`.
  - **Templates** at `default/themed/*.tpl` processed per theme into
    `~/.config/paco/current/theme/<file>`:
    - Bundled-app templates: `ghostty.conf.tpl`, `waybar.css.tpl`,
      `mako.ini.tpl`, `hyprland.lua.tpl`, `hyprlock.conf.tpl`,
      `obsidian.css.tpl`, `chrome.theme.tpl`, `bottom.toml.tpl`,
      `vicinae.<ext>.tpl` (or `walker.css.tpl` on fallback)
    - Optional-alternative templates (for `paco-install-<X>` to
      inherit theme): `alacritty.toml.tpl`, `foot.ini.tpl`,
      `kitty.conf.tpl`
    - Dropped from Omarchy's set: `quickshell.json.tpl`,
      `helix.toml.tpl`, `keyboard.rgb.tpl`
    - GTK apps (Thunar, blueman, easyeffects, etc.) get themed via
      `gsettings` in `paco-theme-set-gnome` — no per-app templates
      needed.
  - **`paco-theme-set <name>` command** updates
    `~/.config/paco/current/theme` symlink, renders all templates with
    **gum** substitution (Charm tool from Q21), fires per-app restart
    helpers (`paco-restart-waybar`, `paco-restart-mako`,
    `paco-restart-bottom`, etc.), runs `paco-theme-set-gnome`, and
    fires nvim `:LazyReload` via `paco-theme-hotreload.lua` hook (Q12).
  - **Per-app integration**: each user config does either a symlink
    or `@import`/`source` directive pointing at
    `~/.config/paco/current/theme/<file>` so config files don't
    change at runtime — only the symlink target does.
- Q30: Bundled themes (13). First-boot default = `catppuccin-macchiato`.
  - **Catppuccin (3):** `catppuccin-macchiato` (NEW, default),
    `catppuccin` (mocha), `catppuccin-latte`
  - **Dark (8):** tokyo-night, gruvbox, nord, ristretto, ethereal,
    osaka-jade, solitude, hackerman
  - **Light (2):** flexoki-light, white
  - Dropped from Omarchy's 21: everforest, kanagawa, last-horizon,
    lumon, matte-black, miasma, retro-82, rose-pine, vantablack
- Q30 implementation note for Q39 area:
  - Author `catppuccin-macchiato` theme directory from scratch using
    official Catppuccin palette (24 color fields, `neovim.lua`,
    `bottom.toml`, `icons.theme`, backgrounds, previews)
  - Copy 12 themes verbatim from Omarchy and paco-rebrand (rename
    omarchy → paco references, update `neovim.lua` if it depends on
    Omarchy-specific paths)
- Q30 deferred: custom "paco" branded theme. `catppuccin-macchiato`
  serves as first-boot default for v1; a future `paco-default` theme
  with paco-brand colors can be added later when branding (Q33)
  matures.
- Q31: Keybindings — adopt Omarchy's modular Lua binding files
  (`default/hypr/bindings/*.lua`) as baseline. Detailed pruning and
  paco-rebrand deferred to Q39 area when we author `config/hypr/`.
  Known renames needed at that time:
  - `omarchy-*` command references → `paco-*`
  - Walker mode bindings → Vicinae equivalents (per Q13)
  - HEY-specific `mailto:` handler binding → dropped (per Q18)
  - lazydocker keybind in nvim already locked in at Q21
    (`<leader>dd`)
- Q32: Hyprland config style = Lua-based modular (Omarchy pattern).
  Files: `default/hypr/bindings/*.lua`, `monitors.lua`, `input.lua`,
  `hyprlock.lua`, etc. Compile/translate step to Hyprland's `.conf`
  format. Theme template at `hyprland.lua.tpl` (per Q29).
- Q33: Branding scope = mirror reference distro's full brand depth.
  Custom `paco.ttf` font with paco menu glyph (waybar button), paco
  logo (SVG + PNG), ASCII logo for shell, Plymouth boot theme assets,
  SDDM `Main.qml` with paco identity, wallpapers per bundled theme.
  Logo design vibe deferred — will explore options when designing.
  All asset design deferred to Q39 area.
- Q34: Custom `paco.ttf` font with brand glyph (single character in
  Private Use Area). Generated from paco SVG logo via FontForge or
  Python fonttools script. Ships as `default/fonts/paco.ttf`,
  installed to `/usr/share/fonts/paco/paco.ttf`. Waybar reference:
  `format = "<span font='paco'></span>"`. Generation deferred to Q39
  area pending logo design (Q33 deferred).
- Q35: Bundled fonts (4, lean): `ttf-jetbrains-mono-nerd` (primary
  monospace — terminal/code, Nerd Font glyphs for waybar/yazi),
  `noto-fonts` (universal sans/serif), `noto-fonts-emoji` (color
  emoji), `ttf-liberation` (Liberation Sans/Serif — referenced by
  fontconfig as default sans/serif). Skipped: `noto-fonts-cjk`,
  `ttf-ia-writer`, and all optional alternative mono fonts (Cascadia,
  Fira, Source Code Pro, Inter) — users install themselves if they
  prefer those.
- fontconfig (Omarchy-derived): sans-serif → Liberation Sans;
  serif → Liberation Serif; monospace appends JetBrainsMono Nerd
  Font; system-ui → Liberation Sans.
- Q36: CLI architecture = **full metadata-driven dispatcher** (Omarchy
  pattern). Single `paco` bash script (~1000 lines like Omarchy's
  `bin/omarchy` dispatcher) reads metadata headers from each
  subcommand script and produces polished help.
  - Metadata format: `# paco:summary=<one-liner>`, `# paco:hidden=true`,
    `# paco:group=<group>` (for category grouping).
  - Generated help: `paco --help`, `paco <group> --help`, etc.
    Colored, formatted, command groups, hidden commands hidden by
    default.
  - Subcommand layout: `bin/paco-<cmd>` in repo,
    `/usr/share/paco/bin/paco-<cmd>` installed, with that path added
    to user `$PATH` at login so scripts are also callable directly.
  - Dispatcher itself ships at `/usr/bin/paco`.
  - Implementation deferred to Q37 (first subcommand) and Q39 area.
- Q37: First subcommand = `paco version` (implemented). Dispatcher
  at `bin/paco` + subcommand at `bin/paco-version` + bats tests in
  `tests/version.bats`. Validates Q36's metadata-driven dispatcher
  architecture. v1 dispatcher is minimal (~70 lines): bare `paco` /
  `paco --help` lists subcommands with summaries; `paco <cmd>` exec's
  `paco-<cmd>` from search paths; unknown returns 127. Next major
  subcommand: `paco update` (Q42).
- Q38: Bootstrap entry — `boot.sh` at repo root, curlable via GitHub
  raw URL for v1:
  `https://raw.githubusercontent.com/fernandoaleman/paco/master/boot.sh`.
  Env vars `PACO_REPO` (default `fernandoaleman/paco`) and `PACO_REF`
  (default `master`) allow testing alt forks / branches.
  - Manual install procedure (mirrors reference distro with deltas):
    1. Arch ISO + balenaEtcher to USB
    2. archinstall with btrfs + compression, LUKS encryption,
       Limine bootloader, pipewire audio, **NetworkManager** (not iwd
       "Copy ISO network config" — deviation from reference)
    3. After reboot + login: `curl -fsSL <boot.sh URL> | bash`
  - boot.sh responsibilities: clone PACO_REPO@PACO_REF to
    `~/.local/share/paco`, exec install.sh.
  - install.sh phase additions vs reference distro:
    - **Prompt for git name/email** during install (most paco users
      will be devs; convenient setup).
    - **Pre-flight checks** in preflight phase: min disk (~20 GB),
      min RAM (4 GB), UEFI present, btrfs root, internet reachable.
      Fail-fast with clear messages.
    - **End-of-install summary**: list what was installed, what's next
      (paco-theme-set, paco-webapp-install, etc.), then prompt reboot.
  - Implementation deferred to Q39 area.
- Q39: Install phase ordering confirmed (matches reference distro):
  `helpers → preflight → packaging → config → login → post-install →
  first-run`. Each phase = directory of numbered shell scripts run in
  order. Phase orchestrator at `install/<phase>/all.sh`. Master
  orchestrator at `install.sh`.
  - Implementation deferred to "post-Q50 implementation sprint."
    Decisions Q40–Q50 finalize design first.
- Q40: Hardware-specific scripts:
  - **Vendor support (4):** Framework, ASUS ROG, Dell XPS, Apple T2.
    Skipped: Microsoft Surface (user not targeting Surface devices).
  - **Generic fixes (all kept):** NVIDIA drivers + Vulkan, Bluetooth,
    Broadcom wifi (bcm43xx), specific ethernet (yt6801), wireless
    regdom, Synaptic/Tuxedo touchpad fixes, F-key behavior, ignore-
    power-button, USB autosuspend, printer.
  - Each script detects target hardware before applying — no impact on
    machines without the hardware. Bundle cost is ~30 small scripts in
    repo.
  - Implementation: `install/config/hardware/<vendor>/*.sh` per-vendor,
    plus `install/packaging/<vendor>.sh` for packages. Deferred to
    post-Q50 sprint.
- Q41: Migration system (confirmed):
  - Files: `migrations/<unix-timestamp>_<short-description>.sh`
  - State: XDG-compliant `~/.local/state/paco/migrations/`, one
    `<timestamp>.applied` marker per applied migration
  - Runner: skips any migration whose marker exists; writes marker on
    success
  - Invoked by: `paco update` automatically, `paco migrate` manually
  - Responsibilities: package add/remove, config rewrites, systemd
    unit changes, file moves/renames — anything to migrate older paco
    installs forward
- Q42: Update mechanism — `paco update` mirrors reference distro's
  full pipeline. Subcommands:
  - `paco update-confirm` / `paco update -y` to skip prompt
  - `paco snapshot create` (Q43 area)
  - `paco update-git` (git pull paco repo)
  - `paco update-perform` orchestrates: keyring → available-reset →
    system-pkgs (`pacman -Syu`) → migrate (Q41) → aur-pkgs → orphans →
    hook post-update → analyze-logs → restart
  - PTY logging wrapper via `script -qefc` writes `/tmp/paco-update.log`
  - Hyprland noidle window tag prevents screensaver during update
  - Error trap with help-link message
- Q42 AUR helper: **yay** (reference distro's choice). Deviation from
  Rust-tool preference (paru is Rust); user opted for reference-distro
  consistency over Rust pedigree. Both are equivalently capable.
- Q43: Snapshots — Limine + snapper integration (already locked in
  Q22/Q24/Q38). Q43 finalizes:
  - **btrfs is a hard requirement.** Preflight check fails fast on
    non-btrfs root with clear error message pointing user to use
    archinstall with btrfs + LUKS.
  - snapper config = reference distro's defaults
    (`default/snapper/root`): hourly cleanup, timeline enabled,
    reasonable snapshot retention counts.
  - Snapper for `/` only (NOT `/home`) — already noted in Q24.
- Q44: Security defaults (reference distro's pattern):
  - `Defaults passwd_tries=10` in sudoers (humane UX vs default 3)
  - Faillock: `deny=10 unlock_time=120` (10 wrong tries → 2-min
    lockout vs default 3 tries → 10-min lockout)
  - SDDM autologin faillock fix: prevents lockout loops on autologin
  - `paco setup-security-fingerprint` (opt-in) — fprintd-based
    fingerprint login for laptops with fingerprint sensors
  - `paco setup-security-fido2` (opt-in) — FIDO2 key auth for YubiKey
    et al.
  - UFW (Q27) default-deny incoming already locked in
- Q45: First-boot experience — adapt 11 first-run scripts from
  reference distro, drop 2, add 1 conditional:
  - **Adapted (11):** welcome (paco keybinds), wifi (NetworkManager
    helper — not iwd), firewall (UFW enable), gnome-theme (initial
    gsettings), gdk-scale (HiDPI), gtk-primary-paste (disable
    middle-click paste), dns-resolver, battery-monitor, swayosd
    (volume/brightness popups), recover-internal-monitor,
    cleanup-reboot-sudoers (remove temp install-time sudo rules).
  - **Dropped (2):** elephant (Walker daemon — we use Vicinae per Q13),
    install-voxtype.hook (reference-distro-specific tool).
  - **Added (conditional):** `vicinae.sh` if Vicinae has a daemon
    setup similar to Walker's elephant — confirm during Vicinae
    validation gates (Q13 fallback criteria).
  - Location: `install/first-run/*.sh` per Q39 phase ordering.
  - Implementation deferred to post-Q50 sprint.
- Q46: Release channels — single-branch (`master` only) for MVP. Adopt
  multi-branch (`master` + `rc` + `dev`) later when paco has external
  testers willing to run pre-release builds. `paco update-branch`
  command ships but only `master` is valid for v1.
- Q47: Version format = **SemVer** (MAJOR.MINOR.PATCH). Currently
  `0.0.1`. Bumps follow Conventional Commits mapping:
  `feat:` → minor, `fix:` → patch, `BREAKING CHANGE:` → major.
  File location: `version` at repo root (already exists per Q3),
  installed to `/usr/share/paco/version` (already in `paco-version`'s
  search path per Q37). Manual bumps for MVP; auto-bump deferred.
- Q48: Manual install docs — `docs/install-from-arch.md` written.
  7-step user-facing guide: download ISO → write USB → boot →
  connect network (iwctl on the live ISO) → archinstall with our
  required settings (btrfs + LUKS + Limine + pipewire +
  NetworkManager) → curl-bash boot.sh → first-boot → next steps.
  Follows the no-Omarchy-in-user-facing rule (Q33).
- Q49: ISO build — `archiso`-based ISO under `iso/` with standard
  `releng/`, `airootfs/`, `profiledef.sh` layout. Auto-runs paco's
  bootstrap on first boot. **Implementation deferred until post-MVP**
  — manual install (Q38, Q48) must be fully working and tested before
  ISO work begins.
- Q50: Release & distribution:
  - **Source releases:** GitHub Releases on `v0.X.Y` tags (auto-
    generates source tarball). SHA256 checksum file as release
    artifact.
  - **ISO releases (post-Q49):** attach ISO to GitHub release with
    SHA256 + GPG signature for integrity verification. Deferred until
    ISO build exists.
  - **Custom pacman repo:** `pkgs.paco.org/stable/$arch` (mirroring
    reference distro). Deferred until we have paco-specific binary
    packages to ship (e.g., a future `paco-nvim` prebuilt LazyVim
    package).

## Pending decisions

- Q21 wiring deferred to Q39 area:
  - `default/themed/bottom.toml.tpl` + `paco-restart-bottom` helper
  - `default/git/config` with delta as pager (side-by-side diff)
  - `default/zsh/conf.d/NN-mise.zsh` shell activation
  - sesh tmux keybind in default tmux config
- **Lock project name before Q39 begins.** "paco" is the working name;
  if changing, do the global rename while it's still cheap (~30 min
  across docs + memory). After Q39, rename cost grows to hours +
  migration script for existing installs.
- Post-v1: ship an `archinstall` profile so users can run
  `archinstall --profile paco` and skip the manual click-through.
  See auto-memory `project-archinstall-profile-future`.
- Switch to automated SemVer bumping via GitHub Actions workflow
  (e.g., release-please reading Conventional Commits) when manual
  cadence gets tedious — typically around ~10 releases.
- Vicinae validation gates (theming, layer-shell, stability, latency,
  shortcuts/quicklinks) to be tested when we build
  `install/packaging/launcher.sh` at Q39. If hard gates fail, swap to
  Walker.
- Source 3 missing web-app icons (Google Calendar, Gmail, Claude) when
  building `install/packaging/webapps.sh` at Q39. Try flaticon.com first.
- Create `applications/icons/ATTRIBUTION.md` with source + license for
  each bundled icon (Omarchy-derived + new sources).
