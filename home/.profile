# if running bash
if [[ -n "$BASH_VERSION" ]]; then
    # include .bashrc if it exists
    if [[ -f "$HOME/.bashrc" ]]; then
      . "$HOME/.bashrc"
    fi
fi

if [[ -d "$HOME/bin" ]] ; then
    PATH="$HOME/bin:$PATH"
fi

if [[ -d "$HOME/.local/bin" ]] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d /opt/homebrew/bin ]; then
	eval $(/opt/homebrew/bin/brew shellenv)
	PATH="/opt/homebrew/bin:$PATH"
fi

# show the time in the prompt
export PS1="\t $PS1"

# don't show crap in tree
alias tree="tree -a -I 'node_modules|\.git|\.venv|\.pytest_cache|\.mypy_cache|__pycache__|_site' -h --du"

export EDITOR="nvim"
export VISUAL="$EDITOR"

# gpg doesn't like me if I don't do this
export GPG_TTY=$(tty)

# open git conflicts in editor
alias conflicts='$EDITOR -p `git diff --name-only | uniq`'

# expose my github 2FA auth to an env var (this is probably secure)
export GITHUB_TOKEN=`pass GitHub`

# expose the IP of vcXsrv, for gui applications
export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
# this seems to be important for vcXsrv
export LIBGL_ALWAYS_INDIRECT=1
# make GUI apps run through X410 match my windows scaling
export GDK_DPI_SCALE=1.25

# set ripgrep config
export RIPGREP_CONFIG_PATH="$HOME/.ripgrep"

# quickly shutdown wsl in a way that feels natural
alias :qa="wsl.exe --shutdown"

[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

[ -f "$HOME/.ssh/id_rsa" ] && command -v keychain && eval $(keychain --eval "$HOME/.ssh/id_rsa")
