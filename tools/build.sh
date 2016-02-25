#!/bin/bash

##########################################
# Builds a Dockerfile for NODE_VERSION_X #
##########################################

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )"
source ./versions.env
source ./resolve_envs.sh
docker build -f "../${NODE_VERSION_PATH}/Dockerfile" -t "vixlet/node:${IMAGE_NODE_VERSION}" "../${NODE_VERSION_PATH}"