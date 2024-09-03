# Enable git info to show in command prompt
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '[%b] '
precmd() { 
  vcs_info 
}

# Enable prompt substitution
setopt PROMPT_SUBST

# Custom prompt
NEWLINE=$'\n'
CODE_ICON=$'\ue795'
PROMPT_SEPARATOR="%F{0}${CODE_ICON} ---------------------------------------%f${NEWLINE}"
PROMPT_INFO="%F{blue}%~%f %F{red}${vcs_info_msg_0_}%f${NEWLINE}"
PROMPT_INDICATOR="%F{red}❯%F{yellow}❯%F{green}❯ "
PROMPT=$'${PROMPT_SEPARATOR}${PROMPT_INFO}${PROMPT_INDICATOR}'

# Add homebrew apps to the path
# NOTE: this is also in .zprofile not sure if can cause duplication problems
if [ "$(arch)" = "arm64" ]; then
  eval $(/opt/homebrew/bin/brew shellenv);
else
  eval $(/usr/local/bin/brew shellenv);
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
# zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git-prompt
# zinit snippet OMZP::sudo
# zinit snippet OMZP::archlinux
# zinit snippet OMZP::aws
# zinit snippet OMZP::kubectl
# zinit snippet OMZP::kubectx
# zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

# zinit optimization. caches commands.
zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey '^p' history-search-backward 
bindkey '^n' history-search-forward 

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
# eval "$(pyenv virtualenv-init -)" # This is super slow

# Set neovim as the default editor
export EDITOR=nvim
export VISUAL="$EDITOR"

# PATH updates

# sdd user local (for poetry)
export PATH="$PATH:$HOME/.local/bin"

# Add Visual Studio Code (code)
export CODE_HOME="/Applications/Visual Studio Code.app"
export PATH="$PATH:$CODE_HOME/Contents/Resources/app/bin"

# Add these last
# add volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# add pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# add poetry
export POETRY_HOME="$HOME/.poetry"
export PATH="$POETRY_HOME/bin:$PATH"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Aliases

# unix
alias ls='ls --color'
alias ll='ls -lahFG'
alias la='ls -A'
alias l='ls -CF'
alias vim='nvim'
alias c='clear'

alias path='echo $PATH | tr ":" "\n" | nl'

alias lx='exa -lagh --git --sort type'

alias show-files='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hide-files='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# git 
alias g='git'
alias gcl='git clone'
alias gb='git branch'
alias gba='git branch --all --verbose'
alias gcm='git commit --message'
alias gco='git checkout'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gg='git grep'
alias ggi='git grep --ignore-case'
alias gl='git log --date-order --pretty'
alias gls='git log --date-order --stat --pretty'
alias gld='git log --date-order -c --pretty'
alias gm='git merge'
alias gp='git push'
alias gpu='git pull'
alias gr='git remote'
alias grv='git remote -vv'
alias gra='git remote add'
alias gs='git status'
alias gst='git stash'
alias gsp='git stash pop'
alias ga='git add'
alias gaa='git add .'
gd() {
  git diff $1^!
}