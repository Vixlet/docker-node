#!/bin/bash


# Support multiple methods of starting node
if [ -z "${DOCKER_START_CMD}" ] || [ "${DOCKER_START_CMD}" == "npm" ]; then
  DOCKER_START_CMD="npm"
  if [ -z "${DOCKER_START_ARGS}" ]; then
    DOCKER_START_ARGS="start"
  fi
fi


# Determine which script to run...
if [ -z "${DOCKER_START_ARGS}" ]; then
  # Defer to Node's own smarty-pants algorithms...
  DOCKER_START_ARGS="."
fi


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


# Start node?
if [ -z "${DOCKER_START_BYPASS}" ]; then
  test $? && echo "Starting Node (via \`${DOCKER_START_CMD} ${DOCKER_START_ARGS}\`)..." \
    && ${DOCKER_START_CMD} ${DOCKER_START_ARGS}
fi
