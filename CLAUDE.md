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
