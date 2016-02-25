#!/bin/bash
set -e
cd "$( dirname "${BASH_SOURCE[0]}" )"
rm -rf node_modules
rm -f "Dockerfile.${IMAGE_NODE_VERSION}"
sed 's/\${IMAGE_NODE_VERSION}/'${IMAGE_NODE_VERSION}'/g' Dockerfile > "Dockerfile.${IMAGE_NODE_VERSION}"
npm install --production
docker build --no-cache -f "Dockerfile.${IMAGE_NODE_VERSION}" -t "vixlet-node-test-4-image" .
docker run -t --rm --name "vixlet-node-test-4" "vixlet-node-test-4-image"