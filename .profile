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

# I'm on WSL2 and need Windows applications sometimes
ln -fs "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe" "$HOME/bin/powershell.exe"
ln -fs "/mnt/c/Windows/explorer.exe" "$HOME/bin/explorer.exe"
ln -fs "/mnt/c/Windows/System32/cmd.exe" "$HOME/bin/cmd.exe"
ln -fs "/mnt/c/Program Files/Docker/Docker/resources/docker.exe" "$HOME/bin/docker.exe"
ln -fs "/mnt/c/Program Files/Docker/Docker/resources/bin/docker-credential-desktop.exe" "$HOME/bin/docker-credential-desktop.exe"

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

export GITHUB_TOKEN=`pass GitHub`
eval "$(gh completion -s bash)"
