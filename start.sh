#!/bin/bash
set -e


# Default values for environment variables
CONTAINER_PRESTART="${CONTAINER_PRESTART:-./docker-prestart.sh}"
DOCKER_PREINSTALL_COMMAND="${DOCKER_PREINSTALL_COMMAND:-npm install --production --no-bin-links}"


# Install dependencies?
if [ -z "${DOCKER_PREINSTALLED}" ]; then
  echo "Installing production NPM dependencies..."
  ${DOCKER_PREINSTALL_COMMAND}
fi


# Run user-specified pre-start script, if it exists
if [ -x ${CONTAINER_PRESTART} ]; then
  echo "Running docker prestart script..."
  ${CONTAINER_PRESTART}
fi


# Start the container
if [ "${#}" -lt 1 ]; then
  echo "Starting Node (via \`npm start\`)..."
  exec npm start
else
  exec "${@}"
fi
