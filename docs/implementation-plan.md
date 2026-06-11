# Plan: paco Implementation Sprint — v0.1.0

## Context

paco has all 50 Phase 2 design decisions locked (see
`/Users/faleman/code/paco/CLAUDE.md` decisions log Q1–Q50). The
implementation sprint now begins. The user has a dedicated Beelink
SER8 ready for an Arch Linux install where paco will be built and
tested incrementally.

**The user wants a slow, deliberate, "one small bite at a time"
approach.** Each iteration produces a testable change on the Beelink
that can be validated before moving on. Small iterations let us bisect
breakage quickly and keep the system in a known-good state after each
step.

## Approach

- **Vertical slices, not horizontal layers.** Each iteration delivers
  one small end-to-end change (install yay → test; install zsh →
  test; set zsh as default → test). Avoid "build all helpers, then
  all preflight, then all packaging."
- **Cumulative + idempotent.** Every iteration builds on previous.
  Every script checks end-state before acting so re-running
  `install.sh` (or `paco update` once available) is always safe.
- **Dev loop transitions at iteration 5.** Iterations 1–4 use
  `curl ... | bash` to reach the Beelink. From iteration 5 onward,
  `paco update` is the dev loop: push from Mac, `paco update` on
  Beelink, validate.
- **Bats tests on Beelink land at iteration 11.** Before that, only CI
  exercises tests. Add bats tests for each script as it lands; they
  run in CI throughout, only become locally runnable on the Beelink
  at iter 11.
- **Safety net early.** SSH + sshd installed on the Beelink BEFORE
  iteration 1 begins (manual one-time step), and re-verified by
  paco itself in iteration 8. SSH is the rescue path if iterations
  14–18 (Hyprland/SDDM/Plymouth) lock out the GUI.

## Dev workflow

- All code editing on the Mac (until v0.1.0 ships).
- `tmux` split: Mac code on the left pane, SSH-into-Beelink on the
  right pane. Push from left, `paco update` (or `git pull && bash
  install.sh`) on the right, observe output.
- Starting iteration 14 (Hyprland), the user also sits at the Beelink
  with its own monitor/keyboard/mouse to watch visual results. SSH
  remains the fallback when GUI breaks.
- Local prek hooks on the Mac catch lint issues before push (per
  existing setup).
- CI on Arch container validates every push.

## Step 0: Persist this plan into the repo + memory (very first action)

Done immediately after exiting plan mode, before anything else:

1. Copy `/Users/faleman/.claude/plans/continue-paco-before-we-giggly-blanket.md`
   to `/Users/faleman/code/paco/docs/implementation-plan.md` (verbatim).
   Commit + push so it's durable in the repo's git history.
2. Save a project memory at
   `/Users/faleman/.claude/projects/-Users-faleman-code-paco/memory/project-implementation-plan.md`
   that links to both copies (the plans dir and the docs/ copy).
   Update `MEMORY.md` index.
3. Verify CI green per the existing `feedback-verify-ci-after-push` rule.

Recovery path if this Claude session is lost: a future session in
`/Users/faleman/code/paco/` will auto-load `CLAUDE.md` (which links to
the memory) → find the memory pointer → read `docs/implementation-plan.md`
and resume seamlessly.

## Pre-iteration: Beelink readiness (manual one-time setup)

1. Install Arch Linux on the Beelink following
   `/Users/faleman/code/paco/docs/install-from-arch.md` steps 1–5
   (btrfs + LUKS + Limine + pipewire + NetworkManager + user account
   with Superuser).
2. Reboot, log in.
3. Install + enable SSH:
   - `sudo pacman -S --needed openssh`
   - `sudo systemctl enable --now sshd`
   - From Mac: `ssh-copy-id user@<beelink-ip>` (verify
     password-less SSH works)
4. Confirm `Ctrl+Alt+F2` reaches a TTY (rescue path).

Once these are green, iteration 1 can begin.

---

## Iteration roadmap (21 iterations, 6 milestones)

### Milestone A — Bootstrap working (iters 1–3)

#### Iter 1 — Tiny skeleton

- **Goal:** `curl -fsSL .../boot.sh | bash` clones the repo and runs a
  10-line `install.sh` that prints a banner. Nothing else changes.
