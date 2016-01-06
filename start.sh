#!/bin/bash
set -e


# Default values for environment variables
DOCKER_PRESTART_SCRIPT="${DOCKER_PRESTART_SCRIPT:-./docker-prestart.sh}"


# Install dependencies?
if [ -z "${DOCKER_PREINSTALLED}" ]; then
  echo "Installing production NPM dependencies..."
  npm install --production --no-bin-links
fi


# Run user-specified pre-start script, if it exists
if [ -x ${DOCKER_PRESTART_SCRIPT} ]; then
  echo "Running docker prestart script..."
  ${DOCKER_PRESTART_SCRIPT}
fi


# Start the container
if [ "${#}" -lt 1 ]; then
  echo "Starting Node (via \`npm start\`)..."
  exec npm start
else
  exec "${@}"
fi
