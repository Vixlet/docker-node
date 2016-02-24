#!/bin/bash

echo "Hello from the Docker Prestart script!"

echo "Installing npm dependencies..."
npm install --production --no-bin-links
