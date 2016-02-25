#!/bin/bash

#######################################
# Makes Dockerfile for NODE_VERSION_X #
#######################################

set -e
echo "make: pwd: $(pwd)"
source ./tools/versions.env
source ./tools/resolve_envs.sh
rm -rf ./${NODE_VERSION_PATH}
mkdir -p ./${NODE_VERSION_PATH}
cp -r ./context/ ./${NODE_VERSION_PATH}/
echo "make: ls of pwd: $(ls -la)"
echo "make: ls of NODE_VERSION_PATH: $(ls -la ./${NODE_VERSION_PATH}/)"
sed 's/\${NODE_VERSION}/'"${NODE_VERSION}"'/g' ./Dockerfile > ./${NODE_VERSION_PATH}/Dockerfile