# vim: set ft=zsh:
#
# ~/.config/zsh/.zshrc — interactive shell configuration (shipped by paco).
# Sources conf.d/*.zsh in numbered order.

# ── Function / completion paths ─────────────────────────────────────
fpath=(
  ${ZDOTDIR}/functions
  ${ZDOTDIR}/completion
  /usr/share/zsh/site-functions
  $fpath
)

# ── Source custom functions ─────────────────────────────────────────
for _fn in ${ZDOTDIR}/functions/*(N-.); do
  source "$_fn"
done
unset _fn

# ── Completion init (24-hour cache) ────────────────────────────────
autoload -Uz compinit
_zcompdump="${XDG_CACHE_HOME}/zsh/zcompdump"
[[ -d ${_zcompdump:h} ]] || mkdir -p "${_zcompdump:h}"
if [[ -n "${_zcompdump}"(#qN.mh+24) ]]; then
  compinit -d "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump

# ── Source numbered config modules ──────────────────────────────────
for _cfg in ${ZDOTDIR}/conf.d/*.zsh(N); do
  source "$_cfg"
done
unset _cfg
