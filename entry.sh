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

# If no arguments are passed in docker
if [ $# -eq 0 ] ; then
  # If running interactively (with -it)
  if [ -t 0 ] ; then
    exec "$SHELL"
  else
    echo ""
    echo "try running interactively:"
    echo -e "$ \e[32mdocker run -it saloon\e[0m"
    echo ""
    echo "or run a particular command:"
    echo -e "$ \e[32mdocker run saloon gobuster -h\e[0m"
    exit 1
  fi
else
  # If a program is supplied
  exec "$@"
fi
