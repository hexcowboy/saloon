#!/bin/bash
echo "Starting Saloon"

# Start services quietly
service neo4j start >/dev/null 2>&1 &

/bin/zsh
