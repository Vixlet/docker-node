#!/bin/bash

################################
# Run tests for NODE_VERSION_X #
################################

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )"
source ./versions.env
source ./resolve_envs.sh
for TEST in ../test/*/test.sh; do
  "${TEST}"
  echo ""
done