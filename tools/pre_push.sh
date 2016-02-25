#!/bin/bash

#########################################
# Runs build process for NODE_VERSION_X #
#########################################

set -e
echo "pre_push: pwd: $(pwd)"
./tools/make.sh
./tools/build.sh
./tools/test.sh
./tools/tag.sh