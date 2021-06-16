#!/bin/bash
echo '   ____ ___    __   ____   ____   _  __'
echo '  / __// _ |  / /  / __ \ / __ \ / |/ /'
echo ' _\ \ / __ | / /__/ /_/ // /_/ //    / '
echo '/___//_/ |_|/____/\____/ \____//_/|_/  '
echo '             cowboy.dev                '

# Start services quietly and in the background
service neo4j start >/dev/null 2>&1 &

# Enter with the default shell
exec "$SHELL"
