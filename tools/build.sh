#!/bin/bash

##########################################
# Builds a Dockerfile for NODE_VERSION_X #
##########################################

set -e
echo "build: pwd: $(pwd)"
source ./tools/versions.env
source ./tools/resolve_envs.sh
echo "build: ls: $(ls -la)"
echo "build: ls of NODE_VERSION_PATH: $(ls -la ./${NODE_VERSION_PATH}/)"
docker build --no-cache -f ./${NODE_VERSION_PATH}/Dockerfile -t "vixlet/node:${IMAGE_NODE_VERSION}" ./${NODE_VERSION_PATH}