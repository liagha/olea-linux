setopt auto_cd
setopt auto_list
setopt auto_menu
setopt hist_ignore_all_dups
setopt hist_lex_words
setopt notify

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

bindkey '^?' backward-delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3~' delete-char

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export EDITOR=nvim
export VISUAL=nvim

PROMPT='%F{green}%n@%m%f %F{blue}%~%f %# '