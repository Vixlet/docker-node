#!/bin/bash

#########################################
# Runs build process for NODE_VERSION_X #
#########################################

set -e
./tools/make.sh
./tools/build.sh
./tools/test.sh
./tools/tag.sh