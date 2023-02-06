if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH=$HOME/.oh-my-zsh

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"
# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
HIST_STAMPS="dd/mm/yyyy"

# Options
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt inc_append_history
setopt share_history

# Updates
zstyle ':omz:update' mode auto
zstyle ':omg:update' frequency 2

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf)


# Plugins configurations

# Personal keybindings for zsh-autosuggestion
bindkey "^[q" autosuggest-accept
bindkey "^[c" autosuggest-clear

# Removing underlines with zsh-syntax-highlighting
. $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none


source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases
alias cat='bat'
alias ls='exa'
alias la='exa --icons -alh'
