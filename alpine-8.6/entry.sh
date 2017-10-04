#!/bin/ash
set -e

# Start the container
if [ "${#}" -lt 1 ]; then
  echo "Starting Node (via \`npm start\`)..."
  exec npm start
else
  echo "Starting Container (via ad-hoc command \`${@}\`)..."
  exec "${@}"
fi
