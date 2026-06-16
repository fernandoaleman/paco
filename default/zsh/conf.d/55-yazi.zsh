# yazi shell integration — `y` wrapper that lets yazi change the
# parent shell's CWD on exit.
#
# Without this, `yazi` runs as a subprocess and exiting drops you back
# where you started, even if you navigated deeply inside yazi. With
# `y`, exiting yazi at /some/deep/path actually `cd`s the shell there.
# Canonical pattern from the yazi docs.

function y() {
  local tmp
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="${tmp}"
  local cwd
  cwd="$(cat -- "${tmp}")"
  if [[ -n ${cwd} && ${cwd} != "${PWD}" ]]; then
    builtin cd -- "${cwd}"
  fi
  rm -f -- "${tmp}"
}
