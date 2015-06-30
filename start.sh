#!/bin/bash


# Set default value for pre-start script environment variable
if [ -z "${DOCKER_PRESTART_SCRIPT}" ]; then
  DOCKER_PRESTART_SCRIPT="./docker-prestart.sh"
fi


# Run user-specified pre-start script, if it exists
if [ -x ${DOCKER_PRESTART_SCRIPT} ]; then
  test $? && echo "Running docker prestart script..." \
    && ${DOCKER_PRESTART_SCRIPT}
fi


# Install dependencies?
if [ -z "${DOCKER_PREINSTALLED}" ]; then
  test $? && echo "Installing NPM dependencies..." \
    && npm install
fi
