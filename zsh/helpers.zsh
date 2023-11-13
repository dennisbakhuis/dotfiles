#!/bin/zsh
#########################################
# Helper functions for zshrc            #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-12                      #
#########################################

_has() {
  return $( whence $1 >/dev/null )
}

_prepend_to_path() {
  if [ -d $1 -a -z ${path[(r)$1]} ]; then
    path=($1 $path);
  fi
}

_append_to_path() {
  if [ -d $1 -a -z ${path[(r)$1]} ]; then
    path=($1 $path);
  fi
}

