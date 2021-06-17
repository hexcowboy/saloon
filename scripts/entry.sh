#!/bin/bash
echo -en '\e[34m'
echo '   ____ ___    __   ____   ____   _  __'
echo '  / __// _ |  / /  / __ \ / __ \ / |/ /'
echo ' _\ \ / __ | / /__/ /_/ // /_/ //    / '
echo '/___//_/ |_|/____/\____/ \____//_/|_/  '
echo '             cowboy.dev                '
echo -e '\e[0m'

# Start services quietly and in the background
service neo4j start >/dev/null 2>&1 &

# If running interactively (with -it)
if [ -t 0 ] ; then
  # If no arguments are passed in docker
  if [ $# -eq 0 ] ; then
    exec "$SHELL"
  # If there are arguments, run them as the command
  else
    "$@"
  fi
# If not running interactively, ask to do so and exit
else
  echo ""
  echo "saloon requires the -it argument:"
  echo -e "$ \e[32mdocker run -it saloon\e[0m"
  exit 1
fi
