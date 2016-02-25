#!/bin/bash

##########################################
# Builds a Dockerfile for NODE_VERSION_X #
##########################################

set -e
echo "build: pwd: $(pwd)"
source ./tools/versions.env
source ./tools/resolve_envs.sh
docker build --no-cache -f ./${NODE_VERSION_PATH}/Dockerfile -t "vixlet/node:${IMAGE_NODE_VERSION}" ./${NODE_VERSION_PATH}