- **Files:** `boot.sh`, `install.sh`, `install/.gitkeep`.
- **Test:** `curl ... | bash` on Beelink → repo at
  `~/.local/share/paco`, banner prints, exit 0. Re-run → also exit 0.
- **Idempotency:** `boot.sh` handles existing clone (fetch + reset to
  PACO_REF). `install.sh` is a no-op skeleton.

#### Iter 2 — Helpers phase

- **Goal:** `install.sh` sources `install/helpers/all.sh`. `run_logged`,
  error trap, gum-styled output, and `paco-pkg-add` wrapper are
  available. Re-running prints log lines to `/var/log/paco-install.log`.
- **Files:** `install/helpers/{all,errors,logging,presentation,
  chroot}.sh`, `bin/paco-pkg-{add,present,missing}`, `logo.txt`.
- **Test:** `bash ~/.local/share/paco/install.sh` → log appears; force
  an error → gum error UI + log tail prints.
- **Idempotency:** `paco-pkg-add` uses `pacman -S --needed`; logs
  append; helpers are pure-functional.

#### Iter 3 — Preflight + git author prompt

- **Goal:** Preflight checks pass on the Beelink (btrfs, UEFI, RAM,
  disk, internet, Limine, vanilla Arch — per Q38 + Q43). Git
  name/email prompted once; subsequent runs skip.
- **Files:** `install/preflight/{all,begin,guard,show-env,
  hardware-mins,git-author,first-run-mode,migrations-bootstrap}.sh`.
- **Test:** Beelink → all guards pass; second run → git prompt
  skipped; `~/.local/state/paco/first-run.mode` exists.
- **Idempotency:** Each guard `command -v` / `[[ -f ]]` check;
  git-author skips when `git config user.name` is set; sudoers file
  is `tee`-overwritten.

### Milestone B — paco command center reachable (iters 4–5)

#### Iter 4 — Install paco dispatcher into PATH

- **Goal:** `/usr/bin/paco` exists system-wide. `paco --version` and
  `paco --help` work from any shell.
- **Files:** `install/post-install/{all,paco-install,pacman-config,
  finished}.sh`. Modify `install.sh` to source post-install.
- **Test:** `which paco` → `/usr/bin/paco`; `paco --version` matches
  `version` file.
- **Idempotency:** `install -Dm755` for the binary; `ln -sfn` for
  symlinks.

#### Iter 5 — `paco update` minimal (dev loop transitions here)

- **Goal:** `paco update` pulls latest paco and re-runs install.sh.
  From this point, the Beelink is updated via `paco update` instead
  of curl-bash.
- **Files:** `bin/{paco-update,paco-update-git,paco-migrate}`,
  `migrations/.gitkeep`, `tests/update.bats`.
- **Test:** Push trivial change from Mac → `paco update` on Beelink
  → pulls + re-runs install. Add a no-op migration → marker appears
  in `~/.local/state/paco/migrations/`.
- **Idempotency:** `paco-update-git` resets to `origin/PACO_REF`;
  `paco-migrate` writes marker only on success.

### Milestone C — Shell environment usable (iters 6–9)

#### Iter 6 — yay (AUR helper)

- **Goal:** `paco-pkg-aur-add` works end-to-end.
- **Files:** `install/packaging/{all,yay}.sh`,
  `bin/paco-pkg-aur-{add,accessible}`. Modify `install.sh`.
- **Test:** `paco update` → yay installed. `paco pkg-aur-add
  ttf-jetbrains-mono-nerd` works.
- **Idempotency:** `paco-pkg-present yay && return 0`.

#### Iter 7 — zsh + plugins + XDG layout (default shell unchanged yet)

- **Goal:** zsh + 3 plugins installed. `~/.zshenv` is the tiny shim;
  `~/.config/zsh/` symlinks to `default/zsh/`. zcompdump in
  `$XDG_CACHE_HOME/zsh/`.
- **Files:** `install/packaging/zsh.sh`,
  `install/config/{all,zsh-layout}.sh`,
  `default/zsh/{.zshrc,conf.d/{10-options,20-keybindings}.zsh}`.
