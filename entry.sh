#!/bin/bash
set -e


# Default values for environment variables
DEFAULT_CONTAINER_PRESTART="./docker-prestart.sh"


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
