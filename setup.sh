#!/usr/bin/env bash

set -e

if [ "$1" = "--just-do-it" ]; then
  JUST_DO_IT=1
fi

confirm_prompt() {
  read -r -p "Run \`$1\` ? [y/N/q] " response </dev/tty
  case "$response" in
  [yY][eE][sS] | [yY])
    true
    ;;
  [qQ])
    echo 1>&2 "Aborted"
    exit 1
    ;;
  *)
    false
    ;;
  esac
}

find . -mindepth 1 -type d \( ! -iwholename '*manual-install*' ! -iwholename '*.git*' \) -print0 |
  while IFS= read -r -d '' confdir; do
    echo

    confdir=${confdir/\/home/$HOME}
    confdir=${confdir:1}

    echo 1>&2 "Making directory $confdir..."

    if [ -e "$confdir" ]; then
      if [ -d "$confdir" ]; then
        echo 1>&2 "Directory $confdir already exists"
        continue
      fi

      echo 1>&2 "Directory $confdir already exists, but is not a directory. Skipping"
      continue
    fi

    if [ -n "$JUST_DO_IT" ] || confirm_prompt "mkdir -p $confdir"; then
      mkdir -p "$confdir"
      echo 1>&2 "Made directory $confdir..."
    fi
  done

echo

find . -mindepth 2 -type f \( ! -iwholename '*manual-install*' ! -iwholename '*.git/*' \) -print0 |
  while IFS= read -r -d '' conffile; do
    echo

    conffile=${conffile:1}
    confdest=${conffile/\/home\//$HOME\/}
    conffile="$(pwd)/${conffile:1}"

    echo 1>&2 "Linking $conffile to $confdest..."

    if [ ! -d "$(dirname "$confdest")" ]; then
      echo 1>&2 "Destination $(dirname "$confdest") is not a directory; skipping"
      continue
    fi

    if [ -e "$confdest" ]; then
      if [ ! -L "$confdest" ]; then
        if [ -f "$confdest" ]; then
          echo 1>&2 "There is already a file at $confdest which blocks symlink creation; skipping"
          continue
        fi
        if [ -d "$confdest" ]; then
          echo 1>&2 "There is a directory at $confdest which blocks symlink creation; skipping"
          continue
        fi

        echo 1>&2 "Something already exists at $confdest; skipping"
        continue
      fi

      if [ -L "$confdest" ]; then
        current_symlink_dest=$(readlink "$confdest")
        if [ "$current_symlink_dest" = "$conffile" ]; then
          echo 1>&2 "Already linked"
          continue
        else
          echo 1>&2 "A different symlink already exists at $confdest; skipping"
          continue
        fi
      fi

      echo 1>&2 "Something already exists at $confdest and also there is a bug in this script; aborting"
      exit 1
    fi

    if [ -n "$JUST_DO_IT" ] || confirm_prompt "ln -s $conffile $confdest"; then
      ln -s "$conffile" "$confdest"
      echo 1>&2 "Linked $conffile to $confdest"
    fi
  done