- **Test:** From bash, `zsh -i -c 'echo $ZDOTDIR'` → set. Tab
  completion + autosuggestions + syntax highlighting visible inside
  interactive zsh.
- **Idempotency:** `~/.zshenv` heredoc-written; symlink `ln -sfn`.

#### Iter 8 — Default shell change + bundled tier-1 + tier-2 CLI tools

- **Goal:** Login shell is zsh. 15 CLI tools land (bat, bottom,
  lazydocker, lazygit, tmux, dust, eza, fd, fzf, gum, jq, ripgrep,
  tldr, zoxide, fastfetch).
- **Files:** `install/config/default-shell.sh`,
  `install/packaging/{tools-tier1,tools-tier2}.sh`,
  `default/zsh/conf.d/{30-aliases,40-zoxide}.zsh`.
- **Test:** Log out + in → `$SHELL` is `/usr/bin/zsh`; all 15 tools
  resolve via `which`.
- **Idempotency:** `chsh` only if current shell != zsh; pacman
  `--needed`.

#### Iter 9 — Fonts + fontconfig

- **Goal:** 4 font packages installed; fontconfig defaults wired.
- **Files:** `install/packaging/fonts.sh`,
  `default/fontconfig/fonts.conf`, `install/config/fontconfig.sh`.
- **Test:** `fc-match monospace` → JetBrainsMono Nerd Font.
- **Idempotency:** `fc-cache -fv` is re-runnable; conf overwritten.

### Milestone D — Prompt, terminal, editor, multiplexer (iters 10–13)

#### Iter 10 — Starship + delta + git pager

- **Goal:** Starship prompt visible. `git diff` rendered by delta.
- **Files:** `install/packaging/{tools-tier4,starship}.sh`,
  `default/starship/starship.toml` (Q11 hybrid config),
  `default/zsh/conf.d/50-starship.zsh`, `default/git/config`,
  `install/config/git-paco-defaults.sh`.
- **Test:** New shell → starship visible; ESC in vi mode → vimcmd
  symbol; `git diff` → side-by-side delta.
- **Idempotency:** Symlink `ln -sfn`; `~/.gitconfig` never touched.

#### Iter 11 — bats on Beelink (test loop closes)

- **Goal:** `bats ~/.local/share/paco/tests/` runs green on Beelink.
- **Files:** `install/packaging/dev-tools.sh`,
  `tests/{install,dispatcher}.bats`.
- **Test:** `cd ~/.local/share/paco && bats tests/` → all green.
- **Idempotency:** Pacman `--needed`; tests hermetic
  (use `$BATS_TMPDIR`).

#### Iter 12 — ghostty terminal

- **Goal:** ghostty installed + configured. Theme include is a
  no-op until iter 17.
- **Files:** `install/packaging/ghostty.sh`,
  `default/ghostty/config`, `install/config/ghostty.sh`.
- **Test:** From TTY: `ghostty &` (works once Wayland is up later);
  config file contents match.
- **Idempotency:** `ln -sfn`.

#### Iter 13 — tmux + sesh + nvim base (LazyVim)

- **Goal:** nvim opens with LazyVim, base extras (Q12: 7 extras),
  blink + git-blame + grug-far rejected (per Q12 distro filter).
  `<leader>gg` opens lazygit; `<leader>dd` opens lazydocker.
  tmux opens with sesh keybind.
- **Files:** `install/packaging/{nvim,tools-tier3}.sh`,
  `default/nvim/{init.lua,lua/config/lazy.lua,
  lua/plugins/{extras,paco-distro}.lua}`,
  `default/tmux/tmux.conf`,
  `default/zsh/conf.d/60-mise.zsh`,
  `install/config/{nvim,tmux}.sh`.
- **Test:** `nvim` → LazyVim bootstrap → quit clean. `<leader>gg`
  opens lazygit. `tmux` + sesh keybind → session picker.
- **Idempotency:** LazyVim self-bootstraps; symlinks `ln -sfn`.

### Milestone E — Wayland session boots (iters 14–17) ⚠️ riskiest

**Before starting iter 14:** verify SSH login from Mac works
reliably. This is the rescue path if any of these iterations break
the GUI.

