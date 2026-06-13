# vim: set ft=zsh:
# eza-based directory listing (skip `cat→bat`, `top→btm`, `du→dust` —
# those break scripts and muscle memory).
alias ls='eza --git --icons'
alias ll='eza -lah --git --icons'
alias la='eza -la --git --icons'
alias tree='eza --tree'
