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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

[ -s /usr/share/doc/fzf/examples/key-bindings.sh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh

# Tint iTerm2 pane background and tab bar based on git worktree gemstone name
# Format per entry: "bg_hex tab_r tab_g tab_b"
function _worktree_bg() {
  typeset -A gem_colors=(
    RUBY      '#0a0000 160 0 0'
    EMERALD   '#000a00 0 140 0'
    SAPPHIRE  '#00000a 0 0 160'
    AMETHYST  '#060010 90 0 150'
    TOPAZ     '#0a0700 150 110 0'
  )

  if [[ "$PWD" =~ '.*/\.worktrees/([^/]+)' ]]; then
    local parts=(${(z)gem_colors[${match[1]}]})
    if [[ ${#parts} -eq 4 ]]; then
      printf '\033]11;%s\007' "${parts[1]}"
      printf '\033]6;1;bg;red;brightness;%s\a'   "${parts[2]}"
      printf '\033]6;1;bg;green;brightness;%s\a' "${parts[3]}"
      printf '\033]6;1;bg;blue;brightness;%s\a'  "${parts[4]}"
      return
    fi
  fi

  printf '\033]11;#000000\007'
  printf '\033]6;1;bg;*;default\a'
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _worktree_bg
_worktree_bg

# bun completions
[ -s "/Users/ross/.bun/_bun" ] && source "/Users/ross/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
