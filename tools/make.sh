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
sed 's/\${NODE_VERSION}/'"${NODE_VERSION}"'/g' ./Dockerfile > ./${NODE_VERSION_PATH}/Dockerfile
echo -e "make: ls $(pwd):\n$(ls -la)"
echo -e "make: ls $NODE_VERSION_PATH:\n$(ls -la ./${NODE_VERSION_PATH}/)"