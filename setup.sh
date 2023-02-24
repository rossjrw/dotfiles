#/usr/bin/env bash

for confdir in $(find -mindepth 1 -type d -not -iwholename '*.git*'); do
  confdir=${confdir/\/home/$HOME}
  confdir=${confdir:1}
  echo "Making directory $confdir"
  mkdir -p "$confdir"
done

for conffile in $(find -mindepth 2 -type f -not -iwholename '*.git/*'); do
  conffile=${conffile:1}
  confdest=${conffile/\/home\//$HOME\/}
  conffile="$(pwd)/${conffile:1}"
  echo "Linking $conffile to $confdest"
  ln -s "$conffile" "$confdest"
done
