#!/bin/bash
for file in $(find ${PWD}/manifests/*); do sort -o $file{,}; done
