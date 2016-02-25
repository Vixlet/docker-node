#!/bin/bash

###########################################################
# Run tests for each NODE_VERSION_X in NODE_VERSION_X_ALL #
###########################################################

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )"
source ./versions.env
if [[ $# -ge 1 ]]; then
  NODE_VERSION_X="$1" ./pre_push.sh
else
  for curr in "${NODE_VERSION_X_ALL[@]}"; do
    NODE_VERSION_X="$curr" ./pre_push.sh
  done
fi