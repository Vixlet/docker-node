#!/bin/bash

###########################################################
# Run tests for each NODE_VERSION_X in NODE_VERSION_X_ALL #
###########################################################

set -e
source ./tools/versions.env
if [[ $# -ge 1 ]]; then
  NODE_VERSION_X="$1" ./tools/pre_push.sh
else
  for curr in "${NODE_VERSION_X_ALL[@]}"; do
    NODE_VERSION_X="$curr" ./tools/pre_push.sh
  done
fi