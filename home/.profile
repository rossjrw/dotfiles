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

# show the time in the prompt
export PS1="\t $PS1"

# keep pipenv .venv dir in the project dir
export PIPENV_VENV_IN_PROJECT=true

# I'm on WSL2 and need Windows applications sometimes
ln -fs "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe" "$HOME/bin/powershell.exe"
ln -fs "/mnt/c/Windows/explorer.exe" "$HOME/bin/explorer.exe"
ln -fs "/mnt/c/Windows/System32/cmd.exe" "$HOME/bin/cmd.exe"
ln -fs "/mnt/c/Windows/System32/clip.exe" "$HOME/bin/clip.exe"
ln -fs "/mnt/c/Program Files/Docker/Docker/resources/docker.exe" "$HOME/bin/docker.exe"
ln -fs "/mnt/c/Program Files/Docker/Docker/resources/bin/docker-credential-desktop.exe" "$HOME/bin/docker-credential-desktop.exe"
ln -fs "/mnt/c/Users/Ross/AppData/Local/Programs/Microsoft VS Code/code.exe" "$HOME/bin/code"

export APPDATA="/mnt/c/Users/Ross/AppData/Roaming"

# don't show crap in tree
alias tree="tree -a -I 'node_modules|\.git|\.venv|\.pytest_cache|\.mypy_cache|__pycache__|_site' -h --du"

# nvim > vim > emacs
export PATH="$HOME/nvim-linux64/bin:$PATH"
export EDITOR="nvim"
export VISUAL="$EDITOR"

# gpg doesn't like me if I don't do this
export GPG_TTY=$(tty)

# open git conflicts in editor
alias conflicts='$EDITOR -p `git diff --name-only | uniq`'

# expose my github 2FA auth to an env var (this is probably secure)
export GITHUB_TOKEN=`pass GitHub`
# eval "$(gh completion -s bash)"

# add poetry (python package management) to my path
export PATH="$HOME/.poetry/bin:$PATH"

# add pyenv (python version management) to my path
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

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

# quick and dirty ruby setup
# https://stackoverflow.com/a/50361633/4958427
export GEM_HOME="$HOME/.ruby/"
export PATH="$PATH:$HOME/.ruby/bin"
. "$HOME/.cargo/env"
