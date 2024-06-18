# User configuration
source "$HOME/.profile"

# Enable Powerlevel10k instant prompt.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"
HISTSIZE=10000
SAVEHIST=12000
HISTFILE="$HOME/.cache/zsh/history"
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
plugins=(
  git
  gpg-agent
  colored-man-pages
)
source $ZSH/oh-my-zsh.sh

# Don't autocorrect because it's wrong most of the time
unsetopt correct_all

unsetopt share_history

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fpath+=~/.zfunc

source <(fzf --zsh)
