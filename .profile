# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
      . "$HOME/.bashrc"
    fi
fi

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# show the time in the prompt
export PS1="\t $PS1"

# keep pipenv .venv dir in the project dir
export PIPENV_VENV_IN_PROJECT=true

vmd() {
  /mnt/c/Program\ Files\ \(x86\)/University\ of\ Illinois/VMD/vmd.exe $*
}

export PATH="/mnt/c/Windows/System32/WindowsPowerShell/v1.0:$PATH"
export PATH="/mnt/c/WINDOWS:$PATH"

export APPDATA="/mnt/c/Users/Ross/AppData/Roaming"

# don't show crap in tree
alias tree="tree -a -I 'node_modules|\.git|\.venv|\.pytest_cache' -h --du"

# nvim > vim > emacs
export PATH="$HOME/nvim-linux64/bin:$PATH"
export EDITOR="nvim"
export VISUAL="$EDITOR"

# gpg doesn't like me if I don't do this
export GPG_TTY=$(tty)

# open git conflicts in editor
alias conflicts='$EDITOR -p `git diff --name-only | uniq`'

# set display for x servers
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