#### Iter 14 — Hyprland packages + base config (no autostart)

- **Goal:** Manual `Hyprland` from TTY brings up a Wayland session
  with paco bindings + monitor config.
- **Files:** `install/packaging/hyprland.sh`,
  `default/hypr/{hyprland,paths,helpers,require_all,envs,looknfeel,
  input,monitors,windows,autostart,apps}.lua`,
  `default/hypr/bindings/*.lua` (paco-rebranded modular bindings
  per Q31/Q32),
  `install/{config/hyprland,login/{all,wayland-session}}.sh`,
  `default/wayland-sessions/paco.desktop`.
- **Test:** From TTY: `Hyprland` → desktop appears. `Super+Return`
  → ghostty launches. `Super+Q` closes it. Exit back to TTY.
- **Idempotency:** Pacman `--needed`; `install -D` for .desktop.

#### Iter 15 — SDDM autologin

- **Goal:** Reboot → SDDM autologin → Hyprland session.
- **Files:** `install/packaging/sddm.sh`,
  `install/login/{sddm,default-keyring}.sh`,
  `default/sddm/hyprland.lua`, `default/sddm/paco/` (QML — minimal
  first cut, real branding deferred).
- **Test:** Verify SSH works; reboot; autologin lands on Hyprland.
  If broken: `Ctrl+Alt+F2` to TTY, fix from there.
- **Idempotency:** `systemctl enable` is no-op if enabled; sddm conf
  `tee`-overwritten. Verify keyring PAM strip is idempotent.

#### Iter 16 — Waybar + Mako + Vicinae

- **Goal:** Waybar visible; mako notifies; `Super+Space` → Vicinae.
- **Vicinae validation gates apply here per Q13.** If Vicinae fails
  theming/layer-shell/stability tests, swap to Walker.
- **Files:** `install/packaging/{waybar-mako,launcher}.sh`,
  `default/waybar/{config.jsonc,style.css}`, `default/mako/config`,
  `install/config/{waybar,mako,vicinae}.sh`,
  `bin/paco-restart-{waybar,mako}`.
- **Test:** Waybar at top; `notify-send "test"` → mako popup;
  `Super+Space` → Vicinae opens; `paco restart-waybar` works.
- **Idempotency:** Restart helpers `pkill -x` then `setsid &`.

#### Iter 17 — Theme system live

- **Goal:** `paco theme set catppuccin-macchiato` applies palette
  across ghostty, waybar, mako, hyprland borders, hyprlock, nvim.
  13 themes available per Q30.
- **Files:** `themes/catppuccin-macchiato/{colors.toml,backgrounds/,
  neovim.lua,bottom.toml,icons.theme,preview.png}` (authored from
  scratch), 12 themes copied + paco-rebranded,
  `default/themed/*.tpl` (per Q29 list, scoped to bundled apps),
  `bin/paco-theme*` family (set, list, current, set-templates,
  set-gnome), `bin/paco-restart-bottom`,
  `install/config/theme-default.sh`, `tests/theme.bats`.
- **Test:** `paco theme list` → 13 entries; `paco theme set
  tokyo-night` → palette switches across apps in seconds.
- **Idempotency:** Same theme → same outputs; default-theme step
  only on fresh install.

### Milestone F — Hardening + first-run + release (iters 18–21)

#### Iter 18 — Plymouth + Limine + snapper ⚠️ have rescue USB ready

- **Goal:** Boot shows Plymouth splash + LUKS prompt; snapper takes
  daily snapshots; `paco snapshot create` works.
- **Files:** `install/packaging/boot-stack.sh`,
  `install/login/{plymouth,limine-snapper}.sh`,
  `default/{snapper/root,limine/{default,limine}.conf,plymouth/
  paco.{plymouth,script}+placeholder assets}`,
  `bin/paco-snapshot-create`.
- **Test:** Reboot → Plymouth splash; LUKS rendered graphically;
  `snapper -c root list` shows snapshots.
- **Idempotency:** HOOKS sed inserts only if absent; snapper config
  check before create.

#### Iter 19 — System services (network, bluetooth, audio, power, firewall)

