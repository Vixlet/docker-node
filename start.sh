#!/bin/bash
set -e


# Default values for environment variables
DEFAULT_CONTAINER_PREINSTALL="npm install --production --no-bin-links"
DEFAULT_CONTAINER_PRESTART="./docker-prestart.sh"


# Install dependencies?
if [ "${CONTAINER_PREINSTALL}" != "skip" ]; then
  echo "Installing production NPM dependencies..."
  ${CONTAINER_PREINSTALL:-$DEFAULT_CONTAINER_PREINSTALL}
fi


# Run user-specified pre-start command
if [ -n "${CONTAINER_PRESTART}" ]; then
  echo "Running custom prestart command..."
  ${CONTAINER_PRESTART}
# Run pre-start script, if it exists
elif [ -e "${DEFAULT_CONTAINER_PRESTART}" ] && [ -x "${DEFAULT_CONTAINER_PRESTART}" ]; then
  echo "Running prestart script..."
  ${DEFAULT_CONTAINER_PRESTART}
fi


# Start the container
if [ "${#}" -lt 1 ]; then
  echo "Starting Node (via \`npm start\`)..."
  exec npm start
else
  exec "${@}"
fi
