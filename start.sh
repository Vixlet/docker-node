#!/bin/bash


# Install dependencies?
if [ $? -eq 0 ] && [ -z "${DOCKER_PREINSTALLED}" ]; then
  echo "Installing production NPM dependencies..." \
    && npm install --production --no-bin-links
fi


# Set default value for pre-start script environment variable
if [ $? -eq 0 ] && [ -z "${DOCKER_PRESTART_SCRIPT}" ]; then
  DOCKER_PRESTART_SCRIPT="./docker-prestart.sh"
fi


# Run user-specified pre-start script, if it exists
if [ $? -eq 0 ] && [ -x ${DOCKER_PRESTART_SCRIPT} ]; then
  echo "Running docker prestart script..." \
    && ${DOCKER_PRESTART_SCRIPT}
fi


# Start the container
if [ $? -eq 0 ] && [ "${#}" -lt 1 ]; then
  echo "Starting Node (via \`npm start\`)..."
  exec npm start
elif [ $? -eq 0 ]; then
  exec "${@}"
fi
