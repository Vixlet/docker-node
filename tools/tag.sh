#!/bin/bash

################################################
# Tag image with alternate tags NODE_VERSION_X #
################################################

set -e
echo "tag: pwd: $(pwd)"
source ./tools/versions.env
source ./tools/resolve_envs.sh
docker tag "vixlet/node:${IMAGE_NODE_VERSION}" "vixlet/node:${IMAGE_NODE_VERSION_SHORT}"
case "${NODE_VERSION_X}" in
  "${IMAGE_TAG_AS_STABLE}" )
    docker tag "vixlet/node:${IMAGE_NODE_VERSION}" "vixlet/node:stable"
    ;;
  "${IMAGE_TAG_AS_EDGE}" )
    docker tag "vixlet/node:${IMAGE_NODE_VERSION}" "vixlet/node:edge"
    ;;
  "${IMAGE_TAG_AS_LATEST}" )
    docker tag "vixlet/node:${IMAGE_NODE_VERSION}" "vixlet/node:latest"
    ;;
esac