- **Goal:** NetworkManager + nm-applet, bluez + blueman, pipewire,
  power-profiles-daemon, UFW all active. Waybar modules updated.
- **Files:** `install/packaging/system-services.sh`,
  `install/config/{networking,bluetooth,power,firewall}.sh`, waybar
  config updates.
- **Test:** `nmcli device`, `bluetoothctl`, `pactl info`,
  `powerprofilesctl get`, `sudo ufw status` all work; waybar shows
  matching modules.
- **Idempotency:** `systemctl enable --now` no-ops when enabled;
  UFW `default deny incoming` safe to repeat.

#### Iter 20 — Bundled apps (5 native + 12 web-apps + Chrome + file mgrs)

- **Goal:** Chrome, 1Password, Claude Code, Slack, Spotify, Obsidian
  installed. 12 web-apps launchable via `paco webapp launch <name>`.
  Zoom URL handler wired. Thunar + yazi installed.
- **Files:** `install/packaging/{native-apps,webapps,file-mgr}.sh`,
  `bin/paco-webapp*` family (install, launch, remove, remove-all),
  `applications/icons/*.png` (9 reference-derived + 3 sourced from
  flaticon per Q19), `applications/icons/ATTRIBUTION.md`,
  `install/config/zoom-url-handler.sh`.
- **Test:** All native apps resolve via `which`; `paco webapp launch
  gmail` opens in Chrome `--app=` mode; Zoom invite link opens
  client.
- **Idempotency:** `.desktop` files keyed by name; reinstall
  overwrites cleanly.

#### Iter 21 — First-run + finished + tag v0.1.0

- **Goal:** Full fresh-install acceptance test passes. Tag
  `v0.1.0`.
- **Files:** `install/first-run/{all,welcome,wifi,firewall,
  gnome-theme,gdk-scale,gtk-primary-paste,dns-resolver,
  battery-monitor,swayosd,recover-internal-monitor,
  cleanup-reboot-sudoers,vicinae}.sh`,
  `install/post-install/{finished,allow-reboot}.sh`,
  `bin/paco-first-run`,
  `default/systemd/user/paco-first-run.service`,
  `version` bumped to `0.1.0`.
- **Test (the full v0.1.0 acceptance test):**
  1. Re-archinstall the Beelink from scratch per
     `docs/install-from-arch.md`.
  2. `curl -fsSL .../boot.sh | bash` → install runs end-to-end →
     summary printed → reboot prompt.
  3. Reboot → Plymouth → LUKS → SDDM autologin → Hyprland.
  4. Welcome notification with keybinds fires; mako visible.
  5. `paco --help` shows full command tree.
  6. `paco theme set tokyo-night` works.
  7. `paco webapp launch gmail` opens Gmail in Chrome app mode.
  8. Second reboot → first-run does NOT re-run.
  9. `paco update` is a no-op when up-to-date.
  10. Tag `v0.1.0` on GitHub; attach SHA256 of source tarball per
      Q50.
- **Idempotency:** First-run gated by
  `~/.local/state/paco/first-run.mode`;
  `cleanup-reboot-sudoers.sh` removes both marker and
  `/etc/sudoers.d/first-run` on completion.

---

## Chicken-and-egg watch list

1. **Iter 1–3:** broken `boot.sh` can only be recovered via SSH +
   `cd ~/.local/share/paco && git pull`. Keep `boot.sh` tiny;
   inspect manually before pushing.
2. **Iter 5:** `paco update` updating itself. `paco-update-git` runs
   first, so a broken `install.sh` still gets the latest fix on the
   next try.
3. **Iter 11:** bats tests run in CI from iter 1 onward; only become
   locally runnable on Beelink at iter 11. Write tests during/after
   each iteration but accept they're CI-only until then.
4. **Iter 14–15:** SDDM autologin + Hyprland can lock out the GUI.
   SSH is the rescue path (validated pre-iter-1 and re-verified in
   iter 8). Test `paco.desktop` `Exec=` line carefully before push.
5. **Iter 17:** theme switching restarts services. Run
   `paco-theme-set` from a TTY first; have a known-good theme to
   revert.
