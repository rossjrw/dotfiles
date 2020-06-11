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

export PS1="\t $PS1"
export PATH="$HOME/nvim-linux64/bin:$PATH"
export PIPENV_VENV_IN_PROJECT=true

vmd() {
  /mnt/c/Program\ Files\ \(x86\)/University\ of\ Illinois/VMD/vmd.exe $*
}

export PATH="/mnt/c/Windows/System32/WindowsPowerShell/v1.0:$PATH"
export PATH="/mnt/c/WINDOWS:$PATH"

export APPDATA="/mnt/c/Users/Ross/AppData/Roaming"

alias tree="tree -a -I 'node_modules|\.git'"

export EDITOR="nvim"
export VISUAL="$EDITOR"
