# tests/

paco uses [bats-core](https://github.com/bats-core/bats-core) for testing.

## Layout

- `tests/*.bats` — one file per top-level subcommand (e.g.,
  `version.bats`, `theme.bats`, `update.bats`).
- `tests/helpers/` — vendored helper libraries (added when first needed):
  - [`bats-support`](https://github.com/bats-core/bats-support)
  - [`bats-assert`](https://github.com/bats-core/bats-assert)
  - [`bats-file`](https://github.com/bats-core/bats-file)

## Running

```bash
# All tests
bats tests/

# A single file
bats tests/version.bats

# Parallel
bats --jobs 4 tests/
```

Install bats from the official Arch repos: `sudo pacman -S bats`.