6. **Iter 18:** Plymouth + mkinitcpio + Limine errors can leave the
   box unbootable. **Have a rescue USB ready** before this iteration.
7. **`/etc/sudoers.d/first-run` (iter 3):** grants password-less
   sudo during install. Iter 21's
   `cleanup-reboot-sudoers.sh` removes it. Audit step in
   `paco-first-run` removes it unconditionally on success to prevent
   leaks.
8. **Migrations marker bootstrap (iter 3):** pre-existing
   `migrations/*.sh` are marked applied on fresh installs (they
   migrate existing systems forward, not greenfield). Any migration
   added before iter 3 ships must be safe to run on a fresh install.

---

## Deferred follow-ups (post-v0.1.0)

These are Q1–Q50 deliverables intentionally deferred — they don't
block the v0.1.0 acceptance test and become normal `paco update`
increments after.

- **Q33 branding + Q34 paco.ttf** — logo design, custom font
  generation. v0.1.0 ships with placeholder branding.
- **Q40 hardware-vendor scripts** — Framework, ASUS ROG, Dell XPS,
  Apple T2. Detection-gated, no-ops on the Beelink (Intel mini-PC).
- **Q42 polished `paco update`** — PTY logging wrapper, hyprland
  noidle tag, analyze-logs, hooks. Iter 5's minimal version is
  enough for v0.1.0.
- **Q44 opt-in security helpers** — `paco-setup-security-{fingerprint,
  fido2}`. Skippable on Beelink (no sensor / no YubiKey).
- **Q46 release channels** — `rc` and `dev` branches. v0.1.0 ships
  on master only.
- **Q49 ISO build** — explicitly deferred until manual install is
  validated.
- **Q50 custom pacman repo** — deferred until there's a paco-built
  binary package to ship.

---

## Critical files (highest-risk single files)

- `/Users/faleman/code/paco/boot.sh` (iter 1) — the curl-bash entry
  point. Bad push breaks the bootstrap mechanism.
- `/Users/faleman/code/paco/install.sh` (iter 1, extended through
  iter 21) — master orchestrator. Sources every phase's `all.sh`.
- `/Users/faleman/code/paco/install/helpers/all.sh` (iter 2) —
  sourced by every later phase. A bug here cascades.
- `/Users/faleman/code/paco/bin/paco-update` (iter 5) — flips dev
  loop. Bug here forces curl-bash recovery.
- `/Users/faleman/code/paco/install/login/sddm.sh` (iter 15) — the
  riskiest single file. Typo can lock out GUI.
- `/Users/faleman/code/paco/install/login/limine-snapper.sh` (iter 18)
  — bad mkinitcpio HOOKS can leave box unbootable.

## Q1–Q50 coverage map

Every locked decision is delivered by at least one iteration. Quick
spot-check:
Q9→7,8 · Q10→12 · Q11→10 · Q12→13 · Q13→16 · Q14→16 · Q15→16 ·
Q16→20 · Q17→20 · Q18→20 · Q19→20 · Q20→20 · Q21→8,10,13 ·
Q22→14,15 · Q23→18 · Q24→18 · Q25→19 · Q26→19 · Q27→19 · Q28→19 ·
Q29→17 · Q30→17 · Q31→14 · Q32→14 · Q35→9 · Q36→already shipped ·
Q37→already shipped · Q38→1,3,21 · Q39→1 onward · Q41→5 · Q42→5
(minimal) · Q43→3 · Q44→3,19 · Q45→21 · Q46→implicit · Q47→21 ·
Q48→already exists · Q50→21.

Deferred follow-ups (Q33, Q34, Q40, Q42 polish, Q44 opt-ins, Q46
channels, Q49, Q50 pacman repo) listed above.

## Verification (end-to-end v0.1.0 test)

Full acceptance test is iter 21's "Test" section. Summary: fresh
Arch reinstall → curl-bash → install completes → reboot →
Plymouth+LUKS+SDDM+Hyprland boot to desktop → welcome notification
→ all bundled apps + theme switching + web-apps work → second
reboot doesn't re-run first-run → `paco update` no-ops when current.
Then tag `v0.1.0` with SHA256.

The plan succeeds when this acceptance test passes start-to-finish
without manual intervention.
