#!/bin/bash

################################
# Run tests for NODE_VERSION_X #
################################

set -e
echo -e "\ntest.sh...\n"
source ./tools/versions.env
source ./tools/resolve_envs.sh
for TEST in ./test/*/test.sh; do
  ${TEST}
  echo ""
done