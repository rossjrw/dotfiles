#!/usr/bin/env bash

set -e

if [ "$1" = "--dry-run" ]; then
  DRY_RUN=1
  echo "Dry run"
fi

find . -mindepth 1 -type d \( ! -iwholename '*manual-install*' ! -iwholename '*.git*' \) -print0 |
  while IFS= read -r -d '' confdir; do
    confdir=${confdir/\/home/$HOME}
    confdir=${confdir:1}
    echo "Making directory $confdir"
    if [ -z "$DRY_RUN" ]; then
      mkdir -p "$confdir"
    fi
  done

find . -mindepth 2 -type f \( ! -iwholename '*manual-install*' ! -iwholename '*.git/*' \) -print0 |
  while IFS= read -r -d '' conffile; do
    conffile=${conffile:1}
    confdest=${conffile/\/home\//$HOME\/}
    conffile="$(pwd)/${conffile:1}"
    echo "Linking $conffile to $confdest"
    if [ -z "$DRY_RUN" ]; then
      ln -s "$conffile" "$confdest"
    fi
  done
