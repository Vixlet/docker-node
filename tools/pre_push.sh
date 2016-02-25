#!/bin/bash

#########################################
# Runs build process for NODE_VERSION_X #
#########################################

set -e
SCRIPT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )"; pwd)"
${SCRIPT_DIR}/make.sh
${SCRIPT_DIR}/build.sh
${SCRIPT_DIR}/test.sh
${SCRIPT_DIR}/tag.sh