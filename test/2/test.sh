#!/bin/bash
set -e
cd "$( dirname "${BASH_SOURCE[0]}" )"
rm -rf node_modules
docker-compose run --rm test