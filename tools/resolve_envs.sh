#!/bin/bash

###################################################################
# Exports composite environment variables based on NODE_VERSION_X #
###################################################################

export NODE_VERSION="$(eval echo "\$NODE_VERSION_${NODE_VERSION_X}")"
export NODE_VERSION_PATH="${NODE_VERSION%.*}"
export IMAGE_NODE_VERSION="${IMAGE_VERSION}_node_${NODE_VERSION}"
export IMAGE_NODE_VERSION_SHORT="""${IMAGE_VERSION}_node_${NODE_VERSION_PATH}"