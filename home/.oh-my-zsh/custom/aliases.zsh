alias gcfd="git clean -fd"
alias gcB="git checkout -B"

unalias gst
function gst() {
  remote="origin"

  default_branch=$(git ls-remote --quiet --symref "$remote" HEAD | head -1 | awk '{print $2}')
  default_branch="${default_branch#refs\/heads\/}"
  remote_default_branch="$remote/$default_branch"

  echo "Default branch is $default_branch"

  git fetch "$remote" "$default_branch" 2>/dev/null

  default_branch_ahead=$(git rev-list --count "$remote_default_branch".."$default_branch" 2>/dev/null)
  default_branch_behind=$(git rev-list --count "$default_branch".."$remote_default_branch" 2>/dev/null)

  if [ "$default_branch_ahead" -gt 0 ] || [ "$default_branch_behind" -gt 0 ]; then
    if [ "$default_branch_ahead" -gt 0 ] && [ "$default_branch_behind" -gt 0 ]; then
      echo "Local branch $default_branch is $default_branch_ahead commits ahead of and $default_branch_behind commits behind '$remote_default_branch'"
      printf "\tuse \"git checkout %s\" then one of the following:\n" "$default_branch"
      printf "\t\tuse \"git pull --rebase\" to update local branch with remote changes\n"
      printf "\t\tuse \"git push --force-with-lease\" to destroy remote changes\n"
    elif [ "$default_branch_ahead" -gt 0 ]; then
      echo "Local branch $default_branch is $default_branch_ahead commits ahead of '$remote_default_branch'"
    fi
    if [ "$default_branch_behind" -gt 0 ]; then
      echo "Local branch $default_branch is $default_branch_behind commits behind '$remote_default_branch'"
      printf "\tuse \"git fetch %s %s:%s\" to update it\n" "$remote" "$default_branch" "$default_branch"
    fi
  else
    echo "Local branch $default_branch is up to date with '$remote_default_branch'"
  fi

  echo ""

  if [ "$(git branch --show-current)" != "$default_branch" ]; then
    echo "On branch $(git branch --show-current)"

    this_branch_ahead=$(git rev-list --count "$default_branch"..HEAD 2>/dev/null)
    this_branch_behind=$(git rev-list --count HEAD.."$default_branch" 2>/dev/null)

    if [ "$this_branch_ahead" -gt 0 ] || [ "$this_branch_behind" -gt 0 ]; then
      if [ "$this_branch_ahead" -gt 0 ]; then
        echo "This branch is $this_branch_ahead commits ahead of '$default_branch'"
      fi
      if [ "$this_branch_behind" -gt 0 ]; then
        echo "This branch is $this_branch_behind commits behind '$default_branch'"
        printf "\tuse \"git rebase %s\" to update it\n" "$default_branch"
        if [ "$default_branch_behind" -gt 0 ]; then
          printf "\t(but you should update %s first)" "$default_branch"
        fi
      fi
    else
      echo "This branch is up to date with '$default_branch'"
    fi

    echo ""
  fi

  git status
}
