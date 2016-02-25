#!/bin/bash

##################################################################
# Make Dockerfiles for each NODE_VERSION_X in NODE_VERSION_X_ALL #
##################################################################

set -e
source ./tools/versions.env
if [[ $# -ge 1 ]]; then
  NODE_VERSION_X="$1" ./tools/make.sh
else
  for cur in "${NODE_VERSION_X_ALL[@]}"; do
    NODE_VERSION_X="$cur" ./tools/make.sh
  done
fi