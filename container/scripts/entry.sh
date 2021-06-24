#!/bin/bash

if [ $# -eq 0 ] ; then
  echo -en '\e[34m'
  echo '   ____ ___    __   ____   ____   _  __'
  echo '  / __// _ |  / /  / __ \ / __ \ / |/ /'
  echo ' _\ \ / __ | / /__/ /_/ // /_/ //    / '
  echo '/___//_/ |_|/____/\____/ \____//_/|_/  '
  echo '             cowboy.dev                '
  echo -e '\e[0m'

  # Start services quietly and in the background
  service neo4j start >/dev/null 2>&1 &

  exec "$SHELL"
else
  # If there are arguments, run them as the command
  "$@"
fi
