#!/bin/bash

#############################################
# Rebuilds and run tests for NODE_VERSION_X #
#############################################

set -e
echo -e "\npre_push.sh...\n"
./tools/make.sh
./tools/build.sh
./tools/test.sh
./tools/tag.sh