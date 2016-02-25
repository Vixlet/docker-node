#!/bin/bash

##########################################################
# Builds an image from the Dockerfile for NODE_VERSION_X #
##########################################################

set -e
echo -e "\nbuild.sh...\n"
source ./tools/versions.env
source ./tools/resolve_envs.sh
echo "pwd: $(pwd)"
echo -e "make: ls $(pwd):\n$(ls -la)"
echo -e "make: ls $NODE_VERSION_PATH:\n$(ls -la ./${NODE_VERSION_PATH}/)"
docker build --no-cache -f ./${NODE_VERSION_PATH}/Dockerfile -t "vixlet/node:${IMAGE_NODE_VERSION}" ./${NODE_VERSION_PATH}