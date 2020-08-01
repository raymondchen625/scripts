#!/bin/bash
# A function toggleSpinner which starts a process to print spinning characters on the console to indicate work in progress.
# Takes one parameter which will be run as a shell command and append the output after the spinning character.
function toggleSpinner {
  if [ -z "$spinner" ]; then
    chars="/-\|"
    while :; do
      for (( i=0; i<${#chars}; i++ )); do
        sleep 1
        echo -en "${chars:$i:1}$($1)" "\r"
      done
    done&
    spinner=$!
    trap "kill $spinner 2> /dev/null" EXIT
  else
    kill $spinner
    wait $spinner 2>/dev/null
    spinner=
  fi
}
