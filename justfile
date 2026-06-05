# paco — development task runner.
# Run `just` with no arguments to see all recipes.
#
# paco itself targets Arch Linux; this justfile supports both macOS and
# Arch Linux for development/linting/testing (editing paco's source).
# Building or running the actual paco install requires Arch.

# Show available recipes
default:
    @just --list

# Install local developer dependencies (auto-detects macOS or Arch Linux)
install:
    #!/usr/bin/env bash
    set -euo pipefail
    case "$(uname -s)" in
        Darwin)
            just install-mac
            ;;
        Linux)
            if command -v pacman >/dev/null 2>&1; then
                just install-arch
            else
                echo "error: unsupported Linux distro (only Arch is supported)" >&2
                echo "       (no pacman found on PATH)" >&2
                exit 1
            fi
            ;;
        *)
            echo "error: unsupported OS: $(uname -s)" >&2
            exit 1
            ;;
    esac

# Install dev dependencies on macOS (via Homebrew)
install-mac:
    brew install bats-core pipx
    pipx ensurepath
    pipx install prek

# Install dev dependencies on Arch Linux
install-arch:
    sudo pacman -S --needed --noconfirm git python python-pipx bats
    pipx ensurepath
    pipx install prek

# Run all linters via prek
lint:
    prek run --all-files

# Run the bats test suite
test:
    #!/usr/bin/env bash
    if compgen -G "tests/*.bats" > /dev/null; then
        bats tests/
    else
        echo "No .bats files yet — skipping"
    fi

# Install prek hooks into .git/hooks (pre-commit + commit-msg)
hooks:
    prek install
    prek install --hook-type commit-msg

# Clean prek's hook environment cache
clean:
    prek clean
