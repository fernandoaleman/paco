# Default editors. yazi's built-in `open` command falls back to `vi`
# when EDITOR is unset, and paco ships nvim (not vi), so opening any
# text file in yazi exits 127 without these exports.
#
# Pattern adapted from the user's ~/.config/zsh/conf.d/10-editor.zsh:
# VISUAL is the canonical "interactive editor" var, EDITOR is the
# fallback. Both pointed at nvim on a paco box; the vim default is
# defensive for systems without nvim (paco always has it).
VISUAL="vim"
if command -v nvim &> /dev/null; then
  VISUAL="nvim"
fi
export VISUAL
export EDITOR="${VISUAL}"
