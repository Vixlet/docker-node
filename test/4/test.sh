#!/bin/bash
set -e
cd "$( dirname "${BASH_SOURCE[0]}" )"
rm -rf node_modules
rm -f "Dockerfile.${VERSION}"
sed 's/\${VERSION}/'${VERSION}'/g' Dockerfile > "Dockerfile.${VERSION}"
docker build -f "Dockerfile.${VERSION}" -t "vixlet-node-test-4-image" .
docker run -t --rm --name "vixlet-node-test-4" "vixlet-node-test-4-image"