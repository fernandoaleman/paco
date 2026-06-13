# vim: set ft=zsh:
# Vi mode (Q9: paco default)
bindkey -v
KEYTIMEOUT=1 # reduce mode-switch lag

# Up/down arrows search history by current prefix
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
