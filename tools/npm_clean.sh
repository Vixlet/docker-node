#!/bin/bash

##############################################
# Delete all Dockerfiles and build artifacts #
##############################################

set -e
# the below is a macintosh- / darwin-specific command!
find -E . -type d -depth 1 -regex ".*[0-9]+\.[0-9]+" -print0 | xargs -0 rm -r