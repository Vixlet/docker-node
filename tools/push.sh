#!/bin/bash

#######################################################
# Publish image tags to Docker Hub for NODE_VERSION_X #
#######################################################

set -e
echo "push: pwd: $(pwd)"
source ./tools/versions.env
source ./tools/resolve_envs.sh
docker push "vixlet/node:${IMAGE_NODE_VERSION}"
docker push "vixlet/node:${IMAGE_NODE_VERSION_SHORT}"
case "${NODE_VERSION_X}" in
  "${IMAGE_TAG_AS_STABLE}" )
    docker push "vixlet/node:stable"
    ;;
  "${IMAGE_TAG_AS_EDGE}" )
    docker push "vixlet/node:edge"
    ;;
  "${IMAGE_TAG_AS_LATEST}" )
    docker push "vixlet/node:latest"
    ;;
esac